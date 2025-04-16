import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Widget/bezierContainer.dart';
import 'loginPage.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String gender = "Male";
  File? uploadimage;

  TextEditingController namecon = TextEditingController();
  TextEditingController emailcon = TextEditingController();
  TextEditingController phonecon = TextEditingController();
  TextEditingController placecon = TextEditingController();
  TextEditingController postcon = TextEditingController();
  TextEditingController pincon = TextEditingController();
  TextEditingController discon = TextEditingController();
  TextEditingController dobcon = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  File? _selectedImage;
  String photo = '';

  Future<void> _checkPermissionAndChooseImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, TextEditingController controller, TextInputType keyboardType, String? Function(String?) validator) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
            keyboardType: keyboardType,
            validator: validator,
          )
        ],
      ),
    );
  }

  Widget _imageSelectionWidget() {
    return InkWell(
      onTap: _checkPermissionAndChooseImage,
      child: Column(
        children: [
          if (_selectedImage != null)
            Image.file(
              _selectedImage!,
              height: 200,
              width: 200,
            )
          else
            Column(
              children: [
                Image.network(
                  'https://cdn.pixabay.com/photo/2017/11/10/05/24/select-2935439_1280.png',
                  height: 200,
                  width: 200,
                ),
                Text(
                  'Select Image',
                  style: TextStyle(color: Colors.cyan),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          _send_data();  // Only send data if form is valid
        }
        print('Button tapped');
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade200,
              offset: Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xfffbb448), Color(0xfff7892b)],
          ),
        ),
        child: Text(
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _send_data() async {
    String uname = namecon.text;
    String phone = phonecon.text;
    String email = emailcon.text;
    String pin = pincon.text;
    String post = postcon.text;
    String place = placecon.text;
    String district = discon.text;
    String dob = dobcon.text;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();

    final urls = Uri.parse('$url/userregister/');
    try {
      final response = await http.post(urls, body: {
        "name": uname,
        "number": phone,
        "email": email,
        "pin": pin,
        "post": post,
        "place": place,
        "district": district,
        "dob": dob,
        "gender": gender,
        "photo": photo,
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Fluttertoast.showToast(msg: 'Registration Successful');
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage(title: "Login")));
        } else {
          Fluttertoast.showToast(msg: 'Same email or phone already exists');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(height: 50),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          _entryField("Username", namecon, TextInputType.text, (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            RegExp regExp = RegExp(r'^[a-zA-Z ]+$');

                            if (!regExp.hasMatch(value)) {
                              return 'Username can only contain letters and spaces';
                            }

                            return null;
                          }),

                          _entryField("Email", emailcon, TextInputType.emailAddress, (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                            RegExp regex = RegExp(pattern);
                            if (!regex.hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          }),
                          _entryField("Phone", phonecon, TextInputType.phone, (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            String pattern =r'^[6-9]\d{9}$';
                            RegExp regex = RegExp(pattern);
                            if (!regex.hasMatch(value)) {
                              return 'Enter a valid phone number';
                            }
                            return null;
                          }),


                          _entryField("Place", placecon, TextInputType.text, (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your place';
                            }
                            RegExp regExp = RegExp(r'^[a-zA-Z ]+$');

                            if (!regExp.hasMatch(value)) {
                              return 'Place can only contain letters and spaces';
                            }

                            return null;
                          }),
                          _entryField("Post", postcon, TextInputType.text, (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your post';
                            }
                            RegExp regExp = RegExp(r'^[a-zA-Z ]+$');

                            if (!regExp.hasMatch(value)) {
                              return 'Post can only contain letters and spaces';
                            }

                            return null;
                          }),
                          _entryField("Pin", pincon, TextInputType.number, (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your pin';
                            }
                            RegExp regExp = RegExp(r'^\d{6}$');

                            if (!regExp.hasMatch(value)) {
                              return 'Pin can only contain letters numbers and have 6 digits';
                            }

                            return null;
                          }),
                          _entryField("District", discon, TextInputType.text, (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your district';
                            }
                            RegExp regExp = RegExp(r'^[a-zA-Z ]+$');

                            if (!regExp.hasMatch(value)) {
                              return 'District can only contain letters and spaces';
                            }

                            return null;
                          }),


                          GestureDetector(
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  dobcon.text = "${pickedDate.toLocal()}".split(' ')[0];
                                });
                              }
                            },
                            child: AbsorbPointer(
                              child: _entryField(
                                "Date of Birth",
                                dobcon,
                                TextInputType.datetime,
                                    (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your date of birth';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),


                          RadioListTile(
                            value: "Male",
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = "Male";
                              });
                            },
                            title: Text("Male"),
                          ),
                          RadioListTile(
                            value: "Female",
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = "Female";
                              });
                            },
                            title: Text("Female"),
                          ),
                          RadioListTile(
                            value: "Other",
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = "Other";
                              });
                            },
                            title: Text("Other"),
                          ),
                          SizedBox(height: 15,),

                          _imageSelectionWidget(),
                          SizedBox(height: 50),
                          _submitButton(),

                          TextButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage(title: '',),),);
                          }, child: Text("Login"))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _selectDate() async {
    DateTime currentDate = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1900),
      lastDate: currentDate,
    );

    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        dobcon.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }


  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Si',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xffe46b10)
          ),
          children: [
            TextSpan(
              text: 'gn',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: ' up',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }
}

