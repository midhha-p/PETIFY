import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:petify/user/userhome.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/main.dart';






void main() {
  runApp(const ViewSlot());
}

class ViewSlot extends StatelessWidget {
  const ViewSlot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Materials',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF184A2C)),
        useMaterial3: true,
      ),
      home: const Viewcart(title: ''),
    );
  }
}

class Viewcart extends StatefulWidget {
  const Viewcart({super.key, required this.title});

  final String title;

  @override
  State<Viewcart> createState() => _ViewcartState();
}

class _ViewcartState extends State<Viewcart> {

  _ViewcartState(){
    ViewSlot();
  }

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();

    ViewSlot();

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

    final urls = Uri.parse('$url/myapp/cartpayment_pet/');
    try {
      final response = await http.post(urls, body: {
        'lid':lid,



      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status=='ok') {
          Fluttertoast.showToast(msg: 'success');

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainScreen(title: 'home')),);


        }else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      }
      else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    }
    catch (e){
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

  void _openCheckout() {

    int am= int.parse(amount_) *100;

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

  String amount_="0";
  List<String> id_ = <String>[];
  List<String> breed_= <String>[];
  List<String> price_= <String>[];
  List<String> quantity_= <String>[];
  List<String> photo_= <String>[];
  List<String> description_= <String>[];

  get status => null;

  Future<void> ViewSlot() async {
    List<String> id = <String>[];
    List<String> price = <String>[];
    List<String> breed = <String>[];
    List<String> quantity = <String>[];
    List<String> photo = <String>[];
    List<String> description = <String>[];


    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/myapp/user_view_pets_cart/';

      var data = await http.post(Uri.parse(url), body: {
        'lid': lid
      });
      print(data.body);  // Print the raw data

      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];
      String amount = jsondata['amount'].toString();

      var arr = jsondata["data"];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        price.add(arr[i]['price'].toString());
        breed.add(arr[i]['breed'].toString());
        quantity.add(arr[i]['quantity'].toString());
        description.add(arr[i]['description'].toString());
        photo.add(sh.getString('img').toString()+arr[i]['photo']);

      }

      setState(() {
        id_ = id;
        amount_=amount;
        price_ = price;
        quantity_ = quantity;
        description_ = description;
        photo_ = photo;
        breed_ = breed;

      });

      print(statuss);
    } catch (e) {
      print("Network Error: $e");
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }

  TextEditingController tc= new TextEditingController();
  void _showInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter quantity '),
          content: TextField(
            controller: tc,
            decoration: InputDecoration(hintText: "Enter qunitity"),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {

                SharedPreferences sh = await SharedPreferences.getInstance();
                String url = sh.getString('url').toString();
                String lid = sh.getString('lid').toString();
                String selmid = sh.getString('selmid').toString();

                final urls = Uri.parse('$url/user_addto_cart/');
                try {
                  final response = await http.post(urls, body: {

                    'lid':lid,
                    'mid': selmid,
                    'qty':tc.text.toString()



                  });
                  if (response.statusCode == 200) {
                    String status = jsonDecode(response.body)['status'];

                    if (status == 'ok') {

                      Fluttertoast.showToast(msg: 'Added to cart');
                      Navigator.of(context).pop();

                    }
                    else {
                      Fluttertoast.showToast(msg: 'Failed to add cart');
                      Navigator.of(context).pop();
                    }
                  }                }
                catch (e){
                  Fluttertoast.showToast(msg: e.toString());
                }

                // Do something with the input
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {



    return WillPopScope(
      onWillPop: () async{ return true; },
      child: Scaffold(
        backgroundColor: Colors.brown.shade300,
        appBar: AppBar(
          leading: BackButton( onPressed:() {

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),);


          },),

          backgroundColor: Colors.white,
          foregroundColor: Colors.black,

          title: Text(widget.title),
            actions: [
              Text(
                amount_
             ),
        IconButton(
        icon: Icon(Icons.payment),
        onPressed: () {

          _openCheckout();





          // Add action logic here
        },
      ),]
        ),


        body: Container(decoration: BoxDecoration(
          // image: DecorationImage(
          //     image: AssetImage('assets/'), fit: BoxFit.cover),
        ),
          child: ListView.builder(

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
                          child: Stack(
                            children: [
                              // Background image
                              Container(
                                width: double.infinity,
                                height: 450,
                                child: Image.network(
                                  photo_[index], // Your image URL here
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Overlay text
                              Positioned(
                                top: 20,
                                left: 20,
                                child: Text(
                                  breed_[index],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // Content below image
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  color: Colors.black.withOpacity(0.5), // Overlay color
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Quantity',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        quantity_[index],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        'Price info',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        price_[index],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        'Description',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        description_[index],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              // Button on top right
                              Positioned(
                                top: 20,
                                right: 20,
                                child:
                                IconButton(
                                  onPressed: () async {
                                    try {
                                      SharedPreferences sh = await SharedPreferences.getInstance();
                                      String urls = sh.getString('url').toString();

                                      String url = '$urls/myapp/remove_item_get/';

                                      var data = await http.post(Uri.parse(url), body: {
                                        'cid': id_[index]
                                      });
                                      print(data.body);  // Print the raw data

                                      var jsondata = json.decode(data.body);
                                      String statuss = jsondata['status'];

                                      Fluttertoast.showToast(msg: "Item deleted");
                                      ViewSlot();

                                      print(statuss);
                                    } catch (e) {
                                      print("Network Error: $e");
                                      print("Error ------------------- " + e.toString());
                                      // There is an error during converting file image to base64 encoding.
                                    }
                                  },
                                  icon: Icon(
                                    Icons.clear, // Cross icon
                                    color: Colors.red, // Red color
                                  ),
                                  tooltip: 'Remove from Cart',
                                ),

                                // ElevatedButton(
                                //   onPressed: () async {
                                //
                                //
                                //     try {
                                //       SharedPreferences sh = await SharedPreferences.getInstance();
                                //       String urls = sh.getString('url').toString();
                                //
                                //       String url = '$urls/deletefromcart/';
                                //
                                //       var data = await http.post(Uri.parse(url), body: {
                                //         'cid': id_[index]
                                //       });
                                //       print(data.body);  // Print the raw data
                                //
                                //       var jsondata = json.decode(data.body);
                                //       String statuss = jsondata['status'];
                                //
                                //
                                //           Fluttertoast.showToast(msg: "Item deleted");
                                //           ViewSlot();
                                //
                                //
                                //       print(statuss);
                                //     } catch (e) {
                                //       print("Network Error: $e");
                                //       print("Error ------------------- " + e.toString());
                                //       //there is error during converting file image to base64 encoding.
                                //     }
                                //
                                //
                                //
                                //
                                //
                                //
                                //     // Button action
                                //   },
                                //   child: Text(
                                //     'Remove from cart',
                                //     style: TextStyle(
                                //       color: Colors.white,
                                //       fontSize: 16,
                                //       fontWeight: FontWeight.bold,
                                //     ),
                                //   ),
                                //
                                // ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              );
            },
          ),
        ),



      ),
    );
  }
}