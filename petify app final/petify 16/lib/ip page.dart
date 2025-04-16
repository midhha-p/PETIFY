import 'package:flutter/material.dart';
import 'package:petify/login%20page.dart';
import 'package:petify/reg/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const ip_page(title: 'PETIFY'),
    );
  }
}

class ip_page extends StatefulWidget {
  const ip_page({super.key, required this.title});

  final String title;

  @override
  State<ip_page> createState() => _ip_pageState();
}

class _ip_pageState extends State<ip_page> {
  TextEditingController ip = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final RegExp ipRegex = RegExp(
    r"^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}$",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade400,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          // ✅ Background image (webp)
          SizedBox.expand(
            child: Opacity(
              opacity: 0.3, // Adjust opacity for subtle background
              child: Image.asset(
                'assets/bg.webp', // Make sure this matches your file name
                fit: BoxFit.fitHeight,
              ),
            ),
          ),

          // ✅ Foreground content
          Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: ip,
                        decoration: const InputDecoration(
                          labelText: "IP address",
                          filled: true,
                          fillColor: Colors.white70,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter an IP address';
                          } else if (!ipRegex.hasMatch(value.trim())) {
                            return 'Enter a valid IP address';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String ipc = ip.text;
                            SharedPreferences sh =
                            await SharedPreferences.getInstance();
                            sh.setString("url", "http://" + ipc + ":8000");
                            sh.setString("img", "http://" + ipc + ":8000");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LoginPage(title: "Login"),
                              ),
                            );
                          }
                        },
                        child: const Text("GO TO APP"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
