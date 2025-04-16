import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:petify/dhome/screens/main_screen.dart';

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
      home: const ViewAssignedWork(title: 'Assigned Work'),
    );
  }
}

class ViewAssignedWork extends StatefulWidget {
  const ViewAssignedWork({super.key, required this.title});
  final String title;

  @override
  State<ViewAssignedWork> createState() => _ViewAssignedWorkState();
}

class _ViewAssignedWorkState extends State<ViewAssignedWork> {
  _ViewAssignedWorkState() {
    viewReply();
  }

  List<String> id_ = [], date_ = [], amount_ = [], status_ = [],
      username_ = [], phone_ = [], city_ = [], place_ = [],
      pincode_ = [], email_ = [];

  Future<void> viewReply() async {
    List<String> id = [], date = [], amount = [], status = [],
        username = [], phone = [], city = [], place = [],
        pincode = [], email = [];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/myapp/del_viewassignedworg/';

      var data = await http.post(Uri.parse(url), body: {'lid': lid});
      var jsonData = json.decode(data.body);
      var arr = jsonData["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        date.add(arr[i]['date'].toString());
        amount.add(arr[i]['amount'].toString());
        status.add(arr[i]['statuss'].toString());
        pincode.add(arr[i]['pincode'].toString());
        place.add(arr[i]['place'].toString());
        city.add(arr[i]['city'].toString());
        email.add(arr[i]['email'].toString());
        username.add(arr[i]['username'].toString());
        phone.add(arr[i]['phone'].toString());
      }

      setState(() {
        id_ = id;
        date_ = date;
        amount_ = amount;
        status_ = status;
        pincode_ = pincode;
        place_ = place;
        city_ = city;
        email_ = email;
        username_ = username;
        phone_ = phone;
      });
    } catch (e) {
      print("Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const delhome(title: '',)),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown.shade400,
          title: Text(widget.title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const delhome(title: '',)),
              );
            },
          ),
        ),
        backgroundColor: Colors.brown.shade100,
        body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: id_.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              child: Card(
                color: Colors.brown.shade400,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Date: ${date_[index]}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                      const SizedBox(height: 8),
                      Text("Amount: ${amount_[index]}", style: const TextStyle(color: Colors.white)),
                      Text("Status: ${status_[index]}", style: const TextStyle(color: Colors.white)),
                      Text("Username: ${username_[index]}", style: const TextStyle(color: Colors.white)),
                      Text("Place: ${place_[index]}", style: const TextStyle(color: Colors.white)),
                      Text("City: ${city_[index]}", style: const TextStyle(color: Colors.white)),
                      Text("Pincode: ${pincode_[index]}", style: const TextStyle(color: Colors.white)),
                      Text("Email: ${email_[index]}", style: const TextStyle(color: Colors.white)),
                      Text("Phone: ${phone_[index]}", style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 16),
                      if (status_[index] == 'pending') ...[
                        ElevatedButton(
                          onPressed: () async {
                            SharedPreferences sh = await SharedPreferences.getInstance();
                            String url = sh.getString('url').toString();
                            String lid = sh.getString('lid').toString();
                            final urls = Uri.parse('$url/myapp/del_update_order/');

                            try {
                              final response = await http.post(urls, body: {
                                "lid": lid,
                                "oid": id_[index],
                              });

                              if (response.statusCode == 200) {
                                String status = jsonDecode(response.body)['status'];
                                if (status == 'ok') {
                                  Fluttertoast.showToast(msg: 'Updated Successfully');
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const deliveryhome()));
                                } else {
                                  Fluttertoast.showToast(msg: 'Update Failed');
                                }
                              } else {
                                Fluttertoast.showToast(msg: 'Network Error');
                              }
                            } catch (e) {
                              Fluttertoast.showToast(msg: e.toString());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.brown.shade800,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Update Order"),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
