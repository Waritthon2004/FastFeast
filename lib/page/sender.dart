import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:fast_feast/page/bar.dart';
import 'package:fast_feast/page/drawer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class SenderPage extends StatefulWidget {
  const SenderPage({super.key});

  @override
  State<SenderPage> createState() => _SenderPageState();
}

class _SenderPageState extends State<SenderPage> {
  XFile? image;

  FirebaseStorage storage = FirebaseStorage.instance;
  TextEditingController des = TextEditingController();
  TextEditingController receiver = TextEditingController();
  var db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1ABBE0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    "https://scontent-bkk1-2.xx.fbcdn.net/v/t39.30808-6/418475547_3527827574134521_421755393680319339_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeEdVbCSMT19XcCJXhl5nM39mQjXit1mkmGZCNeK3WaSYSp5wgXWCPNiHHAh6XVgQnTipxlh1_zNMxK-9zURA1v6&_nc_ohc=J9ZaSFck58oQ7kNvgGn0dVw&_nc_ht=scontent-bkk1-2.xx&_nc_gid=AL4xba1YgAtt9fnC3FLjEND&oh=00_AYDX2uobSD2wOqFC8pWgrhdLz-oJk2xp3FkeCYrrHFq8gA&oe=67158B07",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            header(context),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  (image != null)
                      ? Container(
                          width: 300,
                          height: 300,
                          child: Image.file(File(image!.path)),
                        )
                      : GestureDetector(
                          onTap: () {
                            camera();
                          },
                          child: Container(
                            width: 300,
                            height: 300,
                            color: Colors.white,
                          ),
                        ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, left: 30),
                      child: Text("รายละเอียดสินค้า"),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                        width: 300,
                        child: TextField(
                          controller: des,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white, width: 1), // ขอบสีขาว
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1), // ขอบสีขาวเมื่อไม่ได้โฟกัส
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1), // ขอบสีขาวเมื่อโฟกัส
                            ),
                            filled: true, // เปิดใช้งานสีพื้นหลัง
                            fillColor:
                                Colors.white, // ตั้งค่าพื้นหลังให้เป็นสีขาว
                          ),
                        ),
                      )),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, left: 30),
                      child: Text("ผู้รับ"),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                        width: 300,
                        child: TextField(
                          controller: receiver,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white, width: 1), // ขอบสีขาว
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1), // ขอบสีขาวเมื่อไม่ได้โฟกัส
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1), // ขอบสีขาวเมื่อโฟกัส
                            ),
                            filled: true, // เปิดใช้งานสีพื้นหลัง
                            fillColor:
                                Colors.white, // ตั้งค่าพื้นหลังให้เป็นสีขาว
                          ),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: FilledButton(
                        onPressed: () {
                          save();
                        },
                        child: const Text("บันทึก")),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const Bar(),
    );
  }

  void camera() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      log(image!.path);
      setState(() {});
    }
  }

  void save() async {
    if (image != null) {
      // แปลง XFile เป็น File
      File file = File(image!.path);

      // สร้างชื่อไฟล์ใน Firebase Storage โดยดึงชื่อจาก path
      String fileName = basename(file.path);

      // อ้างอิงไปยังตำแหน่งใน Firebase Storage ที่ต้องการอัปโหลด
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');

      // เริ่มการอัปโหลด
      UploadTask uploadTask = firebaseStorageRef.putFile(file);

      // ตรวจสอบสถานะการอัปโหลด
      await uploadTask.whenComplete(() async {
        // รับ URL ของไฟล์ที่อัปโหลด
        String downloadURL = await firebaseStorageRef.getDownloadURL();
        var data = {'name': receiver.text, 'image': downloadURL};
        db.collection('send').doc(des.text).set(data);
        log("Download URL: $downloadURL");
      }).catchError((error) {
        log("Failed to upload image: $error");
      });
    } else {
      log("No image selected.");
    }
  }
}

Widget header(BuildContext context) {
  return Container(
    color: const Color(0xFF1ABBE0),
    width: MediaQuery.of(context).size.width,
    height: 90,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Center(
                child: Container(
                    width: 300,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5D939F),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text("Mahasarakham University",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
