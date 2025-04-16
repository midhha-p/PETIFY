// import 'dart:convert';
// import 'package:custom_rating_bar/custom_rating_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:petify/user/user%20view%20rating.dart';
// import 'package:petify/user/userhome.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
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
//       home: const sendrating(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class sendrating extends StatefulWidget {
//   const sendrating({super.key, required this.title});
//
//
//   final String title;
//
//   @override
//   State<sendrating> createState() => _sendratingState();
// }
//
// class _sendratingState extends State<sendrating> {
//   TextEditingController review=TextEditingController();
//   // TextEditingController bb=TextEditingController();
//
//   double bb=0;
//
//   get child => null;
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
//       body: Center(
//         child: Column(
//
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//
//             Padding(padding: EdgeInsets.all(10),
//               child: TextFormField(
//                 controller: review,
//                 decoration: InputDecoration(labelText: "review"),
//               ),
//
//             ),
//             RatingBar(
//
//               filledIcon: Icons.star,
//               emptyIcon: Icons.star_border,
//               onRatingChanged: (value){
//                 setState(() {
//                   print(value);
//                   bb=value;
//                   print(bb);
//                 });
//               },
//               initialRating: 3,
//               maxRating: 5,
//
//             ),
//             ElevatedButton(onPressed: (){
//               // Navigator.push(context, MaterialPageRoute(builder: (context) => userviewrating(title: '',)),);
//
//               senddata();
//             }, child: Text('submit'))
//
//       ],
//         ),
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: _incrementCounter,
//       //   tooltip: 'Increment',
//       //   child: const Icon(Icons.add),
//       // ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
//   senddata() async {
//     String review_=review.text;
//     // String rating=bb.text;
//
//
//
//
//
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     String lid = sh.getString('lid').toString();
//
//     final urls = Uri.parse('$url/myapp/user_sendrating_post/');
//     try {
//
//       final response = await http.post(urls, body: {
//         "review":review_,
//         "lid":lid,
//         "rating":bb.toString(),
//
//       });
//       if (response.statusCode == 200) {
//         String status = jsonDecode(response.body)['status'];
//         if (status=='ok') {
//
//           Fluttertoast.showToast(msg: 'Review Added Successfully');
//           Navigator.push(context, MaterialPageRoute(
//             builder: (context) => userhomepage(title: "Home"),));
//         }else {
//           Fluttertoast.showToast(msg: 'Not Found');
//         }
//       }
//       else {
//         Fluttertoast.showToast(msg: 'Network Error');
//       }
//     }
//     catch (e){
//       Fluttertoast.showToast(msg: e.toString());
//     }
//
//   }
// }
import 'dart:convert';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:petify/home/screens/main_screen.dart';
import 'package:petify/user/userhome.dart'; // Adjusted import for userhome
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
      home: const sendrating(title: 'Send Rating'),
    );
  }
}

class sendrating extends StatefulWidget {
  const sendrating({super.key, required this.title});

  final String title;

  @override
  State<sendrating> createState() => _sendratingState();
}

class _sendratingState extends State<sendrating> {
  TextEditingController reviewController = TextEditingController();
  double rating = 0;

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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              // Title Section
              const SizedBox(height: 20),
              const Text(
                'Please provide your review and rating:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Review Text Field
              TextFormField(
                controller: reviewController,
                decoration: const InputDecoration(
                  labelText: 'Your Review',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 20),

              // Rating Bar
              const Text(
                'Rate your experience:',
                style: TextStyle(fontSize: 16),
              ),
              RatingBar(
                filledIcon: Icons.star,
                emptyIcon: Icons.star_border,
                onRatingChanged: (value) {
                  setState(() {
                    rating = value;
                  });
                },
                initialRating: 3,
                maxRating: 5,
              ),
              const SizedBox(height: 20),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (reviewController.text.isEmpty || rating == 0) {
                      Fluttertoast.showToast(msg: 'Please enter a review and rating');
                    } else {
                      sendData();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  sendData() async {
    String review = reviewController.text;
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/myapp/user_sendrating_post/');
    try {
      final response = await http.post(urls, body: {
        "review": review,
        "lid": lid,
        "rating": rating.toString(),
      });

      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Fluttertoast.showToast(msg: 'Review Added Successfully');
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
  }
}
