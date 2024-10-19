import 'dart:developer';
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
  MapController mapController = MapController();

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            header(context),
            const SizedBox(
              height: 20,
            ),
            const CustomStatusBar(
              icons: [
                Icons.hourglass_empty,
                Icons.phone_android,
                Icons.motorcycle,
                Icons.check_circle,
              ],
              currentStep: 0,
            ),
            const SizedBox(
              height: 20,
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
                        child: const Icon(Icons.location_pin,
                            color: Colors.red, size: 30),
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
            content2(),
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
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white, // สีพื้นหลัง
                borderRadius: BorderRadius.circular(15), // ขอบโค้ง
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 60,
                    child: Image.network(""),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
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
          const Text("สินค้า"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 400,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white, // สีพื้นหลัง
                borderRadius: BorderRadius.circular(15), // ขอบโค้ง
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 60,
                    child: Image.network(""),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
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
            ? const Color.fromARGB(255, 13, 228, 56)
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
      color: isCompleted
          ? const Color.fromARGB(255, 0, 211, 14)
          : Colors.grey[300],
    );
  }
}
