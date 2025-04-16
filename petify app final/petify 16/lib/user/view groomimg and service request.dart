import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:petify/user/userhome.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../home/main.dart';

void main() {
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown.shade400),
        useMaterial3: true,
      ),
      home: const viewgroomingandservicerequest(title: 'Flutter Demo Home Page'),
    );
  }
}

class viewgroomingandservicerequest extends StatefulWidget {
  const viewgroomingandservicerequest({super.key, required this.title});


  final String title;

  @override
  State<viewgroomingandservicerequest> createState() => _viewgroomingandservicerequestState();

}

class _viewgroomingandservicerequestState extends State<viewgroomingandservicerequest> {

  List id_=[],groomingName_=[],groomingPrice_=[],packageDetails_=[],shopName_=[],status_=[],t_=[];


  Future<void> viewreply() async {
    List id=[],groomingName=[],groomingPrice=[],packageDetails=[],shopName=[],status=[],t=[];


    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/myapp/flutter_userviewreq_get/';

      var data = await http.post(Uri.parse(url), body: {

        'lid':lid

      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        groomingName.add(arr[i]['grooming_name'].toString());
        groomingPrice.add(arr[i]['grooming_price'].toString());
        packageDetails.add(arr[i]['package_details'].toString());
        status.add(arr[i]['status'].toString());
        t.add(arr[i]['t'].toString());

        shopName.add(arr[i]['shop_name'].toString());

      }

      setState(() {
        id_ = id;
        groomingName_ = groomingName;
        groomingPrice_ = groomingPrice;
        packageDetails_ = packageDetails;
        shopName_ = shopName;
        status_ = status;
        t_ = t;


      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    viewreply();


    // Initializing Razorpay
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // Disposing Razorpay instance to avoid memory leaks
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Handle successful payment
    print("Payment Successful: ${response.paymentId}");

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/myapp/Grooming_payment/');
    try {
      final response = await http.post(urls, body: {
        "mid": sh.getString("midd").toString(),
        "lid": lid,
        'amount':sh.getString("amt").toString()
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Fluttertoast.showToast(msg: 'PaymentSuccessfully');
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => Home(),
          ));
        } else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }





  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
    print("Error in Payment: ${response.code} - ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
    print("External Wallet: ${response.walletName}");
  }

  Future<void> _openCheckout() async {
    SharedPreferences sh=await SharedPreferences.getInstance();

    int am= int.parse(sh.getString("amt").toString()) *100;

    var options = {
      'key': 'rzp_test_HKCAwYtLt0rwQe', // Replace with your Razorpay API key
      'amount': am, // Amount in paise (e.g. 2000 paise = Rs 20)
      'name': 'Flutter Razorpay Example',
      'description': 'Payment for the product',
      'prefill': {'contact': '9747360170', 'email': 'tlikhil@gmail.com'},
      'external': {
        'wallets': ['paytm'] // List of external wallets
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
    }
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()async{
        // return true;


        Navigator.push(context, MaterialPageRoute(
          builder: (context) => MainScreen(title: '',),
        ));
        return false;
      },
      child: Scaffold(

        appBar: AppBar(

          backgroundColor: Colors.brown.shade400,
          title: Text(widget.title),
        ),
          body:
          ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: id_.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onLongPress: () {
                  print("Long press on index: " + index.toString());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 12.0,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Grooming Service Name
                          Text("Grooming name: "+
                            groomingName_[index],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),

                          // Price and Package Details
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Price: "+
                                    groomingPrice_[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text("Details: "+
                                    packageDetails_[index],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  Text("Shopname: "+
                                      shopName_[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text("Status: "+
                                      status_[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              // Shop Name

                            ],
                          ),

                          SizedBox(height: 16),

                          // Request Button
                          status_[index]=="Approved"?ElevatedButton(
                            onPressed: () async {
                              SharedPreferences sh=await SharedPreferences.getInstance();
                              sh.setString("midd", id_[index]);
                              sh.setString("amt", groomingPrice_[index]);
                             _openCheckout();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12),
                              primary: Colors.white,
                            ),
                            child: Text(
                              "Pay",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ):Text(""),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _incrementCounter,
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.add),
        // ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
