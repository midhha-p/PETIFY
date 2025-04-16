// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:petify/user/sell%20pets%20and%20adopt.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import 'addtocart.dart';
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
//       home: const ViewMyPets(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class ViewMyPets extends StatefulWidget {
//   const ViewMyPets({super.key, required this.title});
//
//
//   final String title;
//
//   @override
//   State<ViewMyPets> createState() => _ViewMyPetsState();
// }
//
// class _ViewMyPetsState extends State<ViewMyPets> {
//
//   _ViewMyPetsState(){
//     viewreply();
//   }
//
//   List id_=[],photo_=[],breed_=[],age_=[],description_=[],price_=[],gender_=[],type_=[];
//
//
//   Future<void> viewreply() async {
//     List id=[],photo=[],breed=[],age=[],description=[],price=[],shopName=[],gender=[],type=[];
//
//
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url').toString();
//       String lid = sh.getString('lid').toString();
//       String url = '$urls/myapp/flutter_viewmypets_get/';
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
//         photo.add(urls+arr[i]['photo'].toString());
//         breed.add(arr[i]['breed'].toString());
//         age.add(arr[i]['age'].toString());
//         description.add(arr[i]['description'].toString());
//         price.add(arr[i]['price'].toString());
//         gender.add(arr[i]['gender'].toString());
//         type.add(arr[i]['type'].toString());
//
//       }
//
//       setState(() {
//         id_ = id;
//         photo_ = photo;
//         breed_ = breed;
//         age_ = age;
//         description_ = description;
//         price_ = price;
//         gender_ = gender;
//         type_ = type;
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
//         body: ListView.builder(
//           physics: BouncingScrollPhysics(),
//           // padding: EdgeInsets.all(5.0),
//           // shrinkWrap: true,
//           itemCount: id_.length,
//           itemBuilder: (BuildContext context, int index) {
//             return ListTile(
//               onLongPress: () {
//                 print("long press" + index.toString());
//               },
//               title: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       Card(
//                         child:
//                         Row(
//                             children: [
//                               CircleAvatar(radius: 50,backgroundImage: NetworkImage(photo_[index])),
//                               Column(
//                                 children: [
//                                   Padding(
//                                     padding: EdgeInsets.all(5),
//                                     child: Text(breed_[index]),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.all(5),
//                                     child: Text(description_[index]),
//                                   ), Padding(
//                                     padding: EdgeInsets.all(5),
//                                     child: Text(price_[index]),
//                                   ),
//
//                                   ElevatedButton(
//                                     onPressed: () async {
//
//                                       SharedPreferences sh = await SharedPreferences.getInstance();
//                                       sh.setString("pet", id_[index]);
//
//                                       // Navigator.push(
//                                       //   context,
//                                       //   MaterialPageRoute(builder: (context) => (title: '',)),
//                                       // );
//
//
//
//
//                                     },
//                                     child: Text("View Order"),
//                                   ),
//                                 ],
//                               ),
//
//                             ]
//                         )
//
//                         ,
//                         elevation: 8,
//                         margin: EdgeInsets.all(10),
//                       ),
//                     ],
//                   )),
//             );
//           },
//         ),
//       floatingActionButton: FloatingActionButton(onPressed: () {
//
//         Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => sellpetsandadopt()));
//
//       },
//         child: Icon(Icons.add),
//       ),
//
//
//
//
//
//
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: _incrementCounter,
//       //   tooltip: 'Increment',
//       //   child: const Icon(Icons.add),
//       // ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
//
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:petify/main.dart';
import 'package:petify/user/sell%20pets%20and%20adopt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../dhome/screens/main_screen.dart';
import '../home/main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petify - My Pets',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const ViewMyPets(title: 'My Pets'),
    );
  }
}

class ViewMyPets extends StatefulWidget {
  const ViewMyPets({super.key, required this.title});
  final String title;

  @override
  State<ViewMyPets> createState() => _ViewMyPetsState();
}

class _ViewMyPetsState extends State<ViewMyPets> {
  _ViewMyPetsState() {
    viewMyPets();
  }

  List id_ = [], photo_ = [], breed_ = [], age_ = [], description_ = [], price_ = [], gender_ = [], type_ = [];

  Future<void> viewMyPets() async {
    List id = [], photo = [], breed = [], age = [], description = [], price = [], gender = [], type = [];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url') ?? '';
      String lid = sh.getString('lid') ?? '';
      String url = '$urls/myapp/flutter_viewmypets_get/';

      var response = await http.post(Uri.parse(url), body: {'lid': lid});
      var jsondata = json.decode(response.body);
      String status = jsondata['status'];
      var data = jsondata["data"];

      for (int i = 0; i < data.length; i++) {
        id.add(data[i]['id'].toString());
        photo.add('$urls${data[i]['photo']}');
        breed.add(data[i]['breed'].toString());
        age.add(data[i]['age'].toString());
        description.add(data[i]['description'].toString());
        price.add(data[i]['price'].toString());
        gender.add(data[i]['gender'].toString());
        type.add(data[i]['type'].toString());
      }

      setState(() {
        id_ = id;
        photo_ = photo;
        breed_ = breed;
        age_ = age;
        description_ = description;
        price_ = price;
        gender_ = gender;
        type_ = type;
      });
    } catch (e) {
      print("Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(title: "")));
        return false;

      },

      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.brown.shade400,
        ),
        body:
        id_.isNotEmpty
            ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: id_.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.6, // Adjust this value for taller cards
            ),
            itemBuilder: (context, index) {
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      child: Image.network(
                        photo_[index],
                        height: 150, // Increased height for the image
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            breed_[index],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Age: ${age_[index]}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            '₹${price_[index]}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              ElevatedButton(
                                onPressed: () async {


                                  Fluttertoast.showToast(msg: "Deleted Succesfully");

                                        SharedPreferences sh = await SharedPreferences.getInstance();
                                        String url = sh.getString('url').toString();
                                        String lid = sh.getString('lid').toString();

                                        final urls = Uri.parse('$url/myapp/deletepet_flutt/');


                                        print(url);
                                        try {
                                        final response = await http.post(urls, body: {

                                        "lid": lid,
                                          'pid':id_[index],

                                        });

                                        if (response.statusCode == 200) {
                                        String status = jsonDecode(response.body)['status'];
                                        if (status == 'ok') {
                                        Fluttertoast.showToast(msg: 'Deleted Successfully');
                                        Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                        builder: (context) => const Home(),
                                        ),
                                        );
                                        } else {
                                        Fluttertoast.showToast(msg: 'Error: Unable to add review');
                                        }
                                        } else {
                                        Fluttertoast.showToast(msg: 'Network Error');
                                        }
                                        } catch (e) {
                                        Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
                                        }





                                 },
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(fontSize: 12),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        )
            : const Center(child: CircularProgressIndicator()),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => sellpetsandadopt(title: '',)));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
