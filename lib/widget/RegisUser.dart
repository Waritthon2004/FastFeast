import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_feast/page/login.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class RegisUser extends StatefulWidget {
  const RegisUser({Key? key}) : super(key: key); // Fixed key parameter

  @override
  _RegisUserState createState() => _RegisUserState();
}

class _RegisUserState extends State<RegisUser> {
  var nameCTL = TextEditingController();
  var PhoneCTL = TextEditingController();
  var AddressCTL = TextEditingController();
  var passwdCTL = TextEditingController();
  var LocationCTL = TextEditingController();
  var passwdConfirmCTL = TextEditingController();
  String url = "";
  XFile? image;

  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Get.defaultDialog(
              title: "Which one",
              content: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FilledButton.icon(
                      onPressed: () {
                        // Add your gallery function here
                      },
                      icon:
                          const Icon(Icons.photo_library, color: Colors.white),
                      label: const Text("Gallery"),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(90, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () {
                        camera();
                      },
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      label: const Text("Camera"),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(90, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 231, 177, 177),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundImage:
                  image != null ? FileImage(File(image!.path)) : null,
              child: image == null
                  ? Icon(Icons.person, size: 60, color: Colors.grey[400])
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: nameCTL,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.person_outline),
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
        const SizedBox(height: 16.0),
        TextFormField(
          controller: PhoneCTL,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.phone),
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
        const SizedBox(height: 16.0),
        TextFormField(
          controller: AddressCTL,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.home_outlined),
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
        // TextFormField(
        //   controller: LocationCTL,
        //   decoration: InputDecoration(
        //     prefixIcon: Icon(Icons.location_on_outlined),
        //     labelText: 'Your Location',
        //     enabledBorder: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(18),
        //       borderSide: BorderSide(color: Colors.grey.shade300),
        //     ),
        //     focusedBorder: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(18.0),
        //       borderSide: BorderSide(color: Colors.grey.shade300),
        //     ),
        //   ),
        // ),
        // SizedBox(height: 16.0),
        TextFormField(
          controller: passwdCTL,
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline),
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
        const SizedBox(height: 16.0),
        TextFormField(
          controller: passwdConfirmCTL,
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline),
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
        SizedBox(height: 10.0),
        ElevatedButton(
            onPressed: () {},
            child: const Text('Select your location'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: const TextStyle(fontSize: 16),
            )),
        SizedBox(height: 10.0),

        // Create Account Button
        ElevatedButton(
          onPressed: save,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            minimumSize:
                Size(double.infinity, 50), // Set a minimum width and height
          ),
          child: const Text(
            'Create Account',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16, // Increase font size for better readability
            ),
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  void camera() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    image = await picker.pickImage(source: ImageSource.camera);
    log(image.toString());
    if (image != null) {
      log(image!.path);
      setState(() {});
    }
    Get.back();
  }

  void register() async {
    log(passwdConfirmCTL.text);
    if (nameCTL.text.isEmpty ||
        passwdCTL.text.isEmpty ||
        PhoneCTL.text.isEmpty ||
        AddressCTL.text.isEmpty ||
        passwdConfirmCTL.text.isEmpty) {
      log("กรอกไม่ครบครับ");
      return;
    }

    try {
      var db = FirebaseFirestore.instance;

      // Check if a user with the same phone number already exists
      var querySnapshot = await db
          .collection('user')
          .where('phone', isEqualTo: PhoneCTL.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Phone number already exists
        log("หมายเลขโทรศัพท์นี้มีอยู่ในระบบแล้ว");
        return;
      }
      save();
      // If no duplicate, proceed to add the new user
      var data = {
        'name': nameCTL.text,
        'address': AddressCTL.text,
        'location': LocationCTL.text,
        'password': passwdCTL.text,
        'phone': PhoneCTL.text,
        'url': url,
      };
      db.collection('user').doc(PhoneCTL.text).set(data);
      Get.to(const Login());
    } catch (e) {
      log(e.toString());
    }
  }

  void save() async {
    if (image != null) {
      File file = File(image!.path);
      String fileName = basename(file.path);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(file);
      url = await firebaseStorageRef.getDownloadURL();
      log(url);
      await uploadTask.whenComplete(() async {});
      register();
    } else {
      log("No image selected.");
    }
  }
}
