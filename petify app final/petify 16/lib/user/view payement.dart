import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:petify/user/productaddtocart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
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
      home: const viewpayement(title: 'Flutter Demo Home Page'),
    );
  }
}

class viewpayement extends StatefulWidget {
  const viewpayement({super.key, required this.title});


  final String title;

  @override
  State<viewpayement> createState() => _viewpayementState();
}

class _viewpayementState extends State<viewpayement> {
  _viewpayementState(){
    viewreply();
  }



  List id_=[],date_=[],status1_=[],Payment_Details_=[],Order_Details_=[],ptype_=[];


  Future<void> viewreply() async {
    List id=[],date=[],status1=[],Payment_Details=[],Order_Details=[],ptype=[];


    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String imurl = sh.getString('imurl').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/myapp/view_payments/';

      var data = await http.post(Uri.parse(url), body: {

        'lid':lid

      });
      var jsondata = json.decode(data.body);
      String status = jsondata['status'];

      var arr = jsondata["data"];

      print(arr.length);


      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        date.add(arr[i]['date'].toString());
        status1.add(arr[i]['status'].toString());
        Payment_Details.add(arr[i]['Payment_Details'].toString());
        Order_Details.add(arr[i]['Order_Details'].toString());
        ptype.add(arr[i]['ptype'].toString());

      }

      setState(() {
        id_ = id;
        date_ = date;
        status1_ = status1;
        Payment_Details_ =Payment_Details;
        Order_Details_ = Order_Details;
        ptype_ = ptype;
      });

      print(status);
    } catch (e) {
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()async{
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown.shade400,
          title: Text(widget.title),
        ),
           body:
    Container(
    color: Colors.brown.shade100,
    child:ListView.builder(
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
                          Row(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(date_[index]),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(status1_[index]),
                                    ), Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(Payment_Details_[index]),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(Order_Details_[index]),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(ptype_[index]),
                                    ),

                                    // ElevatedButton(
                                    //   onPressed: () async {
                                    //
                                    //     SharedPreferences sh = await SharedPreferences.getInstance();
                                    //     sh.setString("pid", id_[index]);
                                    //
                                    //     Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(builder: (context) => productaddtocart(title: '',)),
                                    //     );
                                    //
                                    //
                                    //
                                    //
                                    //   },
                                    //   child: Text("Add To Cart"),
                                    // ),

                                  ],
                                ),
                              ]
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
      ));
  }
}
