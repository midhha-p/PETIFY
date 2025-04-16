// import 'dart:convert';
//
// import 'package:flutter/material.dart';
//
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
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
//       home: const viewveterinary(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class viewveterinary extends StatefulWidget {
//   const viewveterinary({super.key, required this.title});
//
//
//   final String title;
//
//   @override
//   State<viewveterinary> createState() => _viewveterinaryState();
// }
//
// class _viewveterinaryState extends State<viewveterinary> {
//   _viewveterinaryState(){
//     viewvet();
//   }
//
//
//   List id_=[],clinic_=[],location_=[],photo_=[],latitude_=[],longitude_=[],phone_number_=[],email_=[];
//
//
//   Future<void> viewvet() async {
//     List id=[],clinic=[],location=[],photo=[],latitude=[],longitude=[],phone_number=[],email=[];
//
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url').toString();
//       String lid = sh.getString('lid').toString();
//       String img = sh.getString('img').toString();
//       String url = '$urls/myapp/view_nearby_vets/';
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
//         photo.add(img+arr[i]['Photo'].toString());
//         clinic.add(arr[i]['Clinic'].toString());
//         location.add(arr[i]['Location'].toString());
//         latitude.add(arr[i]['Latitude'].toString());
//         longitude.add(arr[i]['Longitude'].toString());
//         phone_number.add(arr[i]['Phone_Number'].toString());
//         email.add(arr[i]['Email'].toString());
//
//
//       }
//
//       setState(() {
//         id_ = id;
//         photo_ = photo;
//         clinic_ = clinic;
//         location_ = location;
//         latitude_= latitude;
//         longitude_ = longitude;
//         phone_number_ = phone_number;
//         email_= email;
//
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
//     return WillPopScope(
//       onWillPop: ()async{
//         // Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(title: '')));
//         return true;
//
//       },
//
//       child: Scaffold(
//           appBar: AppBar(
//
//             backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//             title: Text(widget.title),
//           ),
//           body:
//
//           ListView.builder(
//             physics: BouncingScrollPhysics(),
//             itemCount: id_.length,
//             itemBuilder: (BuildContext context, int index) {
//               return GestureDetector(
//                 onLongPress: () {
//                   print("Long press on index: " + index.toString());
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16.0),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.1),
//                           blurRadius: 12.0,
//                           offset: Offset(0, 6),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         // Product Image
//                         ClipRRect(
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(16.0),
//                             topRight: Radius.circular(16.0),
//                           ),
//                           child: Image.network(
//                             photo_[index],
//                             height: 180,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Product Name
//                               Text(
//                                 clinic_[index],
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                               SizedBox(height: 8),
//                               // Product Description
//                               Text(
//                                 location_[index],
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey[700],
//                                   height: 1.4,
//                                 ),
//                               ),
//                               SizedBox(height: 10),
//                               // Price Section
//                               Row(
//                                 children: [
//                                   Text(
//                                     "Phone no: ",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                   Text(
//                                     phone_number_[index],
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.grey[700],
//                                       height: 1.4,
//                                     ),
//                                   ),
//                                   // Text(
//                                   //   "Email:",
//                                   //   style: TextStyle(
//                                   //     fontSize: 16,
//                                   //     color: Colors.black,
//                                   //   ),
//                                   // ),
//                                 ],
//                               ),
//                               SizedBox(height: 10),
//                               Row(
//                                 children: [
//                                   Text(
//                                     "Email: ",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                   Text(
//                                     email_[index],
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.grey[700],
//                                       height: 1.4,
//                                     ),
//                                   ),
//                                   // Text(
//                                   //   "Email:",
//                                   //   style: TextStyle(
//                                   //     fontSize: 16,
//                                   //     color: Colors.black,
//                                   //   ),
//                                   // ),
//                                 ],
//                               ),
//                               Row(
//                                 children: [  ElevatedButton(onPressed: (){
//
//                                   }, child: Text("TRACK"))]
//
//                               )
//                               // Shop Info Section
//                               // Row(
//                               //   children: [
//                               //     CircleAvatar(
//                               //       radius: 20,
//                               //       backgroundImage: NetworkImage(photo_[index]),
//                               //     ),
//                               //     SizedBox(width: 10),
//                               //     Column(
//                               //       crossAxisAlignment: CrossAxisAlignment.start,
//                               //       children: [
//                               //         Text(
//                               //           longitude_[index],
//                               //           style: TextStyle(
//                               //             fontSize: 16,
//                               //             fontWeight: FontWeight.bold,
//                               //             color: Colors.black54,
//                               //           ),
//                               //         ),
//                               //         Text(
//                               //           phone_number_[index],
//                               //           style: TextStyle(
//                               //             fontSize: 14,
//                               //             color: Colors.grey[600],
//                               //           ),
//                               //         ),          Text(
//                               //           email_[index],
//                               //           style: TextStyle(
//                               //             fontSize: 14,
//                               //             color: Colors.grey[600],
//                               //           ),
//                               //         ),
//                               //       ],
//                               //     ),
//                               //   ],
//                               // ),
//                               // Add to Cart Button
//
//
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           )
//
//         // floatingActionButton: FloatingActionButton(
//         //   onPressed: _incrementCounter,
//         //   tooltip: 'Increment',
//         //   child: const Icon(Icons.add),
//         // ), // This trailing comma makes auto-formatting nicer for build methods.
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:petify/home/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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
      home: const viewveterinary(title: 'Flutter Demo Home Page'),
    );
  }
}

