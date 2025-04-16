// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const viewpetcart(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class viewpetcart extends StatefulWidget {
//   const viewpetcart({super.key, required this.title});
//
//
//   final String title;
//
//   @override
//   State<viewpetcart> createState() => _viewpetcartState();
// }
//
// class _viewpetcartState extends State<viewpetcart> {
//   List id_=[],petName_=[],petPhoto_=[],quantity_=[],amount_=[];
//
//
//   Future<void> viewreply() async {
//     List id=[],petName=[],petPhoto=[],quantity=[],amount=[];
//
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url').toString();
//       String lid = sh.getString('lid').toString();
//       String url = '$urls/myapp/user_viewreply/';
//
//       var data = await http.post(Uri.parse(url), body: {
//
//         'lid':lid
//
//       });
//       var jsondata = json.decode(data.body);
//       String statuss = jsondata['status'];
//
//       var arr = jsondata["data"];
//
//       print(arr.length);
//
//       for (int i = 0; i < arr.length; i++) {
//         id.add(arr[i]['id'].toString());
//         petName.add(arr[i]['petName']);
//         petPhoto.add(arr[i]['complaint']);
//         quantity.add(arr[i]['quantity']);
//         amount.add(arr[i]['amount']);
//       }
//
//       setState(() {
//         id_ = id;
//         petName_ = petName;
//         petPhoto_ = petPhoto;
//         quantity_ = quantity;
//         amount_ = amount;
//       });
//
//       print(statuss);
//     } catch (e) {
//       print("Error ------------------- " + e.toString());
//       //there is error during converting file image to base64 encoding.
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//
//
//           ],
//         ),
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: _incrementCounter,
//       //   tooltip: 'Increment',
//       //   child: const Icon(Icons.add),
//       // ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
