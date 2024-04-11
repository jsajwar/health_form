// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HealthFormPage extends StatefulWidget {
  const HealthFormPage({super.key});

  @override
  HealthFormPageState createState() => HealthFormPageState();
}

class HealthFormPageState extends State<HealthFormPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  int? age;
  String? email = '';
  String? phoneNumber = '';
  String? gender;
  String? pastDiseases = '';
  // late DateTime lastCheckUpDate;

  Map<String, dynamic> userData = {};

  void saveForm() {
    userData = {
      'name': name,
      'age': age,
      'email': email,
      'phone_number': phoneNumber,
      'gender': gender,
      'past_diseases': pastDiseases,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Form'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  name = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your age';
                  }
                  if (int.tryParse(value) == null ||
                      int.tryParse(value)! <= 0) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
                onSaved: (value) {
                  age = int.parse(value!);
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email address';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value!)) {
                    return 'Please enter a valid 10-digit phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  phoneNumber = value;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Gender'),
                value: gender,
                onChanged: (String? newValue) {
                  setState(() {
                    gender = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select your gender';
                  }
                  return null;
                },
                items: <String>['Male', 'Female', 'Other']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Past Diseases'),
                onSaved: (value) {
                  pastDiseases = value;
                },
              ),
              SizedBox(height: 16.0),
//              TextFormField(
//                decoration: InputDecoration(labelText: 'Last Check-Up Date'),
              //              readOnly: true,
              //            onTap: () async {
              //            final DateTime? picked = await showDatePicker(
              //            context: context,
              //            initialDate: DateTime.now(),
              //            firstDate: DateTime(1900),
              //            lastDate: DateTime.now(),
              //                 );
              //                 if (picked != null && picked != lastCheckUpDate) {
              //                   setState(() {
//                      lastCheckUpDate = picked;
              //                   });
              //                 }
              //            },
              //             validator: (value) {
              //               if (lastCheckUpDate == "") {
              //                 return 'Please select your last check-up date';
              //               }
              //                return null;
              //              },
              //            ),
              //            SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    saveForm();
                    FirebaseFirestore.instance
                        .collection('health_data')
                        .add(userData)
                        .then((value) {
                      // Successfully added to Firestore
                      print('Data added to Firestore');
                    }).catchError((error) {
                      // Error occurred while adding to Firestore
                      print('Failed to add data to Firestore: $error');
                    });
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
