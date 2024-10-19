import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_feast/page/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class RegisRider extends StatefulWidget {
  const RegisRider({super.key});

  @override
  RegisRiderState createState() => RegisRiderState();
}

class RegisRiderState extends State<RegisRider> {
  var nameCTL = TextEditingController();
  var PhoneCTL = TextEditingController();
  var liscenseCTL = TextEditingController();
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
          controller: liscenseCTL,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.pause_presentation),
            labelText: 'License plate',
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
          controller: passwdConfirmCTL,
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline),
            labelText: 'Confirn Password',
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
        SizedBox(height: 16,),
            ElevatedButton(
  onPressed: register,
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.lightBlue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18.0),
    ),
    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
    minimumSize: Size(double.infinity, 50), // Set a minimum width and height
  ),
  child: const Text(
    'Create Account',
    style: TextStyle(
      color: Colors.white, 
      fontWeight: FontWeight.bold,
      fontSize: 16, // Increase font size for better readability
    ),
  ),
)
      ],
    );
  }

  void register() async {
    log(passwdConfirmCTL.text);
    if (nameCTL.text.isEmpty ||
        passwdCTL.text.isEmpty ||
        PhoneCTL.text.isEmpty ||
        liscenseCTL.text.isEmpty ||
        passwdConfirmCTL.text.isEmpty) {
      log("กรอกไม่ครบครับ");
      return;
    }

    // If no duplicate, proceed to add the new user
    var data = {
      'name': nameCTL.text,
      'license': liscenseCTL.text,
      'password': passwdCTL.text,
      'phone': PhoneCTL.text,
      'type': 2,
      'createAt': DateTime.now()
    };
    db.collection('user').doc(PhoneCTL.text).set(data);
    Get.to(const Login());
  } catch (e) {
    log(e.toString());
  }
}
