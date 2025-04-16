import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:petify/dhome/screens/main_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ViewReply());
}

class ViewReply extends StatelessWidget {
  const ViewReply({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Reply',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 121, 85, 72)), // Brownish seed color
        useMaterial3: true,
      ),
      home: const ViewReviewpage(title: 'View Reply'),
    );
  }
}

class ViewReviewpage extends StatefulWidget {
  const ViewReviewpage({super.key, required this.title});

  final String title;

  @override
  State<ViewReviewpage> createState() => _ViewReviewpageState();
}

class _ViewReviewpageState extends State<ViewReviewpage> {
  _ViewReviewpageState() {
    viewreply();
  }

  List<String> id_ = <String>[];
  List<String> review_ = <String>[];
  List<String> rating_ = <String>[];
  List<String> date_ = <String>[];
  List<String> userid_ = <String>[];

  Future<void> viewreply() async {
    List<String> id = <String>[];
    List<String> date = <String>[];
    List<String> review = <String>[];
    List<String> rating = <String>[];
    List<String> userid = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      String url = '$urls/myapp/del_viewreviewrating/';

      var data = await http.post(Uri.parse(url), body: {
        'lid': lid,
      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        date.add(arr[i]['date']);
        review.add(arr[i]['review']);
        rating.add(arr[i]['rating']);
        userid.add(arr[i]['userid']);
      }

      setState(() {
        id_ = id;
        date_ = date;
        review_ = review;
        rating_ = rating;
        userid_ = userid;
      });
    } catch (e) {
      print("Error ------------------- " + e.toString());
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
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.brown.shade400, // ← Brown shade applied here
          title: Text(widget.title),
        ),
        body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: id_.length,
          itemBuilder: (BuildContext context, int index) {
            double ratingValue = double.tryParse(rating_[index]) ?? 0.0;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date: ${date_[index]}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.brown.shade400
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "User ID: ${userid_[index]}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.brown.shade400
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Review:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        review_[index],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Rating:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      RatingBar.builder(
                        initialRating: ratingValue,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 30,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print("Rating: $rating");
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
