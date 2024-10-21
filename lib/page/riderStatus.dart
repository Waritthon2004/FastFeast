import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_feast/page/barRider.dart';
import 'package:fast_feast/page/drawer.dart';
import 'package:fast_feast/shared/appData.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
// import 'package:path/path.dart';
import 'package:provider/provider.dart';

class Riderstatus extends StatefulWidget {
  const Riderstatus({super.key});

  @override
  State<Riderstatus> createState() => _RiderstatusState();
}

class _RiderstatusState extends State<Riderstatus> {
  @override
  late UserInfo user;
  void initState() {
    super.initState();
    user = context
        .read<AppData>()
        .user; // Or use watch if you need it to listen for changes
    loadDataAsync();
  }

  final MapController mapController = MapController();
  int status = 0;
  XFile? image;
   String? origin='';
   String? destination='';
  @override
  LatLng latLng = const LatLng(16.246825669508297, 103.25199289277295);
  var db = FirebaseFirestore.instance;
  late Future<QuerySnapshot> loadData;
  // var data = [];
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1ABBE0),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
             Container(
    decoration: const BoxDecoration(
      color: Color(0xFF1ABBE0),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20), // Bottom-left corner radius
        bottomRight: Radius.circular(20), // Bottom-right corner radius
      ),
    ),
    width: MediaQuery.of(context).size.width,
    height: 120,
    child:  Padding(
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
            icons: [
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
                            Row(
                              children: [
                                const Icon(Icons.local_shipping,
                                    color: Colors.orange),
                                const SizedBox(width: 8),
                                Text( origin!,style: const TextStyle(fontSize: 24,
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
                             Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.blue),
                                const SizedBox(width: 8),
                                Text(destination!,
                                    style: const TextStyle(
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
            ),
            // TextButton(onPressed: loadDataAsync, child: const Text("xx"))
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
   Position position = await _determinePosition();
    
    LatLng currentLocation = LatLng(position.latitude, position.longitude);
    mapController.move(latLng, mapController.camera.zoom);
    setState(() {});

    if (image != null) {
      File file = File(image!.path);
      String fileName = (file.path);
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
            'status': status+1,
            'image': downloadURL,
            'RiderLocation':GeoPoint(currentLocation.latitude, currentLocation.longitude)
          };
          await FirebaseFirestore.instance
              .collection('status')
              .doc(user.docStatus)
              .update(data);
        } catch (error) {
          log('Error getting download URL: $error');
        }
        
        setState(() {
          status = status+1;
        });
      }).catchError((error) {
        log('Upload error: $error');
      });
    } else {
      log("No image selected.");
    }
  }

 void loadDataAsync() async {
  try {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('status')
        .doc(user.docStatus)
        .get();
    setState(() {
      origin = docSnapshot['origin'] as String?;
      destination =  docSnapshot['destination'] as String?;
      status = docSnapshot['status'];
      // You can also store other fields you need
    });
    
    log("Origin: $status");
  } catch (err) {
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
