import 'package:flutter/material.dart';
import 'package:petify/home/main.dart';

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
      home: const petandpro(title: 'Flutter Demo Home Page'),
    );
  }
}

class petandpro extends StatefulWidget {
  const petandpro({super.key, required this.title});


  final String title;

  @override
  State<petandpro> createState() => _petandproState();
}

class _petandproState extends State<petandpro> {

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()async{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(title: '')));
        return false;

      },

      child: Scaffold(
        appBar: AppBar(

          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[


              ElevatedButton(onPressed: (){

              }, child: Text('Cart1')),



              ElevatedButton(onPressed: (){

              }, child: Text('Cart2')),




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
