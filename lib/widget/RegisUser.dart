import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_feast/page/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisUser extends StatefulWidget {
  const RegisUser({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisUserState createState() => _RegisUserState();
}

class _RegisUserState extends State<RegisUser> {
  var nameCTL = TextEditingController();
  var PhoneCTL = TextEditingController();
  var AddressCTL = TextEditingController();
  var LocationCTL = TextEditingController();
  var emailCTL = TextEditingController();
  var passwdCTL = TextEditingController();
  var passwdConfirmCTL = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: nameCTL,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person_outline),
            labelText: 'Your Name',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        SizedBox(height: 16.0),
        TextFormField(
          controller: PhoneCTL,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.phone),
            labelText: 'Phone Number',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        SizedBox(height: 16.0),
        TextFormField(
          controller: AddressCTL,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.home_outlined),
            labelText: 'Address',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        SizedBox(height: 16.0),
        TextFormField(
          controller: LocationCTL,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.location_on_outlined),
            labelText: 'Your Location',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        SizedBox(height: 16.0),
        TextFormField(
          controller: passwdCTL,
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline),
            labelText: 'Password',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        SizedBox(height: 16.0),
        TextFormField(
          controller: passwdCTL,
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline),
            labelText: 'Confirm Password',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        SizedBox(height: 32.0),
        // Create Account Button
        ElevatedButton(
          onPressed: register,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 120.0),
          ),
          child: Text(
            'Create Account',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  register() {
    log("message");
    // if (nameCTL.text.isEmpty ||
    //     emailCTL.text.isEmpty ||
    //     passwdCTL.text.isEmpty ||
    //     PhoneCTL.text.isEmpty ||
    //     AddressCTL.text.isEmpty ||
    //     LocationCTL.text.isEmpty ||
    //     passwdConfirmCTL.text.isEmpty) {
    //   return;
    // }
        log("message");

    try {
        var db = FirebaseFirestore.instance;

    var data = {
      'name': nameCTL.text,
      'address': AddressCTL.text,
      'location': LocationCTL.text,
      'password': passwdCTL.text,
      'phone': PhoneCTL.text,
      'createAt': DateTime.now() // Correct the timestamp function
    };

    db.collection('user').add(data).then((DocumentReference doc) {
      log('Document added with ID: ${doc.id}');
    }).catchError((error) {
      log('Error adding document: $error');
    });
    Get.to(const Login());
    } catch (e) {
     log(e.toString()); 
    }
  
  }
}
