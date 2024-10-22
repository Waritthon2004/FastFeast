import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_feast/page/Bigmap.dart';
import 'package:fast_feast/page/home.dart';
import 'package:fast_feast/page/login.dart';
import 'package:fast_feast/page/process_send.dart';
import 'package:fast_feast/page/riderStatus.dart';
import 'package:fast_feast/page/sender.dart';
import 'package:fast_feast/page/status.dart';
import 'package:fast_feast/shared/appData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class link extends StatefulWidget {
  const link({super.key});

  @override
  State<link> createState() => _linkState();
}

class _linkState extends State<link> {
  late UserInfo user;
  @override
  void initState() {
    super.initState();
    user = context.read<AppData>().user;
    // loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          FilledButton(
              onPressed: () {
                Get.to(const Login());
              },
              child: const Text("login")),
          FilledButton(
              onPressed: () {
                Get.to(const HomePage());
              },
              child: const Text("home")),
          FilledButton(
              onPressed: () {
                Get.to(const SenderPage());
              },
              child: const Text("Sender")),
          FilledButton(
              onPressed: () {
                Get.to(const StatusPage());
              },
              child: const Text("Status")),
          FilledButton(
              onPressed: () {
                Get.to(const Riderstatus());
              },
              child: const Text("RiderStatus")),
          FilledButton(
              onPressed: () {
                Get.to(const ProcessSendPage());
              },
              child: const Text("Process_Send")),
          FilledButton(
              onPressed: () {
                Get.to(const Checkmap());
              },
              child: const Text("bigmap")),
          FilledButton(
              onPressed: () async {
                try {
                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                      .collection('status')
                      .where('rider', isEqualTo: "100")
                      .where('status', isNotEqualTo: 3)
                      .get();

                  if (querySnapshot.docs.isNotEmpty) {
                    for (var doc in querySnapshot.docs) {
                      log('Document ID: ${doc.id}');
                    }
                    Get.snackbar('ผิดพลาด', 'คุณมีสินค้าต้องส่งอยู่เเล้ว',
                        snackPosition: SnackPosition.TOP);
                    return;
                  }
                  else{
                    log("message");
                  }
                } catch (e) {
                  log('Error querying Firestore: $e');
                }
              },
              child: const Text("test")),
        ],
      ),
    );
  }
}
