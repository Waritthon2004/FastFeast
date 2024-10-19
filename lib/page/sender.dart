import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_feast/model/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fast_feast/page/bar.dart';
import 'package:fast_feast/page/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart' show basename;

class SenderPage extends StatefulWidget {
  const SenderPage({Key? key}) : super(key: key);

  @override
  State<SenderPage> createState() => _SenderPageState();
}

class _SenderPageState extends State<SenderPage> {
  XFile? image;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final TextEditingController des = TextEditingController();
  final TextEditingController receiver = TextEditingController();
  final MapController mapController = MapController();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  LatLng currentLocation = const LatLng(16.246825669508297, 103.25199289277295);

  List<User> users = [];
  String stay = "Mahasarakham University";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1ABBE0),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                "https://scontent-bkk1-2.xx.fbcdn.net/v/t39.30808-6/418475547_3527827574134521_421755393680319339_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeEdVbCSMT19XcCJXhl5nM39mQjXit1mkmGZCNeK3WaSYSp5wgXWCPNiHHAh6XVgQnTipxlh1_zNMxK-9zURA1v6&_nc_ohc=J9ZaSFck58oQ7kNvgGn0dVw&_nc_ht=scontent-bkk1-2.xx&_nc_gid=AL4xba1YgAtt9fnC3FLjEND&oh=00_AYDX2uobSD2wOqFC8pWgrhdLz-oJk2xp3FkeCYrrHFq8gA&oe=67158B07",
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
                  buildImageContainer(),
                  buildTextField("รายละเอียดสินค้า", des),
                  buildTextField("ผู้รับ", receiver),
                  Container(
                    width: 300,
                    color: Colors.white,
                    child: users.isNotEmpty
                        ? Column(
                            children: users.map((u) {
                              return Column(
                                children: [
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          child: Image.network(
                                              "https://i.pinimg.com/enabled_lo/474x/1a/cd/ee/1acdeec352e027b19b1a1ec0e1c3e038.jpg"),
                                        ),
                                        Column(
                                          children: [
                                            Text(u.phone),
                                            Text(u.name),
                                            Row(children: [
                                              Icon(Icons.location_pin,
                                                  color: Colors.red, size: 20),
                                              Text(u.address)
                                            ])
                                          ],
                                        ),
                                        FilledButton(
                                            onPressed: () {},
                                            child: Text("เลือก"))
                                      ],
                                    ),
                                  )
                                ],
                              );
                            }).toList(),
                          )
                        : Container(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: FilledButton(
                      onPressed: save,
                      child: const Text("บันทึก"),
                    ),
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

  Widget buildImageContainer() {
    return GestureDetector(
      onTap: camera,
      child: Container(
        width: 300,
        height: 300,
        color: Colors.white,
        child: image != null
            ? Image.file(File(image!.path), fit: BoxFit.cover)
            : const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 30),
          child: Text(label),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: SizedBox(
            width: 300,
            child: TextField(
              onTap: () {
                if (controller == receiver) {
                  queryData();
                }
              },
              onChanged: (value) {
                if (controller == receiver) {
                  queryDatafillter();
                }
              },
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> camera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  Future<void> save() async {
    if (image == null) {
      Get.snackbar('Error', 'Please select an image');
      return;
    }

    try {
      File file = File(image!.path);
      String fileName = basename(file.path);
      Reference firebaseStorageRef = storage.ref().child('uploads/$fileName');

      UploadTask uploadTask = firebaseStorageRef.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      await db.collection('send').doc(des.text).set({
        'name': receiver.text,
        'image': downloadURL,
        'location':
            GeoPoint(currentLocation.latitude, currentLocation.longitude),
      });

      Get.snackbar('Success', 'Image uploaded and data saved');
      clearFields();
    } catch (error) {
      Get.snackbar('Error', 'Failed to upload image and save data: $error');
    }
  }

  void clearFields() {
    setState(() {
      image = null;
      des.clear();
      receiver.clear();
    });
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
                child: GestureDetector(
                  onTap: _showLocationDialog,
                  child: Center(
                    child: Container(
                      width: 300,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5D939F),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(stay,
                                style: const TextStyle(color: Colors.white)),
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
      ),
    );
  }

  void _showLocationDialog() {
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
                    initialCenter: currentLocation,
                    initialZoom: 15.0,
                    onTap: (tapPosition, point) {
                      setState(() {
                        currentLocation = point;
                        stay =
                            '${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}';
                        log('Tapped location: $stay');
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
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: currentLocation,
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.location_pin,
                              color: Colors.red, size: 40),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Position position = await _determinePosition();
                  setState(() {
                    currentLocation =
                        LatLng(position.latitude, position.longitude);
                    stay =
                        '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
                    log('Current location: $stay');
                  });
                  mapController.move(
                      currentLocation, mapController.camera.zoom);
                },
                child: const Text('Get Current Location'),
              )
            ],
          );
        },
      ),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back(result: currentLocation);
          setState(() {
            stay;
          });
        },
        child: const Text('Confirm'),
      ),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: const Text('Cancel'),
      ),
    );
  }

  Future<void> queryData() async {
    try {
      var inboxRef = db.collection("user");
      var query = inboxRef.where("name", isNotEqualTo: "Ruj");

      var result = await query.get();

      if (result.docs.isNotEmpty) {
        setState(() {
          users = result.docs
              .map((doc) {
                try {
                  return User.fromJson(doc.data() as Map<String, dynamic>);
                } catch (e) {
                  log("Error parsing user data: $e");
                  return null;
                }
              })
              .whereType<User>()
              .toList();
        });
        log('Users found: ${users.length}');
      } else {
        setState(() {
          users = [];
        });
        log('No users found.');
      }
    } catch (e) {
      log("Error querying data: $e");
    }
  }

  Future<void> queryDatafillter() async {
    try {
      var inboxRef = db.collection("user");

      // ค้นหาชื่อที่มีส่วนคล้ายกันโดยเริ่มต้นด้วยค่าที่กรอก
      var query = inboxRef
          .where("phone", isGreaterThanOrEqualTo: receiver.text)
          .where("phone", isLessThan: receiver.text + 'z');

      var result = await query.get();

      if (result.docs.isNotEmpty) {
        setState(() {
          users = result.docs
              .map((doc) {
                try {
                  return User.fromJson(doc.data() as Map<String, dynamic>);
                } catch (e) {
                  log("Error parsing user data: $e");
                  return null;
                }
              })
              .whereType<User>()
              .toList();
        });
        log('Users found: ${users.length}');
      } else {
        setState(() {
          users = [];
        });
        log('No users found.');
      }
    } catch (e) {
      log("Error querying data: $e");
    }
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}