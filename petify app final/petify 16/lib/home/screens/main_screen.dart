import 'dart:convert';
//
// import 'package:chatbot/ghhg.dart';
// import 'package:chatbot/reg/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:petify/deliveryboy/viewprofilenew.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../deliveryboy/view profile.dart';
import '../../reg/loginPage.dart';
import '../constant.dart';
import '../widgets/courses_grid.dart';
import 'components/side_menu.dart';
import 'package:http/http.dart' as http;

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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

  _MainScreenState()
  {
    // loadUserImage();
  }


  String name = "";
  String images_="";
  void loadUserImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String image = prefs.getString('image').toString();
    final String names = prefs.getString('name') ?? '';


    print(image+"hiii");

    setState(() {

      name=names;
      images_=image;
    });

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.grey, size: 28),
          actions: [

            Container(
              margin: const EdgeInsets.only(top: 5, right: 16, bottom: 5),
              child: GestureDetector(
                onTap: () {
                  // Get the title or any user-specific data to pass to the profile screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewProfilePage(
                        title: "User's Profile", // Replace with actual data or title
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(images_),
                )

              ),
            ),
          ],
        ),
        drawer: const SideMenu(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                  text:  TextSpan(
                    text: "Hello ",
                    style: TextStyle(color: kDarkBlue, fontSize: 20),
                    children: [
                      TextSpan(
                        text: name,
                        style: TextStyle(
                            color: kDarkBlue, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ", welcome back!",
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const CourseGrid(),
                // const SizedBox(
                //   height: 20,
                // ),
                // const PlaningHeader(),
                // const SizedBox(
                //   height: 15,
                // ),
                // const PlaningGrid(),
                // const SizedBox(
                //   height: 15,
                // ),
                // const Text(
                //   "Statistics",
                //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(
                //   height: 15,
                // ),
                // const StatisticsGrid(),
                // const SizedBox(
                //   height: 15,
                // ),
                // const ActivityHeader(),
                // const ChartContainer(chart: BarChartContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
