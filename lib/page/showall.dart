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
  Map<String, Color> productColors = {};

  List<Color> se = []; // List for storing colors

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
            children: [
              header(context), // Assuming this is your header widget
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
                        return u.expand((m) {
                          // Assign color based on the product's description or unique identifier
                          if (!productColors.containsKey(m.description)) {
                            productColors[m.description!] = getRandomColor();
                          }
                          Color markerColor = productColors[m.description]!;

                          return [
                            Marker(
                              point: LatLng(
                                m.status != 0
                                    ? m.riderLocation!.latitude
                                    : m.senderlocation!.latitude,
                                m.status != 0
                                    ? m.riderLocation!.longitude
                                    : m.senderlocation!.longitude,
                              ),
                              width: 30,
                              height: 30,
                              child: Icon(
                                m.status != 0
                                    ? Icons.motorcycle_rounded
                                    : Icons.location_pin,
                                color: markerColor,
                                size: 30,
                              ),
                            ),
                            Marker(
                              point: LatLng(
                                m.receiverlocation!.latitude,
                                m.receiverlocation!.longitude,
                              ),
                              width: 30,
                              height: 30,
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
                    PolylineLayer(
                      polylines: allProductList.expand((u) {
                        Color markerColor = getRandomColor();

                        return u.map((m) {
                          return Polyline(
                            points: [
                              LatLng(
                                m.status != 0
                                    ? m.riderLocation!.latitude
                                    : m.senderlocation!.latitude,
                                m.status != 0
                                    ? m.riderLocation!.longitude
                                    : m.senderlocation!.longitude,
                              ),
                              LatLng(
                                m.receiverlocation!.latitude,
                                m.receiverlocation!.longitude,
                              ),
                            ],
                            strokeWidth: 3.0,
                            color: markerColor,
                          );
                        }).toList();
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Column(
                children: allProductList.expand((u) {
                  return u.map((m) {
                    // Use the same color from the map
                    Color productColor = productColors[m.description]!;

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
                              child: Image.network(m.image!),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("รายละเอียดสินค้า : ${m.description}"),
                                Text("ผู้รับ : ${m.receiver}"),
                                Text("ผู้ส่ง : ${m.sender}"),
                                Row(
                                  children: [
                                    Icon(
                                      m.status != 0
                                          ? Icons.motorcycle_rounded
                                          : Icons.location_pin,
                                      color: productColor,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Icon(
                                        Icons.inventory_2,
                                        color:
                                            productColor, // Use the mapped color
                                      ),
                                    ),
                                  ],
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
              // Generate and store a new color for the product
              se.add(getRandomColor());
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

    for (var a in user.doc) {
      final docRef = db.collection("status").doc(a);

      context.read<AppData>().listener2 = docRef.snapshots().listen(
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
}
