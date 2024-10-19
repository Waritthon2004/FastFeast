import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_feast/page/bar.dart';
import 'package:fast_feast/page/barRider.dart';
import 'package:fast_feast/page/drawer.dart';
import 'package:fast_feast/page/login.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class Riderstatus extends StatefulWidget {
  const Riderstatus({super.key});

  @override
  State<Riderstatus> createState() => _RiderstatusState();
}

class _RiderstatusState extends State<Riderstatus> {
  final MapController mapController = MapController();
  TextEditingController receiver = TextEditingController();
  TextEditingController des = TextEditingController();
  int status = 0;
  var data;
  XFile? image;
  @override
  LatLng latLng = const LatLng(16.246825669508297, 103.25199289277295);
  @override
  var db = FirebaseFirestore.instance;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1ABBE0),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            header(context),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 340,
              height: 340,
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: latLng,
                  initialZoom: 15.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                    maxNativeZoom: 19,
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: latLng,
                        width: 10,
                        height: 10,
                        child: Container(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  width: 340,
                  height: 155,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.local_shipping,
                                    color: Colors.orange),
                                SizedBox(width: 8),
                                Text(
                                  "ตลาดน้อย",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                width:
                                    1, // This controls the thickness of the vertical line
                                height:
                                    50, // This controls the height of the line
                                color: Colors.grey, // Line color
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.blue),
                                SizedBox(width: 8),
                                Text("ตึก IT",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: camera,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 56, 104, 248),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            minimumSize: const Size(80, 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  16), // Border radius of 10
                            ),
                          ),
                          child: const Text(
                            'อัพเดตสถานะ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      drawer: const MyDrawer(),
      bottomNavigationBar: const BarRider(),
    );
  }

  void camera() async {
    final ImagePicker picker = ImagePicker();
    image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      log('Image selected: ${image!.path}');
      save();
      setState(() {});
    } else {
      log('No image selected');
    }
  }

  void save() async {
  var position = await _determinePosition();
  log("${position.latitude} and ${position.longitude}");
  latLng = LatLng(position.latitude, position.longitude);
  mapController.move(latLng, mapController.camera.zoom);
  setState(() {});

  if (image != null) {
    File file = File(image!.path);
    String fileName = basename(file.path);
    log('File name: $fileName');

    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');

    UploadTask uploadTask = firebaseStorageRef.putFile(file);

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      log('Upload progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
    });

    await uploadTask.whenComplete(() async {
      try {
        String downloadURL = await firebaseStorageRef.getDownloadURL();
        log('Download URL: $downloadURL');

        var data = {
          'status': 1,
          'image': downloadURL,
          'location': {
            'latitude': position.latitude,
            'longitude': position.longitude,
          },
        };

        db.collection('status').doc("2").set(data);
      } catch (error) {
        log('Error getting download URL: $error');
      }
    }).catchError((error) {
      log('Upload error: $error');
    });
    updateStatus();
  } else {
    log("No image selected.");
  }
}

  void updateStatus() {
    setState(() {
      status = status + 1;
    });
  }
}

Widget header(BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
      color: Color(0xFF1ABBE0),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20), // Bottom-left corner radius
        bottomRight: Radius.circular(20), // Bottom-right corner radius
      ),
    ),
    width: MediaQuery.of(context).size.width,
    height: 120,
    child: const Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text("ข้อมูลการจัดส่ง",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white)),
          ),
          CustomStatusBar(
            icons: [
              Icons.hourglass_empty,
              Icons.phone_android,
              Icons.motorcycle,
              Icons.check_circle,
            ],
            currentStep: 1,
          ),
        ],
      ),
    ),
  );
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

class CustomStatusBar extends StatelessWidget {
  final List<IconData> icons;
  final int currentStep;

  const CustomStatusBar({
    Key? key,
    required this.icons,
    required this.currentStep,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(icons.length * 2 - 1, (index) {
        if (index.isEven) {
          final stepIndex = index ~/ 2;
          final isCompleted = stepIndex < currentStep;
          final isActive = stepIndex == currentStep;
          return _buildStep(icons[stepIndex], isCompleted, isActive);
        } else {
          return _buildLine(index ~/ 2 < currentStep);
        }
      }),
    );
  }

  Widget _buildStep(IconData icon, bool isCompleted, bool isActive) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted || isActive
            ? Color.fromARGB(255, 13, 228, 56)
            : Colors.grey[300],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget _buildLine(bool isCompleted) {
    return Container(
      width: 40,
      height: 2,
      color: isCompleted ? Color.fromARGB(255, 0, 211, 14) : Colors.grey[300],
    );
  }
}
