import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:petify/home/main.dart';
import 'package:petify/user/user%20view%20profile.dart';
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
      home: const editprofile(title: 'Edit Profile'),
    );
  }
}

class editprofile extends StatefulWidget {
  const editprofile({super.key, required this.title});
  final String title;

  @override
  State<editprofile> createState() => _editprofileState();
}

class _editprofileState extends State<editprofile> {
  _editprofileState() {
    getdata();
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone_no = TextEditingController();
  TextEditingController place = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController pin = TextEditingController();

  String gender = '';
  File? _selectedImage;
  String? _encodedImage;
  String photo = '';
  String uphoto = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MainScreen(title: '')));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _selectedImage != null
                      ? InkWell(
                    onTap: _checkPermissionAndChooseImage,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: FileImage(_selectedImage!),
                    ),
                  )
                      : InkWell(
                    onTap: _checkPermissionAndChooseImage,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundImage: NetworkImage(photo),
                        ),
                        const SizedBox(height: 5),
                        const Text('Select Image',
                            style: TextStyle(color: Colors.cyan)),
                      ],
                    ),
                  ),
                  _buildTextField(
                      controller: username,
                      label: "Username",
                      validator: (val) => val!.isEmpty ? "Enter username" : null),
                  _buildTextField(
                      controller: email,
                      label: "Email",
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val == null || val.isEmpty) return "Enter email";
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)) {
                          return "Enter a valid email";
                        }
                        return null;
                      }),
                  _buildTextField(
                      controller: phone_no,
                      label: "Phone Number",
                      keyboardType: TextInputType.phone,
                      validator: (val) {
                        if (val == null || val.isEmpty)
                          return "Enter phone number";
                        if (val.length != 10)
                          return "Phone number must be 10 digits";
                        return null;
                      }),
                  _buildTextField(
                      controller: place,
                      label: "Place",
                      validator: (val) => val!.isEmpty ? "Enter place" : null),
                  _buildTextField(
                      controller: dob,
                      label: "Date of Birth",
                      hint: "YYYY-MM-DD",
                      validator: (val) => val!.isEmpty ? "Enter DOB" : null),
                  _buildTextField(
                      controller: city,
                      label: "City",
                      validator: (val) => val!.isEmpty ? "Enter city" : null),
                  _buildTextField(
                      controller: state,
                      label: "State",
                      validator: (val) => val!.isEmpty ? "Enter state" : null),
                  _buildTextField(
                      controller: pin,
                      label: "Pincode",
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val == null || val.isEmpty)
                          return "Enter pincode";
                        if (val.length != 6) return "Pincode must be 6 digits";
                        return null;
                      }),
                  Column(
                    children: [
                      RadioListTile(
                          value: "Male",
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() => gender = value!);
                          },
                          title: const Text("Male")),
                      RadioListTile(
                          value: "Female",
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() => gender = value!);
                          },
                          title: const Text("Female")),
                      RadioListTile(
                          value: "Other",
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() => gender = value!);
                          },
                          title: const Text("Other")),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        senddata();
                      }
                    },
                    child: const Text("Update Profile"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            labelText: label, hintText: hint, border: OutlineInputBorder()),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  Future<void> getdata() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/myapp/user_view_profile/');
    try {
      final response = await http.post(urls, body: {"lid": lid});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          setState(() {
            username.text = data['name'].toString();
            dob.text = data['dob'].toString();
            gender = data['gender'].toString();
            email.text = data['email'].toString();
            phone_no.text = data['phoneNo'].toString();
            place.text = data['place'].toString();
            pin.text = data['pin'].toString();
            state.text = data['state'].toString();
            photo = url + data['photo1'].toString();
            city.text = data['city'].toString();
          });
        } else {
          Fluttertoast.showToast(msg: 'User not found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Server error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> senddata() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/myapp/user_editprofile_get/');
    try {
      final response = await http.post(urls, body: {
        "photo": uphoto,
        "name": username.text,
        "gender": gender,
        "phone_no": phone_no.text,
        "email": email.text,
        "dob": dob.text,
        "place": place.text,
        "state": state.text,
        "city": city.text,
        "pin": pin.text,
        "lid": lid,
      });

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        if (res['status'] == 'ok') {
          Fluttertoast.showToast(msg: 'Profile Updated Successfully');
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => UserViewProfile(title: "Profile")));
        } else {
          Fluttertoast.showToast(msg: 'Update Failed');
        }
      } else {
        Fluttertoast.showToast(msg: 'Server error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> _chooseAndUploadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _encodedImage = base64Encode(_selectedImage!.readAsBytesSync());
        uphoto = _encodedImage.toString();
      });
    }
  }

  Future<void> _checkPermissionAndChooseImage() async {
    // final status = await Permission.photos.request();
    // if (status.isGranted) {
      _chooseAndUploadImage();
    // } else {
    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       title: const Text('Permission Denied'),
    //       content: const Text(
    //           'Please enable photo access in app settings to upload image.'),
    //       actions: [
    //         TextButton(
    //           onPressed: () => Navigator.pop(context),
    //           child: const Text('OK'),
    //         )
    //       ],
    //     ),
    //   );
    // }
  }
}
