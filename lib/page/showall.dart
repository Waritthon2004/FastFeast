import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_feast/model/product.dart';
import 'package:fast_feast/page/bar.dart';
import 'package:fast_feast/page/drawer.dart';
import 'package:fast_feast/shared/appData.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class showallPage extends StatefulWidget {
  const showallPage({super.key});

  @override
  State<showallPage> createState() => _showallPageState();
}

class _showallPageState extends State<showallPage> {
  MapController mapController = MapController();

  late UserInfo user;

  @override
  void initState() {
    super.initState();
    user = context.read<AppData>().user;
  }

  LatLng latLng = const LatLng(16.246825669508297, 103.25199289277295);
  late LatLng send;
  late LatLng recvied;
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    user.image,
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
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.8,
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
                          width: 40,
                          height: 40,
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Container(
                              color: Colors.amber,
                            ),
                          ),
                          alignment: Alignment.center),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: const MyDrawer(),
      bottomNavigationBar: const Bar(),
    );
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
