import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:petify/user/addtocart.dart';
import 'package:petify/user/productaddtocart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../dhome/screens/main_screen.dart';

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
      home: const viewproduct(title: 'Flutter Demo Home Page'),
    );
  }
}

class viewproduct extends StatefulWidget {
  const viewproduct({super.key, required this.title});


  final String title;

  @override
  State<viewproduct> createState() => _viewproductState();
}

class _viewproductState extends State<viewproduct> {
  _viewproductState(){
    viewreply();
  }


  List id_=[],photo_=[],product_name_=[],type_=[],description_=[],price_=[],shop_name_=[],shopPlace_=[],shopPost_=[],shopPhone_=[];


  Future<void> viewreply() async {
    List id=[],photo=[],product_name=[],type=[],description=[],price=[],shop_name=[],shopPlace=[],shopPost=[],shopPhone=[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String img = sh.getString('img').toString();
      String url = '$urls/myapp/flutter_viewpetproducts_get/';

      var data = await http.post(Uri.parse(url), body: {

        'lid':lid

      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        photo.add(img+arr[i]['photo'].toString());
        product_name.add(arr[i]['product_name'].toString());
        shop_name.add(arr[i]['shop_name'].toString());
        description.add(arr[i]['description'].toString());
        price.add(arr[i]['price'].toString());
        shopPlace.add(arr[i]['shopPlace'].toString());
        type.add(arr[i]['type'].toString());
        shopPost.add(arr[i]['shopPost'].toString());
        shopPhone.add(arr[i]['shopPhone'].toString());

      }

      setState(() {
        id_ = id;
        photo_ = photo;
        product_name_ = product_name;
        shop_name_ = shop_name;
        description_ = description;
        price_ = price;
        shopPlace_ = shopPlace;
        type_ = type;
        shopPost_ = shopPost;
        shopPhone_ = shopPhone;

      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()async{
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(title: '')));
        return true;

      },

      child: Scaffold(
          appBar: AppBar(

            backgroundColor:Colors.brown.shade400,
            title: Text(widget.title),
          ),
          body:

          ListView.builder(
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
                        // Product Image
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
                              // Product Name
                              Text(
                                product_name_[index],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8),
                              // Product Description
                              Text(
                                description_[index],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(height: 10),
                              // Price Section
                              Row(
                                children: [
                                  Text(
                                    "Price: ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Text(
                                    price_[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              // Shop Info Section
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(photo_[index]),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        shop_name_[index],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        shopPhone_[index],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              // Add to Cart Button
                              ElevatedButton(
                                onPressed: () async {
                                  SharedPreferences sh = await SharedPreferences.getInstance();
                                  sh.setString("pid", id_[index]);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => addtocart(title: '',)),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  primary: Colors.blueAccent,
                                ),
                                child: Text(
                                  "Add To Cart",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
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

        // floatingActionButton: FloatingActionButton(
        //   onPressed: _incrementCounter,
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.add),
        // ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
