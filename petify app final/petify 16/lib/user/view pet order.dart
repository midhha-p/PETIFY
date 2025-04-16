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
//       home: const viewpetorder(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class viewpetorder extends StatefulWidget {
//   const viewpetorder({super.key, required this.title});
//
//
//   final String title;
//
//   @override
//   State<viewpetorder> createState() => _viewpetorderState();
// }
//
// class _viewpetorderState extends State<viewpetorder> {
//   List id_=[],date_=[],status_=[],amount_=[];
//
//
//   Future<void> viewreply() async {
//     List id=[],date=[],status=[],amount=[];
//
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
//         date.add(arr[i]['date']);
//         status.add(arr[i]['status']);
//         amount.add(arr[i]['amount']);
//
//       }
//
//       setState(() {
//         id_ = id;
//         date_ = date;
//         status_ = status;
//         amount_ = amount;
//
//       });
//
//       print(statuss);
//     } catch (e) {
//       print("Error ------------------- " + e.toString());
//       //there is error during converting file image to base64 encoding.
//     }
//   }
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
//
//
//           ],
//         ),
//       ),
//     
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:petify/home/main.dart';
import 'package:petify/user/chat.dart';
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
      home: const viewpetorder(title: 'Pet Orders'),
    );
  }
}

class viewpetorder extends StatefulWidget {
  const viewpetorder({super.key, required this.title});

  final String title;

  @override
  State<viewpetorder> createState() => _viewpetorderState();
}

class _viewpetorderState extends State<viewpetorder> {
  List id_ = [],
      date_ = [],
  deliveryboyname_ = [],
  deliveryboyphone_ = [],
      amount_ = [],
  petname_ = [],
  quantity_ = [],
      petprice_ = [],
      shopname_ = [],
      loginid_ = [];
  bool isLoading = true;

  Future<void> viewReply() async {
    List id = [], date = [], deliveryboyname=[],deliveryboyphone=[],amount = [],petname=[],quantity=[],petprice=[],shopname=[],loginid=[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/myapp/user_view_orders/';

      var data = await http.post(Uri.parse(url), body: {
        'lid': lid
      });

      var jsondata = json.decode(data.body);
      String status = jsondata['status'];

      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        date.add(arr[i]['date'].toString());
        deliveryboyname.add(arr[i]['deliveryboyname'].toString());
        deliveryboyphone.add(arr[i]['deliveryboyphone'].toString());
        amount.add(arr[i]['amount'].toString());
        petname.add(arr[i]['petname'].toString());
        quantity.add(arr[i]['quantity'].toString());
        petprice.add(arr[i]['petprice'].toString());
        shopname.add(arr[i]['shopname'].toString());
        loginid.add(arr[i]['loginid'].toString());
      }

      setState(() {
        id_ = id;
        date_ = date;
        deliveryboyname_ = deliveryboyname;
        deliveryboyphone_ = deliveryboyphone;
        amount_ = amount;
        petname_ = petname;
        quantity_ = quantity;
        petprice_= petprice;
        shopname_ = shopname;
        loginid_ = loginid;
        isLoading = false;
      });
    } catch (e) {
      print("Error: " + e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    viewReply();
  }

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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: id_.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 5,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text('Order ID: ${id_[index]}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${date_[index]}'),
                      Text('deliveryboyname: ${deliveryboyname_[index]}'),
                      Text('deliveryboyphone: ${deliveryboyphone_[index]}'),
                      Text('Amount: ${amount_[index]}'),
                      Text('petname: ${petname_[index]}'),
                      Text('quantity: ${quantity_[index]}'),
                      Text('petprice: ${petprice_[index]}'),
                      Text('shopname: ${shopname_[index]}'),
                      Text('loginid: ${loginid_[index]}'),



                      ElevatedButton(onPressed: () async {
                        SharedPreferences sh = await SharedPreferences.getInstance();
                        sh.setString('aid', loginid_[index]);
                        sh.setString('name', shopname_[index]);


                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyChatPage(
                                  title: '',
                                )));


                      }, child: Text("Chat With Shop"))
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
