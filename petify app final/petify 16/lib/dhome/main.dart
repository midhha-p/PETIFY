// import 'package:chatbot/home/screens/components/side_menu.dart';
// // import 'package:chatbot/home/widgets/dlvrymain.dart';
// import 'package:flutter/material.dart';
// import 'package:petify/home/screens/components/side_menu.dart';
// import 'package:petify/home/widgets/dlvrymain.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// // import '../profile.dart';
// // import '../profile/pages/profile_page.dart';
// import 'constant.dart';
//
// void main() {
//   runApp(const Home());
// }
//
// class Home extends StatelessWidget {
//   const Home({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MainScreen(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   _MainScreenState(){
//     loadUserImage();
//   }
//
//
//   String name_ = "";
//   String images_="";
//
//   void loadUserImage() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String image = prefs.getString("img_url").toString()+prefs.getString('img_').toString();
//     String names = prefs.getString('nam_') ?? '';
//
//
//     print(image+"hiii");
//
//     setState(() {
//
//       name_=names;
//       images_=image;
//     });
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         iconTheme: const IconThemeData(color: Colors.grey, size: 28),
//         actions: [
//           // IconButton(
//           //   onPressed: () {},
//           //   icon: const Icon(
//           //     Icons.search,
//           //     color: Colors.grey,
//           //   ),
//           // ),
//           // IconButton(
//           //   onPressed: () {},
//           //   icon: const Icon(
//           //     Icons.notifications,
//           //     color: Colors.grey,
//           //   ),
//           // ),
//           // FutureBuilder to handle async image loading
//           Container(
//             margin: const EdgeInsets.only(top: 5, right: 16, bottom: 5),
//             child: GestureDetector(
//                 onTap: () {
//                   // Get the title or any user-specific data to pass to the profile screen
//                   // Navigator.push(
//                   //   context,
//                   //   MaterialPageRoute(
//                   //     builder: (context) => ProfilePage(
//                   //       // Replace with actual data or title
//                   //     ),
//                   //   ),
//                   // );
//                 },
//                 child: CircleAvatar(
//                   backgroundImage: NetworkImage(images_),
//                 )
//
//             ),
//           ),
//         ],
//       ),
//       drawer: const SideMenu(),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               RichText(
//                 text:  TextSpan(
//                   text: "Hello ",
//                   style: TextStyle(color: kDarkBlue, fontSize: 20),
//                   children: [
//                     TextSpan(
//                       text: name_,
//                       style: TextStyle(
//                           color: kDarkBlue, fontWeight: FontWeight.bold),
//                     ),
//                     TextSpan(
//                       text: ", welcome back!",
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               const CourseGrid(),
//               const SizedBox(
//                 height: 20,
//               ),
//               // const PlaningHeader(),
//               // const SizedBox(
//               //   height: 15,
//               // ),
//               // const PlaningGrid(),
//               // const SizedBox(
//               //   height: 15,
//               // ),
//               // const Text(
//               //   "Statistics",
//               //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               // ),
//               // const SizedBox(
//               //   height: 15,
//               // ),
//               // const StatisticsGrid(),
//               // const SizedBox(
//               //   height: 15,
//               // ),
//               // const ActivityHeader(),
//               // const ChartContainer(chart: BarChartContent()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
