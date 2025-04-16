import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:petify/home/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PredictionsList(),
    );
  }
}

class PredictionsList extends StatefulWidget {
  @override
  _PredictionsListState createState() => _PredictionsListState();
}

class _PredictionsListState extends State<PredictionsList> {

  final List<Map<String, dynamic>> diseases = [
    {"name": "Itching", "isChecked": false},
    {"name": "Skin Rash", "isChecked": false},
    {"name": "Nodal Skin Eruptions", "isChecked": false},
    {"name": "Continuous Sneezing", "isChecked": false},
    {"name": "Shivering", "isChecked": false},
    {"name": "Chills", "isChecked": false},
    {"name": "Joint Pain", "isChecked": false},
    {"name": "Stomach Pain", "isChecked": false},
    {"name": "Acidity", "isChecked": false},
    {"name": "Ulcers on Tongue", "isChecked": false},
    {"name": "Muscle Wasting", "isChecked": false},
    {"name": "Vomiting", "isChecked": false},
    {"name": "Burning Micturition", "isChecked": false},
    {"name": "Spotting Urination", "isChecked": false},
    {"name": "Fatigue", "isChecked": false},
    {"name": "Weight Gain", "isChecked": false},
    {"name": "Anxiety", "isChecked": false},
    {"name": "Cold Hands and Feet", "isChecked": false},
    {"name": "Mood Swings", "isChecked": false},
    {"name": "Weight Loss", "isChecked": false},
    {"name": "Restlessness", "isChecked": false},
    {"name": "Lethargy", "isChecked": false},
    {"name": "Patches in Throat", "isChecked": false},
    {"name": "Irregular Sugar Level", "isChecked": false},
    {"name": "Cough", "isChecked": false},
    {"name": "High Fever", "isChecked": false},
    {"name": "Sunken Eyes", "isChecked": false},
    {"name": "Breathlessness", "isChecked": false},
    {"name": "Sweating", "isChecked": false},
    {"name": "Dehydration", "isChecked": false},
    {"name": "Indigestion", "isChecked": false},
    {"name": "Headache", "isChecked": false},
    {"name": "Yellowish Skin", "isChecked": false},
    {"name": "Dark Urine", "isChecked": false},
    {"name": "Nausea", "isChecked": false},
    {"name": "Loss of Appetite", "isChecked": false},
    {"name": "Pain Behind the Eyes", "isChecked": false},
    {"name": "Back Pain", "isChecked": false},
    {"name": "Constipation", "isChecked": false},
    {"name": "Abdominal Pain", "isChecked": false},
    {"name": "Diarrhoea", "isChecked": false},
    {"name": "Mild Fever", "isChecked": false},
    {"name": "Yellow Urine", "isChecked": false},
    {"name": "Yellowing of Eyes", "isChecked": false},
    {"name": "Acute Liver Failure", "isChecked": false},
    {"name": "Fluid Overload", "isChecked": false},
    {"name": "Swelling of Stomach", "isChecked": false},
    {"name": "Swelled Lymph Nodes", "isChecked": false},
    {"name": "Malaise", "isChecked": false},
    {"name": "Blurred and Distorted Vision", "isChecked": false},
    {"name": "Phlegm", "isChecked": false},
    {"name": "Throat Irritation", "isChecked": false},
    {"name": "Redness of Eyes", "isChecked": false},
    {"name": "Sinus Pressure", "isChecked": false},
    {"name": "Runny Nose", "isChecked": false},
    {"name": "Congestion", "isChecked": false},
    {"name": "Chest Pain", "isChecked": false},
    {"name": "Weakness in Limbs", "isChecked": false},
    {"name": "Fast Heart Rate", "isChecked": false},
    {"name": "Pain During Bowel Movements", "isChecked": false},
    {"name": "Pain in Anal Region", "isChecked": false},
    {"name": "Bloody Stool", "isChecked": false},
    {"name": "Irritation in Anus", "isChecked": false},
    {"name": "Neck Pain", "isChecked": false},
    {"name": "Dizziness", "isChecked": false},
    {"name": "Cramps", "isChecked": false},
    {"name": "Bruising", "isChecked": false},
    {"name": "Obesity", "isChecked": false},
    {"name": "Swollen Legs", "isChecked": false},
    {"name": "Swollen Blood Vessels", "isChecked": false},
    {"name": "Puffy Face and Eyes", "isChecked": false},
    {"name": "Enlarged Thyroid", "isChecked": false},
    {"name": "Brittle Nails", "isChecked": false},
    {"name": "Swollen Extremities", "isChecked": false},
    {"name": "Excessive Hunger", "isChecked": false},
    {"name": "Extra Marital Contacts", "isChecked": false},
    {"name": "Drying and Tingling Lips", "isChecked": false},
    {"name": "Slurred Speech", "isChecked": false},
    {"name": "Knee Pain", "isChecked": false},
    {"name": "Hip Joint Pain", "isChecked": false},
    {"name": "Muscle Weakness", "isChecked": false},
    {"name": "Stiff Neck", "isChecked": false},
    {"name": "Swelling Joints", "isChecked": false},
    {"name": "Movement Stiffness", "isChecked": false},
    {"name": "Spinning Movements", "isChecked": false},
    {"name": "Loss of Balance", "isChecked": false},
    {"name": "Unsteadiness", "isChecked": false},
    {"name": "Weakness of One Body Side", "isChecked": false},
    {"name": "Loss of Smell", "isChecked": false},
    {"name": "Bladder Discomfort", "isChecked": false},
    {"name": "Foul Smell of Urine", "isChecked": false},
    {"name": "Continuous Feel of Urine", "isChecked": false},
    {"name": "Passage of Gases", "isChecked": false},
    {"name": "Internal Itching", "isChecked": false},
    {"name": "Toxic Look (Typhos)", "isChecked": false},
    {"name": "Depression", "isChecked": false},
    {"name": "Irritability", "isChecked": false},
    {"name": "Muscle Pain", "isChecked": false},
    {"name": "Altered Sensorium", "isChecked": false},
    {"name": "Red Spots Over Body", "isChecked": false},
    {"name": "Belly Pain", "isChecked": false},
    {"name": "Abnormal Menstruation", "isChecked": false},
    {"name": "Dischromic Patches", "isChecked": false},
    {"name": "Watering from Eyes", "isChecked": false},
    {"name": "Increased Appetite", "isChecked": false},
    {"name": "Polyuria", "isChecked": false},
    {"name": "Family History", "isChecked": false},
    {"name": "Mucoid Sputum", "isChecked": false},
    {"name": "Rusty Sputum", "isChecked": false},
    {"name": "Lack of Concentration", "isChecked": false},
    {"name": "Visual Disturbances", "isChecked": false},
    {"name": "Receiving Blood Transfusion", "isChecked": false},
    {"name": "Receiving Unsterile Injections", "isChecked": false},
    {"name": "Coma", "isChecked": false},
    {"name": "Stomach Bleeding", "isChecked": false},
    {"name": "Distention of Abdomen", "isChecked": false},
    {"name": "History of Alcohol Consumption", "isChecked": false},
    {"name": "Fluid Overload", "isChecked": false},
    {"name": "Blood in Sputum", "isChecked": false},
    {"name": "Prominent Veins on Calf", "isChecked": false},
    {"name": "Palpitations", "isChecked": false},
    {"name": "Painful Walking", "isChecked": false},
    {"name": "Pus Filled Pimples", "isChecked": false},
    {"name": "Blackheads", "isChecked": false},
    {"name": "Scurring", "isChecked": false},
    {"name": "Skin Peeling", "isChecked": false},
    {"name": "Silver Like Dusting", "isChecked": false},
    {"name": "small dents in nails", "isChecked": false},
    {"name": "inflammatory nails", "isChecked": false},
    {"name": "blister", "isChecked": false},
    {"name": "red sore around nose", "isChecked": false},
    {"name": "yellow_crust_ooze", "isChecked": false},
    {"name": "prognosis", "isChecked": false},
    // {"name": "Fainting", "isChecked": false},
    // {"name": "Stiffness of Limbs", "isChecked": false},
    // {"name": "Blurred and Distorted Vision", "isChecked": false},
  ];


