import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_feast/page/login.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

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
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          log(image!.path);
                          setState(() {});
                        }
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
        const SizedBox(height: 16.0),
        TextFormField(
          controller: liscenseCTL,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.pause_presentation),
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
        const SizedBox(height: 16.0),
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
        const SizedBox(
          height: 16,
        ),
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
        const SizedBox(height: 10.0),
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

  void save() async {
    try {
      if (image != null) {
        File file = File(image!.path);
        String fileName = basename(file.path);
        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child('uploads/$fileName');
        UploadTask uploadTask = firebaseStorageRef.putFile(file);

        await uploadTask.whenComplete(() async {}).catchError((error) {
          log("Failed to upload image: $error");
        });
      } else {
        log("No image selected.");
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
