// import 'package:flutter/material.dart';
// import 'package:petify/home/main.dart';
// import 'package:petify/user/view%20payement.dart';
// import 'package:petify/user/view%20veterinary.dart';
// import 'package:petify/user/viewproduct.dart';
// import 'package:petify/user/sell%20pets%20and%20adopt.dart';
// import 'package:petify/user/send%20rating.dart';
// import 'package:petify/user/user%20view%20profile.dart';
// import 'package:petify/user/user%20view%20rating.dart';
// import 'package:petify/user/view%20cart%20product.dart';
// import 'package:petify/user/view%20groomimg%20and%20service%20request.dart';
// import 'package:petify/user/view%20my%20pets.dart';
// import 'package:petify/user/view%20pets%20and%20buy.dart';
// import 'package:petify/user/view%20req.dart';
// import 'package:petify/user/viewcart.dart';
// import 'package:petify/user/viewproductcart.dart';
//
// import '../dhome/screens/main_screen.dart';
// import '../login page.dart';
// import 'change password.dart';
// import 'disease prediction.dart';
// import 'ChatBot.dart';
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
//       home: const userhomepage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class userhomepage extends StatefulWidget {
//   const userhomepage({super.key, required this.title});
//
//
//   final String title;
//
//   @override
//   State<userhomepage> createState() => _userhomepageState();
// }
//
// class _userhomepageState extends State<userhomepage> {
//
//   @override
//   Widget build(BuildContext context) {
//
//     return WillPopScope(
//       onWillPop: ()async{
//         Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(title: '')));
//         return false;
//
//       },
//
//       child: Scaffold(
//         appBar: AppBar(
//
//           backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//           title: Text(widget.title),
//         ),
//         body:  Drawer(
//           // Add a ListView to the drawer. This ensures the user can scroll
//           // through the options in the drawer if there isn't enough vertical
//           // space to fit everything.
//           child: ListView(
//             // Important: Remove any padding from the ListView.
//             padding: EdgeInsets.zero,
//             children: [
//               const DrawerHeader(
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                 ),
//                 child: Text('Drawer Header'),
//               ),
//               ListTile(
//                 title: const Text('home'),
//                 onTap: () {
//                   // Update the state of the app.
//                   Navigator.push(context, MaterialPageRoute(
//                     builder: (context) => userhomepage(title: "user homepage"),));
//                   // ...
//                   // ...
//                   // ...
//                 },
//               ),
//               ListTile(
//                 title: const Text('profile'),
//                 onTap: () {
//                   // Update the state of the app.
//
//                   Navigator.push(context, MaterialPageRoute(
//                     builder: (context) => UserViewProfile(title: " profile"),));
//                   // ...
//                 },
//               ),
//               ListTile(
//                 title: const Text('Change Password'),
//                 onTap: () {
//                   // Update the state of the app.
//                   Navigator.push(context, MaterialPageRoute(
//                     builder: (context) => changepassword(title: "change password"),));
//                   // ...
//                   // ...
//                 },
//               ),
//               ListTile(
//                 title: const Text('View Pets '),
//                 onTap: () {
//                   // Update the state of the app.
//                   Navigator.push(context, MaterialPageRoute(
//                     builder: (context) => viewpetsandbuy(title: "view pets and buy"),));
//                   // ...
//                   // ...
//                   // ...
//                 },
//               ),
//               ListTile(
//                 title: const Text('View My Pets '),
//                 onTap: () {
//                   // Update the state of the app.
//                   Navigator.push(context, MaterialPageRoute(
//                     builder: (context) => ViewMyPets(title: "view my pets"),));
//                   // ...
//                   // ...
//                   // ...
//                 },
//               ),
//
//
//               ListTile(
//                 title: const Text('View Cart '),
//                 onTap: () {
//                   // Update the state of the app.
//                   Navigator.push(context, MaterialPageRoute(
//                     builder: (context) => Viewcart(title: "view cart"),));
//                   // ...
//                   // ...
//                   // ...
//                 },
//               ),
//               ListTile(
//                 title: const Text('Sell And Adopt Pet'),
//                 onTap: () {
//                   // Update the state of the app.
//                   Navigator.push(context, MaterialPageRoute(
//                     builder: (context) => sellpetsandadopt(),));
//                   // ...
//                   // ...
//                   // ...
//                 },
//               ),
//               ListTile(
//                 title: const Text(' Payment'),
//                 onTap: () {
//                   // Update the state of the app.
//                   Navigator.push(context, MaterialPageRoute(
//                     builder: (context) => viewpayement(title: "payments"),));
//                   // ...
//                 },
//               ),
//               ListTile(
//                 title: const Text('Send Rating'),
//                 onTap: () {
//                   // Update the state of the app.
//                   Navigator.push(context, MaterialPageRoute(
//                     builder: (context) => sendrating(title: "send rating"),));
//                   // ...
//                   // ...
//                   // ...
//                 },
//
//               ),
//               ListTile(
//                 title: const Text('View Rating'),
//                 onTap: () {
//                   // Update the state of the app.
//                   Navigator.push(context, MaterialPageRoute(
//                     builder: (context) => userviewrating(title: "user view rating"),));
//                   // ...
//                   // ...
//                   // ...
//                 },
//               ),
//               ListTile(
//                 title: const Text('View Pet Products'),
//                 onTap: () {
//                   // Update the state of the app.
//                   Navigator.push(context, MaterialPageRoute(
//                     builder: (context) => viewproduct(title: "view product"),));
//                   // ...
//                   // ...
//                   // ...
//                 },
//               ),
//               ListTile(
//                 title: const Text('view pet product cart'),
//                 onTap: () {
//                   // Update the state of the app.
//                   Navigator.push(context, MaterialPageRoute(
//                     // builder: (context) => viewproductcart(title: "view pet product cart"),));
//                     builder: (context) => viewproductcartnew(title: "view pet product cart"),));
//                   // ...
//                   // ...
//                   // ...
//                 },
//               ),
//               ListTile(
//                 title: const Text('View Grooming Services'),
//                 onTap: () {
//                   // Update the state of the app.
//                   Navigator.push(context, MaterialPageRoute(
//                     builder: (context) => viewgroomingandservicerequest(title: "view grooming  service "),));
//                   // ...
//                   // ...
//
//                   // ...
//                 },
//               ),
//               ListTile(
//                 title: const Text('Mate Suggestion'),
//                 onTap: () {
//                   // Update the state of the app.
//                   Navigator.push(context, MaterialPageRoute(
//                     builder: (context) => matesuggestion(title: "mate suggestion"),));
//                   // ...
//                   // ...
//                   // ...
//                 },
//               ),
//               ListTile(
//                 title: const Text('Disease Prediction'),
//                 onTap: () {
//                   // Update the state of the app.
//                   Navigator.push(context, MaterialPageRoute(
//                     builder: (context) => diseaseprediction(title: "disease prediction"),));
//                   // ...
//                   // ...
//                   // ...
//                 },
//               ),
//               ListTile(
//                 title: const Text(' View Grooming Request Status'),
//                 onTap: () {
//                   // Update the state of the app.
//                   Navigator.push(context, MaterialPageRoute(
//                     builder: (context) => viewreq(title: "View Grooming Request Status"),));
//                   // ...
//                   // ...
//                   // ...
//                 },
//               ),
//       ListTile(
//                 title: const Text(' Logout'),
//                 onTap: () {
//                   // Update the state of the app.
//                   Navigator.push(context, MaterialPageRoute(
//                     builder: (context) => login_page(title: "Logout"),));
//                   // ...
//                   // ...
//                   // ...
//                 },
//               ),
//               ListTile(
//                 title: const Text(' View Nearby Vet'),
//                 onTap: () {
//                   // Update the state of the app.
//                   Navigator.push(context, MaterialPageRoute(
//                     builder: (context) => viewveterinary(title: "View  Nearby Vets"),));
//                   // ...
//                   // ...
//                   // ...
//                 },
//               ),
//
//             ],
//           ),
//         )
//         // floatingActionButton: FloatingActionButton(
//         //   onPressed: _incrementCounter,
//         //   tooltip: 'Increment',
//         //   child: const Icon(Icons.add),
//         // ), // This trailing comma makes auto-formatting nicer for build methods.
//       ),
//     );
//   }
// }
//
//
// //
// // import 'package:flutter/material.dart';
// //
// // void main() => runApp(const MyApp());
// //
// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});
// //
// //   static const appTitle = 'Drawer Demo';
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return const MaterialApp(
// //       title: appTitle,
// //       home: userhomepage(title: appTitle),
// //     );
// //   }
// // }
// //
// // class userhomepage extends StatefulWidget {
// //   const userhomepage({super.key, required this.title});
// //
// //   final String title;
// //
// //   @override
// //   State<userhomepage> createState() => _userhomepageState();
// // }
// //
// // class _userhomepageState extends State<userhomepage> {
// //   int _selectedIndex = 0;
// //   static const TextStyle optionStyle =
// //   TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
// //   static const List<Widget> _widgetOptions = <Widget>[
// //     Text(
// //       'Index 0: Home',
// //       style: optionStyle,
// //     ),
// //     Text(
// //       'Index 1: Business',
// //       style: optionStyle,
// //     ),
// //     Text(
// //       'Index 2: School',
// //       style: optionStyle,
// //     ),
// //   ];
// //
// //   void _onItemTapped(int index) {
// //     setState(() {
// //       _selectedIndex = index;
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(widget.title),
// //         leading: Builder(
// //           builder: (context) {
// //             return IconButton(
// //               icon: const Icon(Icons.menu),
// //               onPressed: () {
// //                 Scaffold.of(context).openDrawer();
// //               },
// //             );
// //           },
// //         ),
// //       ),
// //       body: Center(
// //         child: _widgetOptions[_selectedIndex],
// //       ),
// //       drawer: Drawer(
// //         // Add a ListView to the drawer. This ensures the user can scroll
// //         // through the options in the drawer if there isn't enough vertical
// //         // space to fit everything.
// //         child: ListView(
// //           // Important: Remove any padding from the ListView.
// //           padding: EdgeInsets.zero,
// //           children: [
// //             const DrawerHeader(
// //               decoration: BoxDecoration(
// //                 color: Colors.blue,
// //               ),
// //               child: Text('Drawer Header'),
// //             ),
// //             ListTile(
// //               title: const Text('Home'),
// //               selected: _selectedIndex == 0,
// //               onTap: () {
// //                 // Update the state of the app
// //                 _onItemTapped(0);
// //                 // Then close the drawer
// //                 Navigator.pop(context);
// //               },
// //             ),
// //             ListTile(
// //               title: const Text('Business'),
// //               selected: _selectedIndex == 1,
// //               onTap: () {
// //                 // Update the state of the app
// //                 _onItemTapped(1);
// //                 // Then close the drawer
// //                 Navigator.pop(context);
// //               },
// //             ),
// //             ListTile(
// //               title: const Text('School'),
// //               selected: _selectedIndex == 2,
// //               onTap: () {
// //                 // Update the state of the app
// //                 _onItemTapped(2);
// //                 // Then close the drawer
// //                 Navigator.pop(context);
// //               },
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
