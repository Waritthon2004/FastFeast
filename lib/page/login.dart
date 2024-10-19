import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_feast/page/home.dart';
import 'package:fast_feast/page/homeRider.dart';
import 'package:fast_feast/page/register.dart';
import 'package:fast_feast/shared/appData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var PhoneCTL = TextEditingController();
  var passwdCTL = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
   
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            Padding(
              padding: const EdgeInsets.only(top: 100,bottom: 30),
              child: 
              Image.asset('assets/image/login.png'),
            ),
             SizedBox(
              width: 365,
               child: TextFormField(
                controller: PhoneCTL,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone, color: Colors.grey),
                  labelText: 'Phone Number',
                  labelStyle: const TextStyle(color: Colors.grey),
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
             ),
            const SizedBox(height: 20.0),
            // Password Field
            SizedBox(
              width: 365,
              child: TextFormField(
                controller: passwdCTL,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.grey),
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
            ),
            const SizedBox(height: 25.0),
            ElevatedButton(
              onPressed: login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0), // Rounded corners
                ),
                padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 150.0), // Button size
              ),
              child: const Text(
                'SIGN IN',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20.0),
            // Create Account Button
            OutlinedButton(
              onPressed: () {
                Get.to( RegisterPage());
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0), // Rounded corners
                ),
                padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 125.0), // Button size
                side: BorderSide(color: Colors.grey.shade300), // Border color
              ),
              child: const Text(
                'Create Account',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            ],
        ),
      ),
    );
  }

 void login() async {
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('user');
  QuerySnapshot querySnapshot = await users.where('phone', isEqualTo: PhoneCTL.text).where('password', isEqualTo: passwdCTL.text).get();
  if (querySnapshot.docs.isNotEmpty) {
       UserInfo info = UserInfo();
       info.image = "${ querySnapshot.docs[0]['url']}";
       info.name = "${ querySnapshot.docs[0]['name']}";
       info.phone = "${ querySnapshot.docs[0]['phone']}";
       log(info.image);
      if(querySnapshot.docs[0]['type'] == 1){
       
         Get.to(const HomePage());
      }
      else if(querySnapshot.docs[0]['type'] == 2){
        Get.to(const Homerider());
      }
  } else {
    log('No matching user found.');
  }
  } catch (e) {
    log(e.toString());
  }
  
}

}
