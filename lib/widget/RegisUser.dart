import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_feast/page/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart'; // Changed from google_maps_flutter

class RegisUser extends StatefulWidget {
  const RegisUser({Key? key}) : super(key: key); // Fixed key parameter

  @override
  _RegisUserState createState() => _RegisUserState();
}

class _RegisUserState extends State<RegisUser> {
  TextEditingController nameCTL = TextEditingController();
  TextEditingController phoneCTL =
      TextEditingController(); // Fixed capitalization
  TextEditingController addressCTL =
      TextEditingController(); // Fixed capitalization
  TextEditingController locationCTL =
      TextEditingController(); // Fixed capitalization
  TextEditingController passwdCTL = TextEditingController();
  TextEditingController passwdConfirmCTL = TextEditingController();

  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
          controller: phoneCTL,
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
          controller: addressCTL,
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
        const SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: () {
            LatLng latLng =
                const LatLng(16.246825669508297, 103.25199289277295);
            List<Marker> markers = [
              Marker(
                point: latLng,
                width: 40,
                height: 40,
                child: Icon(Icons.location_pin, color: Colors.red, size: 40),
              ),
            ];

            Get.defaultDialog(
              title: 'Select your location',
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    children: [
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: FlutterMap(
                          mapController: mapController,
                          options: MapOptions(
                            initialCenter: latLng,
                            initialZoom: 15.0,
                            onTap: (tapPosition, point) {
                              setState(() {
                                latLng = point; // อัพเดต latLng
                                log(latLng.toString());
                                markers = [
                                  Marker(
                                    point: latLng,
                                    width: 40,
                                    height: 40,
                                    child: Icon(Icons.location_pin,
                                        color: Colors.red, size: 40),
                                  ),
                                ];
                              });
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                              maxNativeZoom: 19,
                            ),
                            MarkerLayer(markers: markers),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          var position = await _determinePosition();
                          log("${position.altitude} and ${position.longitude}");
                          setState(() {
                            latLng =
                                LatLng(position.latitude, position.longitude);
                            markers = [
                              Marker(
                                point: latLng,
                                width: 40,
                                height: 40,
                                child: Icon(Icons.location_pin,
                                    color: Colors.red, size: 40),
                              ),
                            ];
                          });
                          mapController.move(latLng, mapController.camera.zoom);
                        },
                        child: const Text('Get Now location'),
                      )
                    ],
                  );
                },
              ),
              confirm: ElevatedButton(
                onPressed: () {
                  Get.back(
                      result: latLng); // ส่งคืน latLng แทน markers[0].point
                },
                child: const Text('Confirm'),
              ),
              cancel: ElevatedButton(
                onPressed: () {
                  Get.back(); // Close dialog
                },
                child: const Text('Cancel'),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: const TextStyle(fontSize: 16),
          ),
          child: const Text('Select your location'),
        ),
        const SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: register,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 120.0),
          ),
          child: const Text(
            'Create Account',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void register() async {
    log(passwdConfirmCTL.text);
    if (nameCTL.text.isEmpty ||
        passwdCTL.text.isEmpty ||
        phoneCTL.text.isEmpty ||
        addressCTL.text.isEmpty ||
        passwdConfirmCTL.text.isEmpty) {
      log("กรอกไม่ครบครับ");
      return;
    }

    try {
      var db = FirebaseFirestore.instance;

      // Check if a user with the same phone number already exists
      var querySnapshot = await db
          .collection('user')
          .where('phone', isEqualTo: phoneCTL.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Phone number already exists
        log("หมายเลขโทรศัพท์นี้มีอยู่ในระบบแล้ว");
        return;
      }

      // If no duplicate, proceed to add the new user
      var data = {
        'name': nameCTL.text,
        'address': addressCTL.text,
        'location': locationCTL.text,
        'password': passwdCTL.text,
        'phone': phoneCTL.text,
        'type': 1,
        'createAt': DateTime.now()
      };

      await db.collection('user').add(data);
      log('Document added successfully');
      Get.to(() => const Login());
    } catch (e) {
      log('Error during registration: $e');
    }
  }
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
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
