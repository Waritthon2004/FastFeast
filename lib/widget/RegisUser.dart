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
import 'package:latlong2/latlong.dart';

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
  var passwdCTL = TextEditingController();
  var LocationCTL = TextEditingController();
  var passwdConfirmCTL = TextEditingController();
  MapController mapController = MapController();
  String url = "";
  XFile? image;
  LatLng latLng = const LatLng(16.246825669508297, 103.25199289277295);
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
          onPressed: () {
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
                                latLng = point;
                                // อัพเดต latLng
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
                  Get.back(result: latLng);
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

  void save() async {
    if (nameCTL.text.isEmpty ||
        passwdCTL.text.isEmpty ||
        PhoneCTL.text.isEmpty ||
        AddressCTL.text.isEmpty ||
        passwdConfirmCTL.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (passwdCTL.text != passwdConfirmCTL.text) {
      Get.snackbar('Error', 'Passwords do not match',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      var db = FirebaseFirestore.instance;
      var querySnapshot = await db
          .collection('user')
          .where('phone', isEqualTo: PhoneCTL.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Get.snackbar('Error', 'This phone number is already registered',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
      String imageUrl = '';
      if (image != null) {
        File file = File(image!.path);
        String fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${basename(file.path)}';
        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child('uploads/$fileName');

        UploadTask uploadTask = firebaseStorageRef.putFile(file);

        TaskSnapshot taskSnapshot = await uploadTask;
        imageUrl = await taskSnapshot.ref.getDownloadURL();
        log('Image uploaded. URL: $imageUrl');
      }

      // Prepare user data
      var data = {
        'name': nameCTL.text,
        'address': AddressCTL.text,
        'location': GeoPoint(latLng.latitude, latLng.longitude),
        'password': passwdCTL.text,
        'phone': PhoneCTL.text,
        'type': 1,
        'url': imageUrl,
      };
      log(data.toString());

      await db.collection('user').doc(PhoneCTL.text).set(data);
      Get.snackbar('Success', 'Account created successfully',
          snackPosition: SnackPosition.BOTTOM);
      Get.to(() => const Login());
    } catch (e) {
      log('Error during registration: $e');
      Get.snackbar('Error', 'Failed to create account. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
    }
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
    return await Geolocator.getCurrentPosition();
  }
}
