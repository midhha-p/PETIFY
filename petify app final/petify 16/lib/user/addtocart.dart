import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:petify/home/main.dart';
import 'package:petify/user/view%20pet%20cart.dart';
import 'package:petify/user/viewcart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../dhome/screens/main_screen.dart';
import '../login page.dart';

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

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const addtocart(title: 'Flutter Demo Home Page'),
    );
  }
}

class addtocart extends StatefulWidget {
  const addtocart({super.key, required this.title});


  final String title;

  @override
  State<addtocart> createState() => _addtocartState();
}

class _addtocartState extends State<addtocart> {
  TextEditingController quantitycontroller = new TextEditingController();


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()async{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(title: '')));
        return true;

      },

      child: Scaffold(
        appBar: AppBar(

          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: quantitycontroller,
                  decoration: InputDecoration(labelText: "quantity"),
                ),
              ),


              Padding(padding: EdgeInsets.all(10),

                  child: ElevatedButton(onPressed: (){
                    senddata();
                  }, child: Text("add to cart")))



            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _incrementCounter,
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.add),
        // ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
  senddata() async {
    String quantity=quantitycontroller.text;


    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();
    String pet = sh.getString('pet').toString();

    final urls = Uri.parse('$url/myapp/addtocart_get/');
    try {

      final response = await http.post(urls, body: {
        "quantity":quantity,
        "lid":lid,
        'pet':pet,
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status=='ok') {

          Fluttertoast.showToast(msg: 'Successfully Added');
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => Viewcart(title: "View Cart"),));
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
}
