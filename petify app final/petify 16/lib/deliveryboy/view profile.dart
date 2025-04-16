// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
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
//       home: const viewprofile(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class viewprofile extends StatefulWidget {
//   const viewprofile({super.key, required this.title});
//
//
//   final String title;
//
//   @override
//   State<viewprofile> createState() => _viewprofileState();
// }
//
// class _viewprofileState extends State<viewprofile> {
//
//   _viewprofileState(){
//     getdata();
//   }
//
//
//
//
//   String name="";
//   String phone_no="";
//   String bike_no="";
//   String bike_details="";
//   String email="";
//   String photo="";
//
//
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
//             Text(" name :$name "),
//             Text(" phone_no :$phone_no "),
//             Text(" bike_no :$bike_no "),
//             Text(" bikw_details :$bike_details "),
//             Text(" email :$email "),
//             Text(" photo :$photo "),
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
//   getdata() async {
//
//
//
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     String lid = sh.getString('lid').toString();
//     String imgurl = sh.getString('imgurl').toString();
//
//     final urls = Uri.parse('$url/myapp/del_view_profile/');
//     try {
//
//       final response = await http.post(urls, body: {
//         "lid":lid,
//
//
//
//       });
//       if (response.statusCode == 200) {
//         String status = jsonDecode(response.body)['status'];
//
//         if (status=='ok') {
//           setState(() {
//             name = jsonDecode(response.body)['name'].toString();
//             bike_no = jsonDecode(response.body)['bike_no'].toString();
//             phone_no = jsonDecode(response.body)['phone_no'].toString();
//             bike_details = jsonDecode(response.body)['bike_details'].toString();
//             email = jsonDecode(response.body)['email'].toString();
//             photo = jsonDecode(imgurl+response.body)['photo'].toString();
//
//           });
//
//
//         }else {
//           Fluttertoast.showToast(msg: 'Not Found');
//         }
//       }
//       else {
//         Fluttertoast.showToast(msg: 'Network Error');
//       }
//     }
//     catch (e){
//       Fluttertoast.showToast(msg: e.toString());
//     }
//
//   }
//
// }
