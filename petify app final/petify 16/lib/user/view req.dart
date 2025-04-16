import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:petify/home/main.dart';
import 'package:petify/user/userhome.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../dhome/screens/main_screen.dart';

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

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const viewreq(title: 'Flutter Demo Home Page'),
    );
  }
}

class viewreq extends StatefulWidget {
  const viewreq({super.key, required this.title});


  final String title;

  @override
  State<viewreq> createState() => _viewreqState();

}





class _viewreqState extends State<viewreq> {
  _viewreqState(){
    viewreply();
  }
  String amounts_="0";


  List id_=[],groomingName_=[],groomingPrice_=[],packageDetails_=[],shopName_=[],status_=[],date_=[],paystatus_=[];


  Future<void> viewreply() async {
    List id=[],groomingName=[],groomingPrice=[],packageDetails=[],shopName=[],status=[],date=[],paystatus=[];


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
        date.add(arr[i]['date'].toString());
        shopName.add(arr[i]['shop_name'].toString());
        paystatus.add(arr[i]['paystatus'].toString());


      }

      setState(() {
        id_ = id;
        groomingName_ = groomingName;
        groomingPrice_ = groomingPrice;
        packageDetails_ = packageDetails;
        shopName_ = shopName;
        date_ = date;
        status_=status;
        paystatus_=paystatus;


      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()async{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(title: '')));
        return false;

      },

      child: Scaffold(
        appBar: AppBar(

          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
          body: ListView.builder(
            physics: BouncingScrollPhysics(),
            // padding: EdgeInsets.all(5.0),
            // shrinkWrap: true,
            itemCount: id_.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onLongPress: () {
                  print("long press" + index.toString());
                },
                title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Card(
                          child:
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Name"),
                                    Text(groomingName_[index]),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text("Price"),
                                    Text(groomingPrice_[index]),
                                  ],
                                ),
                              ), Padding(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text("Details"),
                                    Text(packageDetails_[index]),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text("Shop name"),
                                    Text(shopName_[index]),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text("Date"),
                                    Text(date_[index]),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text("Status"),
                                    Text(status_[index]),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text("payStatus"),
                                    Text(paystatus_[index]),
                                  ],
                                ),
                              ),

                            if(paystatus_[index]=='Approved')...{

                              ElevatedButton(onPressed: () async {


                                final pref =await SharedPreferences.getInstance();
                                pref.setString("sid", id_[index].toString());
                                pref.setString("amount", groomingPrice_[index].toString());



                                _openCheckout(groomingPrice_[index]);
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => userviewrating(title: '',)),);

                              }, child: Text('Payment'))

                            }else...{

                              }

                            ],
                          )

                          ,
                          elevation: 8,
                          margin: EdgeInsets.all(10),
                        ),
                      ],
                    )),
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
    String mid = sh.getString('sid').toString();
    String lid = sh.getString('lid').toString();
    String amount= sh.getString('amount').toString();

    final urls = Uri.parse('$url/myapp/Grooming_payment/');
    try {
      final response = await http.post(urls, body: {
        'lid': lid,
        'mid': mid,
        'amount':amount,


      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {


        } else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      }
      else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    }
    catch (e) {
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

  void _openCheckout(amount_) {

    double am= double.parse(amount_.toString()) *100;

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

}




