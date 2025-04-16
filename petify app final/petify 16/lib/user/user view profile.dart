import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:petify/home/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../dhome/screens/main_screen.dart';
import 'editprofile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown.shade400),
        useMaterial3: true,
      ),
      home: const UserViewProfile(title: 'My Profile'),
    );
  }
}

class UserViewProfile extends StatefulWidget {
  const UserViewProfile({super.key, required this.title});

  final String title;

  @override
  State<UserViewProfile> createState() => _UserViewProfileState();
}

class _UserViewProfileState extends State<UserViewProfile> {
  _UserViewProfileState() {
    getdata();
  }

  String username = "";
  String email = "";
  String phoneNo = "";
  String place = "";
  String dob = "";
  String gender = "";
  String photo = "";
  String city = "";
  String state = "";
  String pin = "";

  getdata() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String img = sh.getString('img').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/myapp/user_view_profile/');
    try {
      final response = await http.post(urls, body: {
        "lid": lid,
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];

        if (status == 'ok') {
          setState(() {
            username = jsonDecode(response.body)['name'].toString();
            email = jsonDecode(response.body)['email'].toString();
            phoneNo = jsonDecode(response.body)['phoneNo'].toString();
            place = jsonDecode(response.body)['place'].toString();
            dob = jsonDecode(response.body)['dob'].toString();
            gender = jsonDecode(response.body)['gender'].toString();
            photo = img + jsonDecode(response.body)['photo1'].toString();
            city = jsonDecode(response.body)['city'].toString();
            state = jsonDecode(response.body)['state'].toString();
            pin = jsonDecode(response.body)['pin'].toString();
          });
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreen(title: "")));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown.shade400,
          title: Text(widget.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen(title: "")));
            },
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.brown,
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.brown, Colors.white60],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(photo),
                          backgroundColor: Colors.brown,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          username,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                          ),
                        ),
                        Text(
                          email,
                          style: const TextStyle(fontSize: 16, color: Colors.black45),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ListView(
                        children: [
                          _buildDetailCard(Icons.phone, "Phone Number", phoneNo),
                          _buildDetailCard(Icons.place, "Place", place),
                          _buildDetailCard(Icons.calendar_today, "Date of Birth", dob),
                          _buildDetailCard(Icons.person, "Gender", gender),
                          _buildDetailCard(Icons.location_city, "City", city),
                          _buildDetailCard(Icons.map, "State", state),
                          _buildDetailCard(Icons.pin_drop, "Pin", pin),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      editprofile(title: "Edit Profile"),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text("Edit Profile"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.brown.shade500,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(IconData icon, String label, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.brown.shade300),
        title: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value),
      ),
    );
  }
}
