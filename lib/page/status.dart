import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_feast/model/product.dart';
import 'package:fast_feast/model/rider.dart';

import 'package:fast_feast/model/status.dart';
import 'package:fast_feast/page/bar.dart';
import 'package:fast_feast/page/drawer.dart';
import 'package:fast_feast/page/home.dart';
import 'package:fast_feast/shared/appData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  String doc = '';
  MapController mapController = MapController();
  List<Status> status = [];
  List<UserModel> rider = [];
  List<Product> product = [];
  late UserInfo user;

  @override
  void initState() {
    super.initState();
    querySendData();
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
    return PopScope(
      canPop: false,
      child: Scaffold(
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
                              point: LatLng(
                                u.receiverLocation!.latitude,
                                u.receiverLocation!.longitude,
                              ),
                              width: 10,
                              height: 10,
                              child: const Icon(Icons.location_pin,
                                  color: Colors.red, size: 30),
                            ),
                            (u.status! > 0)
                                ? Marker(
                                    point: LatLng(
                                      u.riderLocation!.latitude,
                                      u.riderLocation!.longitude,
                                    ),
                                    width: 10,
                                    height: 10,
                                    child: const Icon(
                                      Icons.motorcycle_rounded,
                                      color: Color.fromARGB(255, 72, 16, 225),
                                      size: 30,
                                    ),
                                  )
                                : Marker(
                                    point: LatLng(
                                      u.senderLocation!.latitude,
                                      u.senderLocation!.longitude,
                                    ),
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
                      padding: const EdgeInsets.only(top: 10, left: 30),
                      child: u.status == 0
                          ? const Text("รอไรเดอร์มารับ")
                          : u.status == 1
                              ? const Text("ไรเดอร์มารับสินค้า")
                              : u.status == 3
                                  ? const Text("ไรเดอร์มาส่งของแล้ว")
                                  : u.status == 4
                                      ? const Text("ส่งของเสร็จสิ้น")
                                      : const SizedBox(),
                    ),
                  ),
                  if (u.status == 0 && user.role == 2)
                    content()
                  else if (rider.isNotEmpty && u.status != 3)
                    content2()
                  else if (rider.isNotEmpty && u.status == 3)
                    content3()
                  else
                    FutureBuilder(
                      future: queryUserData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return content2();
                        }
                      },
                    ),
                  if (u.status == 3 && user.role == 2)
                    FilledButton(
                      onPressed: () async {
                        try {
                          await FirebaseFirestore.instance
                              .collection('status')
                              .doc(doc)
                              .update({
                            'status': 4,
                          });
                          Get.snackbar('Success', 'รับสินค้าเสร็จสิ้น',
                              snackPosition: SnackPosition.BOTTOM);
                          Get.to(const HomePage());
                        } catch (e) {
                          log(e.toString());
                        }
                      },
                      child: const Text("รับสินค้า"),
                    )
                  else
                    const SizedBox(),
                ],
              );
            }).toList(),
          ),
        ),
        drawer: const MyDrawer(),
        bottomNavigationBar: const Bar(),
      ),
    );
  }

  Future<void> queryData() async {
    try {
      user = context.read<AppData>().user;

      var inboxRef = db.collection("status").doc(user.id);
      doc = inboxRef.id;
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
      var riderRef = db.collection("user");
      var query = riderRef.where("phone", isEqualTo: status[0].rider);

      var result = await query.get();

      if (result.docs.isNotEmpty) {
        setState(() {
          rider = result.docs
              .map((doc) {
                try {
                  return UserModel.fromJson(doc.data() as Map<String, dynamic>);
                } catch (e) {
                  log("Error parsing rider data: $e");
                  return null;
                }
              })
              .whereType<UserModel>()
              .toList();
        });
        log('Riders found: ${rider.length}');
      } else {
        setState(() {
          rider = [];
        });
        log('No riders found.');
      }
    } catch (e) {
      log("Error querying data: $e");
    }
    queryData();
    try {
      var riderRef = db.collection("send");
      var query =
          riderRef.where("description", isEqualTo: status[0].description);

      var result = await query.get();

      if (result.docs.isNotEmpty) {
        setState(() {
          product = result.docs
              .map((doc) {
                try {
                  return Product.fromJson(doc.data() as Map<String, dynamic>);
                } catch (e) {
                  log("Error parsing rider data: $e");
                  return null;
                }
              })
              .whereType<Product>()
              .toList();
        });
        log('Riders found: ${product.length}');
      } else {
        setState(() {
          product = [];
        });
        log('No riders found.');
      }
    } catch (e) {
      log("Error querying data: $e");
    }
  }

  Future<void> querySendData() async {
    try {
      var riderRef = db.collection("send");
      var query =
          riderRef.where("description", isEqualTo: status[0].description);

      var result = await query.get();

      if (result.docs.isNotEmpty) {
        setState(() {
          product = result.docs
              .map((doc) {
                try {
                  return Product.fromJson(doc.data() as Map<String, dynamic>);
                } catch (e) {
                  log("Error parsing rider data: $e");
                  return null;
                }
              })
              .whereType<Product>()
              .toList();
        });
        log('Riders found: ${product.length}');
      } else {
        setState(() {
          product = [];
        });
        log('No riders found.');
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
    return Column(
      children: product.map((p) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            width: 300,
            height: 300,
            child: Image.network(
                p.image), // Assuming r is a map containing 'image'
          ),
        );
      }).toList(),
    );
  }

  Widget content3() {
    return Column(
      children: status.map((p) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            width: 300,
            height: 300,
            child: Image.network(
                p.statusImage!), // Assuming r is a map containing 'image'
          ),
        );
      }).toList(),
    );
  }

  Widget content2() {
    return Column(
      children: [
        const Text("ไรเดอร์"),
        // Iterate over rider list
        ...rider.map((r) {
          return Padding(
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
                    child: Image.network(r.url), // Image URL for rider
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("ชื่อไรเดอร์ : ${r.name}"),
                      Text("หมายเลขโทรศัพท์ : ${r.phone}"),
                      Text("หมายเลขทะเบียน : ${r.license}"),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),

        const Text("สินค้า"),

        ...product.map((p) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 400,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white, // สีพื้นหลัง
                borderRadius: BorderRadius.circular(15), // ขอบโค้ง
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 60,
                    child: Image.network(p.image), // Image URL for product
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("ชื่อสินค้า : ${p.description}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
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
