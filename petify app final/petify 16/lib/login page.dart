import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:petify/home/main.dart';
import 'package:petify/user/register.dart';
import 'package:petify/user/userhome.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const login_page(title: 'Flutter Demo Home Page'),
    );
  }
}

class login_page extends StatefulWidget {
  const login_page({super.key, required this.title});


  final String title;

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
                controller: username,
                decoration: InputDecoration(labelText: "username"),

              ),
            ),
            Padding(padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: password,
                decoration: InputDecoration(labelText: "password"),


              ),
            ),


            Padding(padding: EdgeInsets.all(10),

                child: ElevatedButton(onPressed: (){
                  senddata();
                }, child: Text("login"))),
            Padding(padding: EdgeInsets.all(10),

                child: ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => register(title: "SIGNUP"),));
                }, child: Text("SIGNUP")))




          ],
        ),

      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  senddata() async {
    String username_=username.text;
    String password_=password.text;




    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();

    final urls = Uri.parse('$url/myapp/flutter_login_get/');
    try {

      final response = await http.post(urls, body: {
        "username":username_,
        "password":password_,
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        String type = jsonDecode(response.body)['type'];
        if (status=='ok') {
          String lid = jsonDecode(response.body)['lid'];
          sh.setString('lid', lid);
          if(type=='deliveryboy'){
            Fluttertoast.showToast(msg: 'Registration Successfull');
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => login_page(title: "Login"),));
          }
          if(type=='user'){
            Fluttertoast.showToast(msg: 'Registration Successfull');
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => MainScreen(title: "Login"),));
          }


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
