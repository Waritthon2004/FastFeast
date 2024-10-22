import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_feast/page/riderStatus.dart';
import 'package:fast_feast/shared/appData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart'; // ใช้ถ้าใช้ Flutter Map
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart'; // ใช้ถ้าใช้ Flutter Map

class Checkmap extends StatefulWidget {
  const Checkmap({super.key});

  @override
  State<Checkmap> createState() => _CheckmapState();
}

class _CheckmapState extends State<Checkmap> {
  // กำหนดตำแหน่งเริ่มต้นของแมพ
  LatLng _currentPosition = LatLng(16.186182, 103.247185);
  late MapController mapController;
  LatLng riderLocation = const LatLng(0, 0);
  LatLng receiverLocation = const LatLng(0, 0);
  LatLng senderLocation = const LatLng(0, 0);
    String? origin = '';
  String? destination = '';
  late UserInfo user;
    @override
  void initState() {
    super.initState();
    user = context.read<AppData>().user;
      mapController = MapController();
    log(user.phone);
    loadDataAsync();

    // Start updating the location every 3 seconds
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ใช้ FlutterMap เพื่อแทนที่ placeholder ของแผนที่
          FlutterMap(
            mapController: mapController,
            options: const MapOptions(
                    initialZoom: 15.0,
                    initialCenter: LatLng(16.246825669508297, 103.25199289277295),
                    maxZoom: 19.0,
                  ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
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

          // Road numbers overlay
          Positioned(
            top: 100,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Text('227'),
            ),
          ),
          Positioned(
            top: 200,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Text('299'),
            ),
          ),

          // Delivery status card
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Delivery icon and text
                    Row(
                      children: [
                        Icon(Icons.shopping_bag, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(
                          origin!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
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
                     Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        Text(destination!),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Accept button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (){
                          Get.to(const Riderstatus());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 103, 113, 249),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'รายละเอียดการส่งสินค้า',
                          style: TextStyle(color: Colors.white,fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
   

        setState(() {
          origin = docSnapshot['origin'] as String?;
          destination = docSnapshot['destination'] as String?;

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
          if (docSnapshot['RiderLocation'] is GeoPoint) {
            GeoPoint riderGeo = docSnapshot['RiderLocation'];
            riderLocation = LatLng(riderGeo.latitude, riderGeo.longitude);
          } else if (docSnapshot['RiderLocation'] is List) {
            List<dynamic> riderList = docSnapshot['RiderLocation'];
            riderLocation = LatLng(riderList[0], riderList[1]);
          }
        });
        
     
      } else {

        log("No documents found.");
      }
    } catch (err) {

      log("Error in loadDataAsync: $err");
    }
  }
}