  // Function to collect selected diseases
  String getSelectedDiseases() {

    String k="";

    for(int i=0;i<diseases.length;i++)
    {

      if(diseases[i]['isChecked']== true)
      {
        k=k+"1,";
      }
      else
      {
        k=k+"0,";

      }


    }

    return k;



  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:()async{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(title: '')));

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Disease Prediction'),
          backgroundColor: Colors.brown.shade400,
          actions: [
            ElevatedButton.icon(
              label: Text("Submit"),
              icon: Icon(Icons.send),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: _sendData,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  // controller: diseaseController,
                  itemCount: diseases.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(diseases[index]["name"]),
                      value: diseases[index]["isChecked"],
                      onChanged: (bool? value) {
                        setState(() {
                          diseases[index]["isChecked"] = value ?? false;
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to send data to the server
  void _sendData() async {
    String  a= getSelectedDiseases();

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();

    final urls = Uri.parse('$url/myapp/pet_disease_prediction/');
    try {
      final response = await http.post(urls, body: {

        "a":a,
      });

      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          String result = jsonDecode(response.body)['l'];
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Predictions'),
                content: Text(result),
                actions: <Widget>[
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              );
            },
          );

        }
        else {
          Fluttertoast.showToast(msg: 'Failed to Post Diseases');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
