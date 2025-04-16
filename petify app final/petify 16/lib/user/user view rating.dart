import 'package:flutter/material.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const userviewrating(title: 'Flutter Demo Home Page'),
    );
  }
}

class userviewrating extends StatefulWidget {
  const userviewrating({super.key, required this.title});


  final String title;

  @override
  State<userviewrating> createState() => _userviewratingState();
}

class _userviewratingState extends State<userviewrating> {


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()async{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(title: "")));
        return false;

      },

      child: Scaffold(
        appBar: AppBar(

          backgroundColor: Colors.brown.shade400,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[


            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _incrementCounter,
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.add),
        // ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
