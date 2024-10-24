import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_feast/page/barRider.dart';
import 'package:fast_feast/page/drawer.dart';
import 'package:fast_feast/page/homeRider.dart';
import 'package:fast_feast/shared/appData.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Riderstatus extends StatefulWidget {
  const Riderstatus({super.key});

  @override
  State<Riderstatus> createState() => _RiderstatusState();
}

class _RiderstatusState extends State<Riderstatus> {
  Timer? locationUpdateTimer;

  List<GeoPoint> locations = [];
  late UserInfo user;
  String doc = '';
  @override
  @override
  void initState() {
    super.initState();
    user = context.read<AppData>().user;
    log(user.phone);
    loadDataAsync();

    // Start updating the location every 3 seconds
  }

  final MapController mapController = MapController();
  int status = 0;
  XFile? image;
  String? origin = '';
  String? destination = '';
  LatLng latLng = const LatLng(16.246825669508297, 103.25199289277295);
  var db = FirebaseFirestore.instance;
  LatLng riderLocation = const LatLng(0, 0);
  LatLng receiverLocation = const LatLng(0, 0);
  LatLng senderLocation = const LatLng(0, 0);
  int checkEmpty = 0;
  bool _isSaving = false;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1ABBE0),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF1ABBE0),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text("ข้อมูลการจัดส่ง",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: Colors.white)),
                          ),
                          CustomStatusBar(
                            icons: const [
                              Icons.hourglass_empty,
                              Icons.phone_android,
                              Icons.motorcycle,
                              Icons.check_circle,
                            ],
                            currentStep: status,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (checkEmpty == 1) ...[
                    Column(
                      children: [
                        SizedBox(
                          width: 340,
                          height: 340,
                          child: FlutterMap(
                            mapController: mapController,
                            options: MapOptions(
                              initialCenter:
                                  riderLocation, // Use a default center for the map
                              initialZoom: 1,
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
                                  // 1. Rider location marker
                                  Marker(
                                    point: riderLocation,
                                    width: 30,
                                    height: 30,
                                    child: const Icon(Icons.motorcycle_rounded,
                                        color: Color.fromARGB(255, 218, 193, 0),
                                        size: 30),
                                  ),
                                  // 2. Receiver location marker
                                  Marker(
                                    point: receiverLocation,
                                    width: 30,
                                    height: 30,
                                    child: const Icon(Icons.location_pin,
                                        color: Color.fromARGB(255, 33, 89, 243),
                                        size: 30),
                                  ),
                                  // 3. Conditionally add the sender location marker if status > 1
                                  if (status <= 1)
                                    Marker(
                                      point: senderLocation,
                                      width: 30,
                                      height: 30,
                                      child: const Icon(Icons.location_pin,
                                          color: Color.fromARGB(255, 206, 7, 4),
                                          size: 30),
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
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.local_shipping,
                                                color: Colors.orange),
                                            const SizedBox(width: 8),
                                            Text(
                                              origin!,
                                              style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Container(
                                            width:
                                                1, // This controls the thickness of the vertical line
                                            height:
                                                50, // This controls the height of the line
                                            color: Colors.grey, // Line color
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.location_on,
                                                color: Colors.blue),
                                            const SizedBox(width: 8),
                                            Text(destination!,
                                                style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: camera,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 56, 104, 248),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 12),
                                              minimumSize: const Size(80, 10),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
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
                                          TextButton(
                                              onPressed: () async {
                                                var db =
                                                    FirebaseFirestore.instance;

                                                var querySnapshot = await db
                                                    .collection('status')
                                                    .doc(doc)
                                                    .get();
                                                var querySnapshot2 = await db
                                                    .collection('user')
                                                    .where('phone',
                                                        isEqualTo:
                                                            querySnapshot[
                                                                'sender'])
                                                    .get();
                                                var querySnapshot3 = await db
                                                    .collection('user')
                                                    .where('phone',
                                                        isEqualTo:
                                                            querySnapshot[
                                                                'receiver'])
                                                    .get();

                                                Get.defaultDialog(
                                                  title: "รายระเอียดงาน",
                                                  titleStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  content: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start, // Align items to the start
                                                    children: [
                                                      Text(
                                                          "ชื่อผู้ส่ง: ${querySnapshot2.docs[0]['name']}"),
                                                      Text(
                                                          "สถานที่ผู้ส่ง: ${querySnapshot['origin']}"),
                                                      Text(
                                                          "เบอร์ผู้ส่ง: ${querySnapshot['sender']}"),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 10),
                                                        child: Container(
                                                          width: 200,
                                                          height: 1,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      Text(
                                                          "ชื่อผู้รับ:  ${querySnapshot3.docs[0]['name']}"),
                                                      Text(
                                                          "สถานที่ผู้รับ: ${querySnapshot['destination']}"),
                                                      Text(
                                                          "เบอร์ผู้รับ: ${querySnapshot['receiver']}"),
                                                    ],
                                                  ),
                                                );
                                              },
                                              child: Text("รายระเอียด")),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // TextButton(onPressed: dispose, child: const Text("xx")),
                      ],
                    )
                  ],
                  if (checkEmpty == 0) ...[
                    const Column(
                      children: [
                        Text("[คุณยังไม่มีสินค้าที่ต้องส่ง]",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 87, 71, 71)))
                      ],
                    )
                  ]
                ],
              ),
            ),
            // Loading overlay
            if (_isSaving)
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
          ],
        ),
        drawer: const MyDrawer(),
        bottomNavigationBar: const BarRider(),
      ),
    );
  }

  void realtime() {
    try {
      log("message:$doc");
      FirebaseFirestore.instance
          .collection('status')
          .doc(doc)
          .snapshots()
          .listen((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          setState(() {
            status = data['status'];

            if (status == 3) {
              stopLocationUpdates();
              // Get.snackbar('ส่งสินค้าเสร็จสิ้น', 'กลับไปหน้าแรก',
              //     snackPosition: SnackPosition.TOP);
              Get.to(const Homerider());
              return;
            }

            if (data['RiderLocation'] is GeoPoint) {
              GeoPoint riderGeo = data['RiderLocation'];
              riderLocation = LatLng(riderGeo.latitude, riderGeo.longitude);
            } else if (data['RiderLocation'] is List) {
              List<dynamic> riderList = data['RiderLocation'];
              riderLocation = LatLng(riderList[0], riderList[1]);
            }
          });
        }
      });
    } catch (e) {
      log("Error in realtime(): ${e.toString()}");
    }
  }

  void camera() async {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('status')
            .doc(doc)
            .get();
      int dist = 0;
    try {
       
      if (status == 1 ) {
        Position position = await _determinePosition();
        LatLng currentLocation = LatLng(position.latitude, position.longitude);
        GeoPoint currentGeoPoint =
            GeoPoint(currentLocation.latitude, currentLocation.longitude);
        LatLng senderLocation = const LatLng(0, 0);
        List<dynamic> senderList = [];
        double latitude = 0;
        double longitude = 0;

        if (documentSnapshot['senderlocation'] is GeoPoint) {
          GeoPoint senderGeo = documentSnapshot['senderlocation'];
          latitude = senderGeo.latitude;
          longitude = senderGeo.longitude;
          senderLocation = LatLng(latitude, longitude);
        } else if (documentSnapshot['senderlocation'] is List) {
          senderList = documentSnapshot['senderlocation'];
          if (senderList.length >= 2) {
            latitude = senderList[0];
            longitude = senderList[1];
            senderLocation = LatLng(latitude, longitude);
          }
        }

// Calculate distance
        if (latitude != 0 && longitude != 0) {
          double distance = await Geolocator.distanceBetween(
            currentLocation.latitude,
            currentLocation.longitude,
            latitude,
            longitude,
          );
          // Use double.toString() to convert to String
          log(distance.toString());
          dist = distance.toInt();
          if (distance > 20) {
            Get.snackbar('คุณอยู่ห่างเกินไป', 'ไประยะห่างตอนนี้:$dist เมตร',
                snackPosition: SnackPosition.TOP);
            return;
          }
        }
   
      }
    } catch (e) {
      log("message:$e");
    }
    try {
         if(status == 2){
        log("message");
        Position position = await _determinePosition();
        LatLng currentLocation = LatLng(position.latitude, position.longitude);
        GeoPoint currentGeoPoint =
        GeoPoint(currentLocation.latitude, currentLocation.longitude);
        LatLng senderLocation = const LatLng(0, 0);
        List<dynamic> senderList = [];
        double latitude = 0;
        double longitude = 0;

        if (documentSnapshot['receiverlocation'] is GeoPoint) {
          GeoPoint senderGeo = documentSnapshot['receiverlocation'];
          latitude = senderGeo.latitude;
          longitude = senderGeo.longitude;
          senderLocation = LatLng(latitude, longitude);
        } else if (documentSnapshot['receiverlocation'] is List) {
          senderList = documentSnapshot['receiverlocation'];
          if (senderList.length >= 2) {
            latitude = senderList[0];
            longitude = senderList[1];
            senderLocation = LatLng(latitude, longitude);
          }
        }

// Calculate distance
        if (latitude != 0 && longitude != 0) {
          double distance = await Geolocator.distanceBetween(
            currentLocation.latitude,
            currentLocation.longitude,
            latitude,
            longitude,
          );
          // Use double.toString() to convert to String
          log(distance.toString());
          dist = distance.toInt();
          if (distance > 20) {
            Get.snackbar('คุณอยู่ห่างเกินไป', 'ไประยะห่างตอนนี้:$dist เมตร',
                snackPosition: SnackPosition.TOP);
            return;
          }
        }
      }
    } catch (e) {
      
    }
    final ImagePicker picker = ImagePicker();
    image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      log('Image selected: ${image!.path}');
      if (status == 2) {
        CheckConfirm();
      } else {
        save();
      }
      setState(() {});
    } else {
      log('No image selected');
    }
  }

  // ignore: non_constant_identifier_names
  void CheckConfirm() {
    if (status == 2) {
      Get.defaultDialog(
        title: "",
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "จัดส่งเรียบร้อยเเล้วกลับไปหน้าแรก",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cancel Button (Gray)
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 13), // Padding
                    ),
                    child: const Text(
                      'ยกเลิก',
                      style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(width: 20), // Space between buttons

                  // Yes Button (Green)
                  ElevatedButton(
                    onPressed: () {
                      save();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 39, vertical: 13), // Padding
                    ),
                    child: const Text(
                      'ใช่',
                      style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  // @override
  // void dispose() {
  //   locationUpdateTimer?.cancel(); // Cancel the timer
  //   super.dispose();
  // }
  void stopLocationUpdates() {
    if (locationUpdateTimer != null) {
      locationUpdateTimer?.cancel();
      log("Location updates stopped.");
    }
  }

  void startLocationUpdates() {
    try {
      locationUpdateTimer =
          Timer.periodic(const Duration(seconds: 3), (Timer t) async {
        var position = await _determinePosition();
        LatLng currentLocation = LatLng(position.latitude, position.longitude);
        log("Current1 location: ${position.latitude}, ${position.longitude}");
        var data = {
          'RiderLocation':
              GeoPoint(currentLocation.latitude, currentLocation.longitude),
        };
        await FirebaseFirestore.instance
            .collection('status')
            .doc(doc)
            .update(data);

        setState(() {
          riderLocation = currentLocation;
          //mapController.move(riderLocation, mapController.camera.zoom);
        });
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void save() async {
    // Show loading state
    setState(() {
      _isSaving = true;
    });

    try {
      log("${status.toString()}:xxxxStsatus");
      var position = await _determinePosition();
      LatLng currentLocation = LatLng(position.latitude, position.longitude);
      mapController.move(latLng, mapController.camera.zoom);

      if (image != null) {
        File file = File(image!.path);
        String fileName = (file.path);
        log('File name: $fileName');

        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child('uploads/$fileName');
        UploadTask uploadTask = firebaseStorageRef.putFile(file);

        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {});

        await uploadTask.whenComplete(() async {
          try {
            String downloadURL = await firebaseStorageRef.getDownloadURL();
            log('Download URL: $downloadURL');
            var data = {
              'status': status + 1,
              'Statusimage': downloadURL,
              'RiderLocation':
                  GeoPoint(currentLocation.latitude, currentLocation.longitude)
            };
            await FirebaseFirestore.instance
                .collection('status')
                .doc(doc)
                .update(data);
          } catch (error) {
            log('Error getting download URL: $error');
            throw error; // Re-throw to be caught by outer try-catch
          }
        });
      } else {
        log("No image selected.");
      }
    } catch (error) {
      log('Error during save: $error');
      // You might want to show an error message to the user here
    } finally {
      // Hide loading state
      setState(() {
        _isSaving = false;
      });
    }
  }

  void loadDataAsync() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('status')
          .where('rider', isEqualTo: user.phone)
          .where('status', isLessThan: 3)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final docSnapshot =
            querySnapshot.docs.first; // assuming you want the first document
        log("doc:${docSnapshot.id}");
        doc = docSnapshot.id;
        realtime();
        setState(() {
          origin = docSnapshot['origin'] as String?;
          destination = docSnapshot['destination'] as String?;
          status = docSnapshot['status'];

          if (docSnapshot['senderlocation'] is GeoPoint) {
            GeoPoint senderGeo = docSnapshot['senderlocation'];
            senderLocation = LatLng(senderGeo.latitude, senderGeo.longitude);
          } else if (docSnapshot['senderlocation'] is List) {
            List<dynamic> senderList = docSnapshot['senderlocation'];
            senderLocation = LatLng(senderList[0], senderList[1]);
          }

          if (docSnapshot['receiverlocation'] is GeoPoint) {
            GeoPoint receiverGeo = docSnapshot['receiverlocation'];
            receiverLocation =
                LatLng(receiverGeo.latitude, receiverGeo.longitude);
          } else if (docSnapshot['receiverlocation'] is List) {
            List<dynamic> receiverList = docSnapshot['receiverlocation'];
            receiverLocation = LatLng(receiverList[0], receiverList[1]);
          }
        });

        checkEmpty = 1;
        startLocationUpdates();
        log("Chk:$checkEmpty");
      } else {
        checkEmpty = 0;
        log("No documents found.");
      }
    } catch (err) {
      checkEmpty = 0;
      log("Error in loadDataAsync: $err");
    }
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
