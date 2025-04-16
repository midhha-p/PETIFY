import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petify/home/screens/components/side_menu.dart';
import 'package:petify/home/widgets/courses_grid.dart';
import 'package:petify/user/ChatBot.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constant.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const MainScreen(title: 'Flutter Demo Home Page'),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});
  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  _MainScreenState() {
    loadUserImage();
  }

  String name_ = "";
  String images_ = "";

  void loadUserImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String imgUrl = prefs.getString("img_url") ?? "";
    final String imgName = prefs.getString('img_') ?? "";
    final String image = imgUrl + imgName;
    String names = prefs.getString('nam_') ?? "";

    setState(() {
      name_ = names;
      images_ = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Exit the app on back press
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.brown.shade400,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.grey, size: 28),
          actions: [
            Container(
              margin: const EdgeInsets.only(top: 5, right: 16, bottom: 5),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(title: ''),
                    ),
                  );
                },
                child: const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('images/pic/chatbot.png'),
                ),
              ),
            ),
          ],
        ),
        drawer: const SideMenu(),
        body: Container(
          decoration: BoxDecoration(color: Colors.brown.shade100),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Hello ",
                      style: TextStyle(color: kDarkBlue, fontSize: 20),
                      children: [
                        TextSpan(
                          text: name_,
                          style: TextStyle(
                              color: kDarkBlue, fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: ", welcome back!",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const CourseGrid(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
//