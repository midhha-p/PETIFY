import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:petify/dhome/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ViewProfile());
}

class ViewProfile extends StatelessWidget {
  const ViewProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Profile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown.shade400),
        useMaterial3: true,
      ),
      home: const ViewProfilePage(title: 'View Profile'),
    );
  }
}

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key, required this.title});
  final String title;

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  String name_ = "";
  String email_ = "";
  String phone_ = "";
  String bike_no_ = "";
  String bike_details_ = "";
  String photo_ = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _send_data();
  }

  Future<void> _send_data() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();
    String imgurl = sh.getString('img').toString();

    final urls = Uri.parse('$url/myapp/del_view_profile/');
    try {
      final response = await http.post(urls, body: {'lid': lid});

      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          setState(() {
            name_ = jsonDecode(response.body)['name'].toString();
            email_ = jsonDecode(response.body)['email'].toString();
            phone_ = jsonDecode(response.body)['phone'].toString();
            bike_no_ = jsonDecode(response.body)['bike_no'].toString();
            bike_details_ = jsonDecode(response.body)['bike_details'].toString();
            photo_ = imgurl + jsonDecode(response.body)['photo'];
            isLoading = false;
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
          context,
          MaterialPageRoute(builder: (context) => delhome(title: '',)),
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.brown.shade100,
        appBar: AppBar(
          leading: const BackButton(),
          backgroundColor: Colors.brown.shade400,
          title: Text(widget.title),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Container(
            color: Colors.brown.shade100,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 80,
                  backgroundImage: photo_.isNotEmpty
                      ? NetworkImage(photo_)
                      : const AssetImage('assets/default_avatar.png')
                  as ImageProvider,
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.brown.shade400,
                  child: ListTile(
                    leading: const Icon(Icons.person, color: Colors.white),
                    title: Text(name_, style: const TextStyle(color: Colors.white)),
                    subtitle: const Text('Name', style: TextStyle(color: Colors.white70)),
                  ),
                ),
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.brown.shade400,
                  child: ListTile(
                    leading: const Icon(Icons.email, color: Colors.white),
                    title: Text(email_, style: const TextStyle(color: Colors.white)),
                    subtitle: const Text('Email', style: TextStyle(color: Colors.white70)),
                  ),
                ),
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.brown.shade400,
                  child: ListTile(
                    leading: const Icon(Icons.phone, color: Colors.white),
                    title: Text(phone_, style: const TextStyle(color: Colors.white)),
                    subtitle: const Text('Phone', style: TextStyle(color: Colors.white70)),
                  ),
                ),
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.brown.shade400,
                  child: ListTile(
                    leading: const Icon(Icons.motorcycle, color: Colors.white),
                    title: Text(bike_no_, style: const TextStyle(color: Colors.white)),
                    subtitle: const Text('Bike Number', style: TextStyle(color: Colors.white70)),
                  ),
                ),
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.brown.shade400,
                  child: ListTile(
                    leading: const Icon(Icons.details, color: Colors.white),
                    title: Text(bike_details_, style: const TextStyle(color: Colors.white)),
                    subtitle: const Text('Bike Details', style: TextStyle(color: Colors.white70)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
