// import 'dart:convert';
//
// import 'package:flutter/material.dart';
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
//       home: const viewpetsandbuy(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class viewpetsandbuy extends StatefulWidget {
//   const viewpetsandbuy({super.key, required this.title});
//
//
//   final String title;
//
//   @override
//   State<viewpetsandbuy> createState() => _viewpetsandbuyState();
// }
//
// class _viewpetsandbuyState extends State<viewpetsandbuy> {
//
//   _viewpetsandbuyState(){
//     viewreply();
//   }
//
//   List id_=[],photo_=[],breed_=[],age_=[],description_=[],price_=[],name_=[],gender_=[],type_=[],place_=[],post_=[],phoneNo_=[];
//
//
//   Future<void> viewreply() async {
//     List id=[],photo=[],breed=[],age=[],description=[],price=[],name=[],gender=[],type=[],place=[],post=[],phoneNo=[];
//
//
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url').toString();
//       String lid = sh.getString('lid').toString();
//       String url = '$urls/myapp/flutter_viewpet_get/';
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
//         name.add(arr[i]['name'].toString());
//         place.add(arr[i]['place'].toString());
//         post.add(arr[i]['post'].toString());
//         phoneNo.add(arr[i]['phone_no'].toString());
//         gender.add(arr[i]['gender'].toString());
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
//         name_ = name;
//         place_ = place;
//         post_ = post;
//         phoneNo_ = phoneNo;
//         type_ = type;
//         gender_=gender;
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
//                                   Padding(
//                                     padding: EdgeInsets.all(5),
//                                     child: Text(name_[index]),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.all(5),
//                                     child: Text(phoneNo_[index]),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.all(5),
//                                     child: Text(place_[index]),
//                                   ),
//
//
//                                   ElevatedButton(
//                                     onPressed: () async {
//
//                                       SharedPreferences sh = await SharedPreferences.getInstance();
//                                       sh.setString("pet", id_[index]);
//
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(builder: (context) => addtocart(title: '',)),
//                                       );
//
//
//
//
//                                     },
//                                     child: Text("Add To Cart"),
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
//         )
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
import 'package:petify/home/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'addtocart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petify',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const viewpetsandbuy(title: 'Browse Pets'),
    );
  }
}

class viewpetsandbuy extends StatefulWidget {
  const viewpetsandbuy({super.key, required this.title});

  final String title;

  @override
  State<viewpetsandbuy> createState() => _viewpetsandbuyState();
}

class _viewpetsandbuyState extends State<viewpetsandbuy> {
  List id_ = [],
      photo_ = [],
      breed_ = [],
      age_ = [],
      description_ = [],
      price_ = [],
      name_ = [],
      gender_ = [],
      place_ = [],
      post_ = [],
      phoneNo_ = [];

  _viewpetsandbuyState() {
    viewReply();
  }

  Future<void> viewReply() async {
    List id = [],
        photo = [],
        breed = [],
        age = [],
        description = [],
        price = [],
        name = [],
        gender = [],
        place = [],
        post = [],
        phoneNo = [];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/myapp/flutter_viewpet_get/';

      var data = await http.post(Uri.parse(url), body: {'lid': lid});
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        photo.add(urls + arr[i]['photo'].toString());
        breed.add(arr[i]['breed'].toString());
        age.add(arr[i]['age'].toString());
        description.add(arr[i]['description'].toString());
        price.add(arr[i]['price'].toString());
        name.add(arr[i]['name'].toString());
        place.add(arr[i]['place'].toString());
        post.add(arr[i]['post'].toString());
        phoneNo.add(arr[i]['phone_no'].toString());
        gender.add(arr[i]['gender'].toString());
      }

      setState(() {
        id_ = id;
        photo_ = photo;
        breed_ = breed;
        age_ = age;
        description_ = description;
        price_ = price;
        name_ = name;
        place_ = place;
        post_ = post;
        phoneNo_ = phoneNo;
        gender_ = gender;
      });
    } catch (e) {
      print("Error: " + e.toString());
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
          backgroundColor:Colors.brown.shade400 ,
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView.builder(
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.6, // Adjust this to control the height-to-width ratio
            ),
            itemCount: id_.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 5,
                shadowColor: Colors.deepPurpleAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    // Image of the pet
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        photo_[index],
                        height: 150, // Increased the height of the image
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Pet details
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            breed_[index],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            description_[index],
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "\$${price_[index]}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15,horizontal: 8),
                              primary: Colors.white,
                            ),
                            onPressed: () async {
                              SharedPreferences sh =
                              await SharedPreferences.getInstance();
                              sh.setString("pet", id_[index]);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => addtocart(title: 'Add to Cart')),
                              );
                            },
                            child: Text("Add to Cart"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
