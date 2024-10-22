import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_feast/model/status.dart';
import 'package:fast_feast/page/bar.dart';
import 'package:fast_feast/page/drawer.dart';
import 'package:fast_feast/page/showall.dart';
import 'package:fast_feast/page/status.dart';
import 'package:fast_feast/shared/appData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProcessSendPage extends StatefulWidget {
  const ProcessSendPage({super.key});

  @override
  State<ProcessSendPage> createState() => _ProcessSendPageState();
}

class _ProcessSendPageState extends State<ProcessSendPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Status> status = [];
  late UserInfo user;
  @override
  void initState() {
    super.initState();

    queryData();
  }

  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1ABBE0),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              header(context),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white, // สีพื้นหลัง
                    borderRadius: BorderRadius.circular(15), // ขอบโค้ง
                  ),
                  child: Column(
                    children: [
                      const Text("สินค้ากำลังมาส่ง"),
                      content(),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: FilledButton(
                            onPressed: () {
                              Data();
                            },
                            child: Text("ดูรายละเอียดทั้งหมด")),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        drawer: const MyDrawer(),
        bottomNavigationBar: const Bar(),
      ),
    );
  }

  Widget content() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: status.map((u) {
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              width: 250,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white, // สีพื้นหลัง
                borderRadius: BorderRadius.circular(15), // ขอบโค้ง
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // สีเงา
                    spreadRadius: 1, // ความกว้างของเงา
                    blurRadius: 7, // ระยะเบลอของเงา
                    offset: const Offset(0, 5), // ตำแหน่งของเงา (x, y)
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.network(u.image!),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(u.description!),
                      Text(u.sender!),
                      Row(
                        children: [
                          const Icon(Icons.location_pin,
                              color: Color.fromARGB(255, 41, 94, 240),
                              size: 30),
                          Text(u.destination!),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      await docid(u.description!);
                    },
                    child: const Icon(Icons.search,
                        color: Color.fromARGB(255, 41, 94, 240), size: 30),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> queryData() async {
    try {
      user = context.read<AppData>().user;
      var inboxRef = db.collection("status");

      var query = inboxRef.where("receiver", isEqualTo: user.phone).where('status', isLessThan: 4);

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

  Future<void> docid(String x) async {
    try {
      var inboxRef = db.collection("status");

      var query = inboxRef.where("description", isEqualTo: x);

      var result = await query.get();

      if (result.docs.isNotEmpty) {
        setState(() {
          status = result.docs
              .map((doc) {
                try {
                  user.id = doc.id;
                  user.role = 2;
                  context.read<AppData>().user.id = user.id;
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
        Get.to(const StatusPage());
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

  Future<void> Data() async {
    try {
      user = context.read<AppData>().user;
      context.read<AppData>().user.doc = [];
      var inboxRef = db.collection("status");

      var query = inboxRef.where("receiver", isEqualTo: user.phone);

      var result = await query.get();

      if (result.docs.isNotEmpty) {
        setState(() {
          status = result.docs
              .map((doc) {
                try {
                  user.doc.add(doc.id);

                  context.read<AppData>().user.id = user.id;
                  return Status.fromJson(doc.data() as Map<String, dynamic>);
                } catch (e) {
                  log("Error parsing user data: $e");
                  return null;
                }
              })
              .whereType<Status>()
              .toList();
        });

        Get.to(const ShowAllPage());
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
}

Widget header(BuildContext context) {
  return Container(
    color: const Color(0xFF1ABBE0),
    width: MediaQuery.of(context).size.width,
    height: 90,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Center(
                child: Container(
                    width: 300,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5D939F),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text("Mahasarakham University",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
