import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_feast/page/Bigmap.dart';
import 'package:fast_feast/page/barRider.dart';
import 'package:fast_feast/page/drawer.dart';
import 'package:fast_feast/shared/appData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class Homerider extends StatefulWidget {
  const Homerider({super.key});

  @override
  State<Homerider> createState() => _HomeriderState();
}

class _HomeriderState extends State<Homerider> {
  late UserInfo user;
  late Future<QuerySnapshot> loadData;
  int dist = 0;
  @override
  void initState() {
    super.initState();
    user = context.read<AppData>().user;
    log("myname:${user.name}");
    log("myname:${user.phone}");

    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1ABBE0),
      ),
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildDeliveryList(),
          ],
        ),
      ),
      bottomNavigationBar: const BarRider(),
    );
  }

  Widget _buildHeader() {
    return PopScope(
      canPop: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1ABBE0),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: 150,
        padding: const EdgeInsets.only(left: 50, bottom: 30),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(user.image),
              ),
            ),
            const SizedBox(width: 9),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'สวัสดี',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 3),
                  child: Text(
                    user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            "รายการสินค้าที่ต้องส่ง",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 51, 48, 70),
            ),
          ),
          const Divider(indent: 40, endIndent: 40),
          FutureBuilder<QuerySnapshot>(
            future: loadData,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text("No deliveries available");
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs[index];
                  return DeliveryItemWidget(
                      origin: doc['origin'],
                      location: doc['destination'],
                      doc: doc.id,
                      phone: user.phone);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<QuerySnapshot> loadDataAsync() async {
    try {
      Query<Map<String, dynamic>> collectionRef = FirebaseFirestore.instance
          .collection('status')
          .where('status', isEqualTo: 0);
      QuerySnapshot querySnapshot = await collectionRef.get();

      return querySnapshot;
    } catch (err) {
      log("Error in loadDataAsync: $err");
      rethrow;
    }
  }
}

// ignore: must_be_immutable
class DeliveryItemWidget extends StatelessWidget {
  final String origin;
  final String location;
  final String doc;
  String phone;
  DeliveryItemWidget({
    super.key,
    required this.origin,
    required this.location,
    required this.doc,
    required this.phone,
  });

  final MapController mapController = MapController();
  LatLng showw = const LatLng(0, 0);
  int dist = 0;
  late LatLng currentLocation;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
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
                      const Icon(Icons.local_shipping, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        origin,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      width:
                          1, // This controls the thickness of the vertical line
                      height: 40, // This controls the height of the line
                      color: Colors.grey, // Line color
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(location,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Position position = await _determinePosition();
                        LatLng currentLocation =
                            LatLng(position.latitude, position.longitude);
                        try {
                          DocumentSnapshot documentSnapshot =
                              await FirebaseFirestore.instance
                                  .collection('status')
                                  .doc(doc)
                                  .get();

                          if (documentSnapshot['status'] != 0) {
                            Get.snackbar('ผิดพลาด', 'ไม่สามรถรับงานนี้ได้',
                                snackPosition: SnackPosition.TOP);
                            return;
                          }
                          QuerySnapshot querySnapshot = await FirebaseFirestore
                              .instance
                              .collection('status')
                              .where("rider", isEqualTo: phone)
                              .where("status", isLessThan: 3)
                              .get();

                          if (querySnapshot.docs.isNotEmpty) {
                            Get.snackbar('ผิดพลาด', 'ไม่สามรถรับงานนี้ได้',
                                snackPosition: SnackPosition.TOP);
                          }
                          GeoPoint currentGeoPoint = GeoPoint(
                              currentLocation.latitude,
                              currentLocation.longitude);
                        } catch (e) {
                          log('Error querying Firestore: $e');
                        }

                        try {
                          await FirebaseFirestore.instance
                              .collection('status')
                              .doc(doc)
                              .update({
                            'status': 1,
                            'rider': phone,
                            'RiderLocation': GeoPoint(currentLocation.latitude,
                                currentLocation.longitude)
                          });
                          log('Document updated successfully');
                        } catch (e) {
                          log('Error updating document: $e');
                        }
                        Get.to(const Checkmap());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 56, 104, 248),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 12),
                        minimumSize: const Size(100, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16), // Border radius of 10
                        ),
                      ),
                      child: const Text(
                        'รับงาน',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          var db = FirebaseFirestore.instance;

                          var querySnapshot =
                              await db.collection('status').doc(doc).get();
                          var querySnapshot2 = await db
                              .collection('user')
                              .where('phone',
                                  isEqualTo: querySnapshot['sender'])
                              .get();
                          var querySnapshot3 = await db
                              .collection('user')
                              .where('phone',
                                  isEqualTo: querySnapshot['receiver'])
                              .get();

                          Get.defaultDialog(
                            title: "รายระเอียดงาน",
                            titleStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Align items to the start
                              children: [
                                Text(
                                    "ชื่อผู้ส่ง: ${querySnapshot2.docs[0]['name']}"),
                                Text(
                                    "สถานที่ผู้ส่ง: ${querySnapshot['origin']}"),
                                Text("เบอร์ผู้ส่ง: ${querySnapshot['sender']}"),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
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
                                Text(
                                    "เพิ่มเติม : ${querySnapshot['description']}"),
                              ],
                            ),
                          );
                        },
                        child: const Text(
                          "รายระเอียด",
                          style: TextStyle(fontSize: 13),
                        ))
                  ],
                ),
              ),
            ],
          ),
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
}
