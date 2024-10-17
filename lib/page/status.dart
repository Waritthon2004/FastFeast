import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_feast/page/bar.dart';
import 'package:fast_feast/page/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  final MapController mapController = MapController();
  var data;
  @override
  void initState() {
    super.initState();
    readdata();
  }

  LatLng latLng = const LatLng(16.246825669508297, 103.25199289277295);
  XFile? image;
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
              height: 100,
            ),
            SizedBox(
              width: 300,
              height: 300,
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
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 10, left: 30),
                child: Text("สถานะการส่งของ"),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 10, left: 30),
                child: Text("รอไรเดอร์มารับ"),
              ),
            ),
            content(),
            FilledButton(
                onPressed: () async {
                  var position = await _determinePosition();
                  log("${position.altitude} and ${position.longitude}");
                  latLng = LatLng(position.latitude, position.longitude);
                  mapController.move(latLng, mapController.camera.zoom);
                  setState(() {});
                },
                child: const Text("Get Location"))
          ],
        ),
      ),
      drawer: const MyDrawer(),
      bottomNavigationBar: const Bar(),
    );
  }

  void readdata() async {
    try {
      var result = await db.collection('send').doc('เมาส์').get();

      if (result.exists) {
        data = result.data();
      } else {
        log('ไม่มีเอกสาร');
      }
    } catch (err) {
      log(err.toString());
    }
  }

  Widget content() {
    return (data != null && data!['image'] != null)
        ? Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              width: 300,
              height: 300,
              child: Image.network(data!['image']),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              width: 300,
              height: 300,
              color: Colors.white,
            ),
          );
  }

  Widget content2() {
    return Container(
      child: Column(
        children: [
          const Text("ไรเดอร์"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 400,
              height: 80,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("images"),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ชื่อไรเดอร์ : Rujlnwza "),
                      Text("หมายเลขโทรศัพท์ : 09971658777 "),
                      Text("หมายเลขทะเบียน : กก568")
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 400,
              height: 80,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("images"),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ชื่อไรเดอร์ : Rujlnwza "),
                      Text("หมายเลขโทรศัพท์ : 09971658777 "),
                      Text("หมายเลขทะเบียน : กก568")
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget header(BuildContext context) {
  return Container(
    color: const Color(0xFF1ABBE0),
    width: MediaQuery.of(context).size.width,
    height: 90,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF5D939F),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                "สถานะการจัดส่ง",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ),
  );
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
