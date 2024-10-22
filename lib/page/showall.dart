import 'dart:async';
import 'dart:math';
import 'package:fast_feast/model/allproduct.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_feast/model/product.dart';
import 'package:fast_feast/page/bar.dart';
import 'package:fast_feast/page/drawer.dart';
import 'package:fast_feast/shared/appData.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ShowAllPage extends StatefulWidget {
  const ShowAllPage({super.key});

  @override
  State<ShowAllPage> createState() => _ShowAllPageState();
}

class _ShowAllPageState extends State<ShowAllPage> {
  MapController mapController = MapController();

  late UserInfo user;
  List<List<Allproduct>> allProductList = [];
  List<Allproduct> allproduct = [];
  List<Color> se = [];

  @override
  void initState() {
    super.initState();
    loaddata();
  }

  LatLng latLng = const LatLng(16.246825669508297, 103.25199289277295);
  XFile? image;

  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return PopScope(
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
            children: [
              header(context),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 400,
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
                      markers: allProductList.expand((u) {
                        Color markerColor = getRandomColor();
                        se.add(markerColor);
                        return u.expand((m) {
                          return [
                            Marker(
                              point: LatLng(
                                m.senderlocation.latitude,
                                m.senderlocation.longitude,
                              ),
                              width: 10,
                              height: 10,
                              child: Icon(
                                Icons.location_pin,
                                color: markerColor,
                                size: 30,
                              ),
                            ),
                            Marker(
                              point: LatLng(
                                m.receiverlocation.latitude,
                                m.receiverlocation.longitude,
                              ),
                              width: 10,
                              height: 10,
                              child: Icon(
                                Icons.inventory_2,
                                color: markerColor,
                                size: 30,
                              ),
                            ),
                          ];
                        }).toList();
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Column(
                children: allProductList.expand((u) {
                  return u.asMap().entries.map((entry) {
                    int index = entry.key;
                    var m = entry.value;
      
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        width: 300,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 60,
                              child: Image.network(m.image),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("รายละเอียดสินค้า : ${m.description}"),
                                Text("ผู้รับ : ${m.receiver}"),
                                Text("ผู้ส่ง : ${m.sender}"),
                                Icon(
                                  Icons.inventory_2,
                                  color: se[index],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList();
                }).toList(),
              ),
            ],
          ),
        ),
        drawer: const MyDrawer(),
        bottomNavigationBar: const Bar(),
      ),
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

  Color getRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
        .withOpacity(1.0);
  }

  Future<void> loaddata() async {
    try {
      user = context.read<AppData>().user;

      for (var a in user.doc) {
        var inboxRef = db.collection("status").doc(a);
        var result = await inboxRef.get();

        if (result.exists) {
          setState(() {
            try {
              allproduct = [
                Allproduct.fromJson(result.data() as Map<String, dynamic>)
              ];
              allProductList.add(allproduct);
            } catch (e) {
              print("Error parsing user data: $e");
              allproduct = [];
            }
          });
          print('Status found.');
        } else {
          setState(() {
            allproduct = [];
          });
          print('No status found.');
        }
      }
      realtime();
    } catch (e) {
      print("Error querying data: $e");
    }
  }

  void realtime() {
    user = context.read<AppData>().user;

    // Clear existing markers
    allProductList = [];
    se = []; // Reset colors list

    for (var a in user.doc) {
      final docRef = db.collection("status").doc(a);

      docRef.snapshots().listen(
        (event) {
          if (event.exists) {
            var data = event.data();
            if (data != null) {
              try {
                setState(() {
                  // Clear and update the specific product's data
                  allproduct = [
                    Allproduct.fromJson(data as Map<String, dynamic>)
                  ];

                  int existingIndex = allProductList.indexWhere((list) =>
                      list.any((product) =>
                          product.description == allproduct[0].description));

                  if (existingIndex != -1) {
                    allProductList[existingIndex] = allproduct;
                  } else {
                    allProductList.add(allproduct);
                    // Add new color for new product
                    se.add(getRandomColor());
                  }

                  // Update map center to show all markers
                });
              } catch (e) {
                print("Error parsing status data: $e");
              }
            }
          } else {
            setState(() {
              // Remove product if document no longer exists
              allProductList.removeWhere(
                  (list) => list.any((product) => product.description == a));
            });
            print('No status found for document: $a');
          }
        },
        onError: (error) => print("Listen failed: $error"),
      );
    }
  }

// Add this new method to update map bounds

// // เมื่อต้องการยกเลิก listeners ทั้งหมด
//   void cancelListeners() {
//     final listeners = context.read<AppData>().listeners;
//     for (var listener in listeners) {
//       listener.cancel();
//     }
//     listeners.clear();
//   }
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
