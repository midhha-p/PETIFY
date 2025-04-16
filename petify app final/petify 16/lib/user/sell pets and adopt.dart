import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:petify/home/screens/main_screen.dart';
import 'package:petify/user/userhome.dart';
import 'package:petify/user/view%20my%20pets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown.shade400),
        useMaterial3: true,
      ),
      home: const sellpetsandadopt(title: 'Sell or Adopt Pet'),
    );
  }
}

class sellpetsandadopt extends StatefulWidget {
  const sellpetsandadopt({super.key, required this.title});
  final String title;

  @override
  State<sellpetsandadopt> createState() => _sellpetsandadoptState();
}

class _sellpetsandadoptState extends State<sellpetsandadopt> {
  TextEditingController breed = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();

  String gender = '';
  String type = '';

  File? _selectedImage;
  String? _encodedImage;
  String photo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade400,
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _checkPermissionAndChooseImage,
                child: _selectedImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(_selectedImage!,
                      height: 250, fit: BoxFit.cover),
                )
                    : Column(
                  children: [
                    Image.network(
                      'https://cdn.pixabay.com/photo/2017/11/10/05/24/select-2935439_1280.png',
                      height: 200,
                      width: 200,
                    ),
                    SizedBox(height: 8),
                    Text('Tap to select image',
                        style:
                        TextStyle(color: Colors.brown.shade400)),
                  ],
                ),
              ),
              SizedBox(height: 16),
              _buildTextField(controller: breed, label: 'Breed'),
              _buildTextField(controller: age, label: 'Age'),
              _buildRadioGroup(
                  label: 'Gender',
                  values: ['Male', 'Female'],
                  groupValue: gender,
                  onChanged: (val) => setState(() => gender = val)),
              _buildTextField(controller: description, label: 'Description'),
              _buildTextField(controller: price, label: 'Price'),
              _buildRadioGroup(
                  label: 'Type',
                  values: ['Sell', 'Adopt'],
                  groupValue: type,
                  onChanged: (val) => setState(() => type = val)),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade400,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: senddata,
                child: Text("Submit",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildRadioGroup(
      {required String label,
        required List<String> values,
        required String groupValue,
        required Function(String) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Column(
          children: values
              .map((value) => RadioListTile(
            title: Text(value),
            value: value,
            groupValue: groupValue,
            onChanged: (val) => onChanged(val!),
          ))
              .toList(),
        ),
      ],
    );
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
              'Please go to app settings and grant permission to choose an image.'),
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

  Future<void> senddata() async {
    String breed_ = breed.text.trim();
    String age_ = age.text.trim();
    String description_ = description.text.trim();
    String price_ = price.text.trim();

    // Validation
    if (_selectedImage == null ||
        breed_.isEmpty ||
        age_.isEmpty ||
        description_.isEmpty ||
        price_.isEmpty ||
        gender.isEmpty ||
        type.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all fields and select an image.");
      return;
    }

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();

    final urls = Uri.parse('$url/myapp/user_sell_pet/');
    try {
      final response = await http.post(urls, body: {
        "photo": photo,
        "breed": breed_,
        "gender": gender,
        "age": age_,
        "description": description_,
        "price": price_,
        "type": type,
        "lid": lid,
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Fluttertoast.showToast(msg: 'Added Successfully');
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ViewMyPets(title: '',)));
        } else {
          Fluttertoast.showToast(msg: 'Submission failed. Try again.');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