class viewveterinary extends StatefulWidget {
  const viewveterinary({super.key, required this.title});

  final String title;

  @override
  State<viewveterinary> createState() => _viewveterinaryState();
}

class _viewveterinaryState extends State<viewveterinary> {
  _viewveterinaryState(){
    viewvet();
  }

  List id_=[],clinic_=[],location_=[],photo_=[],latitude_=[],longitude_=[],phone_number_=[],email_=[];

  Future<void> viewvet() async {
    List id=[],clinic=[],location=[],photo=[],latitude=[],longitude=[],phone_number=[],email=[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String img = sh.getString('img').toString();
      String url = '$urls/myapp/view_nearby_vets/';

      var data = await http.post(Uri.parse(url), body: {

        'lid':lid

      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        photo.add(img+arr[i]['Photo'].toString());
        clinic.add(arr[i]['Clinic'].toString());
        location.add(arr[i]['Location'].toString());
        latitude.add(arr[i]['Latitude'].toString());
        longitude.add(arr[i]['Longitude'].toString());
        phone_number.add(arr[i]['Phone_Number'].toString());
        email.add(arr[i]['Email'].toString());


      }

      setState(() {
        id_ = id;
        photo_ = photo;
        clinic_ = clinic;
        location_ = location;
        latitude_= latitude;
        longitude_ = longitude;
        phone_number_ = phone_number;
        email_= email;


      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }

  // Future<void> _launchMaps(String latitude, String longitude) async {
  //   // final String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
  //   final Uri googleMapsUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=40.7128,-74.0060");
  //   if (await canLaunch(googleMapsUrl)) {
  //     await launch(googleMapsUrl);
  //   } else {
  //     throw 'Could not launch $googleMapsUrl';
  //   }
  // }


  Future<void> lop_launchMaps(String latitude, String longitude) async {
    final Uri googleMapsUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(title: '')));


        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.brown.shade400,
            title: Text(widget.title),
          ),
          body: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: id_.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onLongPress: () {
                  print("Long press on index: " + index.toString());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 12.0,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                          child: Image.network(
                            photo_[index],
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                clinic_[index],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                location_[index],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    "Phone no: ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    phone_number_[index],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    "Email: ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    email_[index],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // _launchMaps(latitude_[index], longitude_[index]);

                                        lop_launchMaps(latitude_[index], longitude_[index]);                                      },
                                      child: Text("TRACK"),
                                    )
                                  ]
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
      ),
    );
  }
}