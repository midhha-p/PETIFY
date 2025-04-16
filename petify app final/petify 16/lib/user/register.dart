import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:petify/home/main.dart';
import 'package:petify/reg/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../dhome/screens/main_screen.dart';
import '../login page.dart';

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
      home: const register(title: 'Flutter Demo Home Page'),
    );
  }
}

class register extends StatefulWidget {
  const register({super.key, required this.title});

  final String title;

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone_no = TextEditingController();
  TextEditingController place = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController pin = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirm_password = TextEditingController();

  String gender = '';
  File? _selectedImage;
  String? _encodedImage;
  String photo = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage(title: '')));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_selectedImage != null) ...{
                  InkWell(
                    child: Image.file(_selectedImage!, height: 200),
                    onTap: _checkPermissionAndChooseImage,
                  ),
                } else ...{
                  InkWell(
                    onTap: _checkPermissionAndChooseImage,
                    child: Column(
                      children: [
                        Image(
                          image: NetworkImage(
                              'https://cdn.pixabay.com/photo/2017/11/10/05/24/select-2935439_1280.png'),
                          height: 200,
                          width: 200,
                        ),
                        Text('Select Image', style: TextStyle(color: Colors.cyan))
                      ],
                    ),
                  ),
                },
                buildTextField(username, "Username"),
                buildTextField(email, "Email"),
                buildGenderRadio("Male"),
                buildGenderRadio("Female"),
                buildGenderRadio("Other"),
                buildTextField(phone_no, "Phone Number"),
                buildTextField(place, "Place"),
                buildTextField(dob, "Date of Birth"),
                buildTextField(city, "City"),
                buildTextField(state, "State"),
                buildTextField(pin, "PIN Code"),
                buildTextField(password, "Password", obscureText: true),
                buildTextField(confirm_password, "Confirm Password", obscureText: true),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                      onPressed: () async {
                        await senddata();
                      },
                      child: Text("Register")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label,
      {bool obscureText = false}) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        obscureText: obscureText,
      ),
    );
  }

  Widget buildGenderRadio(String value) {
    return RadioListTile(
      value: value,
      groupValue: gender,
      onChanged: (val) {
        setState(() {
          gender = val.toString();
        });
      },
      title: Text(value),
    );
  }

  Future<void> senddata() async {
    String name_ = username.text.trim();
    String email_ = email.text.trim();
    String phoneNo_ = phone_no.text.trim();
    String place_ = place.text.trim();
    String dob_ = dob.text.trim();
    String city_ = city.text.trim();
    String state_ = state.text.trim();
    String pin_ = pin.text.trim();
    String password_ = password.text.trim();
    String confirmPassword_ = confirm_password.text.trim();

    if (_selectedImage == null) {
      Fluttertoast.showToast(msg: 'Please select a profile image.');
      return;
    }
    if (name_.isEmpty || email_.isEmpty || phoneNo_.isEmpty || place_.isEmpty ||
        dob_.isEmpty || city_.isEmpty || state_.isEmpty || pin_.isEmpty ||
        password_.isEmpty || confirmPassword_.isEmpty || gender.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill all the fields.');
      return;
    }
    if (!_isValidEmail(email_)) {
      Fluttertoast.showToast(msg: 'Please enter a valid email address.');
      return;
    }
    if (phoneNo_.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(phoneNo_)) {
      Fluttertoast.showToast(msg: 'Invalid phone number.');
      return;
    }
    if (pin_.length != 6 || !RegExp(r'^[0-9]+$').hasMatch(pin_)) {
      Fluttertoast.showToast(msg: 'Invalid PIN code.');
      return;
    }
    if (password_.length < 6) {
      Fluttertoast.showToast(msg: 'Password must be at least 6 characters.');
      return;
    }
    if (password_ != confirmPassword_) {
      Fluttertoast.showToast(msg: 'Passwords do not match.');
      return;
    }

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    final urls = Uri.parse('$url/myapp/user_registeration_get/');

    try {
      final response = await http.post(urls, body: {
        "photo": photo,
        "name": name_,
        "gender": gender,
        "phone_no": phoneNo_,
        "email": email_,
        "dob": dob_,
        "place": place_,
        "state": state_,
        "city": city_,
        "pin": pin_,
        "password": password_,
        "confirm_password": confirmPassword_,
      });

      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Fluttertoast.showToast(msg: 'Registration Successful');
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => login_page(title: "Login")));
        } else {
          Fluttertoast.showToast(msg: 'Email Already Exists');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return emailRegex.hasMatch(email);
  }


  Future<void> _chooseAndUploadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _encodedImage = base64Encode(_selectedImage!.readAsBytesSync());
        photo = _encodedImage.toString();
      });
    }
  }

  Future<void> _checkPermissionAndChooseImage() async {
    final PermissionStatus status = await Permission.mediaLibrary.request();
    if (status.isGranted) {
      _chooseAndUploadImage();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Permission Denied'),
          content: const Text(
            'Please go to app settings and grant permission to choose an image.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
