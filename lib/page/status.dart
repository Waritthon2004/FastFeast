import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_feast/model/status.dart';
import 'package:fast_feast/page/bar.dart';
import 'package:fast_feast/page/drawer.dart';
import 'package:fast_feast/shared/appData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  MapController mapController = MapController();
  List<Status> status = [];
  late UserInfo user;
  var data;
  @override
  void initState() {
    super.initState();

    queryData();
    realtime();
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
          children: status.map((u) {
            return Column(
              children: [
                header(context),
                const SizedBox(
                  height: 20,
                ),
                CustomStatusBar(
                  icons: const [
                    Icons.hourglass_empty,
                    Icons.phone_android,
                    Icons.motorcycle,
                    Icons.check_circle,
                  ],
                  currentStep: u.status!,
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
                      initialZoom: 12.0,
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
                            point: LatLng(u.receiverlocation!.latitude,
                                u.receiverlocation!.longitude),
                            width: 10,
                            height: 10,
                            child: const Icon(Icons.location_pin,
                                color: Colors.red, size: 30),
                          ),
                          (u.status! > 0)
                              ? Marker(
                                  point: LatLng(u.RiderLocation!.latitude,
                                      u.RiderLocation!.longitude),
                                  width: 10,
                                  height: 10,
                                  child: const Icon(
                                    Icons.motorcycle_rounded,
                                    color: Color.fromARGB(255, 72, 16, 225),
                                    size: 30,
                                  ),
                                )
                              : Marker(
                                  point: LatLng(u.senderlocation!.latitude,
                                      u.senderlocation!.longitude),
                                  width: 10,
                                  height: 10,
                                  child: const Icon(
                                    Icons.location_pin,
                                    color: Color.fromARGB(255, 72, 16, 225),
                                    size: 30,
                                  ),
                                )
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, left: 30),
                    child: u.status == 0
                        ? Text("รอไรเดอร์มารับ")
                        : u.status == 1
                            ? Text("ไรเดอร์มารับสินค้า")
                            : u.status == 3
                                ? Text("ไรเดอร์กำลังมาส่งของ")
                                : u.status == 4
                                    ? Text("ส่งของเสร็จสิ้น")
                                    : SizedBox(),
                  ),
                ),
                content2(),
              ],
            );
          }).toList(),
        ),
      ),
      drawer: const MyDrawer(),
      bottomNavigationBar: const Bar(),
    );
  }

  Future<void> queryData() async {
    try {
      user = context.read<AppData>().user;
      log("AAAA" + user.id);
      var inboxRef = db.collection("status").doc(user.id);

      var result = await inboxRef.get(); // Fetch a single document

      if (result.exists) {
        // Check if the document exists
        setState(() {
          try {
            status = [
              Status.fromJson(result.data() as Map<String, dynamic>)
            ]; // Convert to a list
          } catch (e) {
            log("Error parsing user data: $e");
            status = [];
          }
        });
        log('Status found.');
      } else {
        setState(() {
          status = [];
        });
        log('No status found.');
      }
    } catch (e) {
      log("Error querying data: $e");
    }
  }

  Future<void> queryUserData() async {
    try {
      var inboxRef = db.collection("rider");
      var query = inboxRef.where("phone", isEqualTo: status[0].rider);

      var result = await query.get();

      if (result.docs.isNotEmpty) {
        setState(() {
          status = result.docs
              .map((doc) {
                try {
                  return Status.fromJson(doc.data() as Map<String, dynamic>);
                } catch (e) {
                  log("Error parsing user data: $e");
                  return null;
                }
              })
              .whereType<Status>()
              .toList();
        });
        log('status found: ${status.length}');
      } else {
        setState(() {
          status = [];
        });
        log('No status found.');
      }
    } catch (e) {
      log("Error querying data: $e");
    }
  }

  void realtime() {
    final docRef = db.collection("status").doc(user.id);
    context.read<AppData>().listener = docRef.snapshots().listen(
      (event) {
        var data = event.data();
        if (data != null) {
          try {
            Status statusData = Status.fromJson(data as Map<String, dynamic>);
            setState(() {
              status = [statusData];
            });
            log('Status updated: $status');
          } catch (e) {
            log("Error parsing status data: $e");
          }
        } else {
          setState(() {
            status = [];
          });
          log('No status found.');
        }
      },
      onError: (error) => log("Listen failed: $error"),
    );
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
