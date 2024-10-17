import 'package:fast_feast/page/home.dart';
import 'package:fast_feast/page/login.dart';
import 'package:fast_feast/page/riderStatus.dart';
import 'package:fast_feast/page/sender.dart';
import 'package:fast_feast/page/status.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class link extends StatefulWidget {
  const link({super.key});

  @override
  State<link> createState() => _linkState();
}

class _linkState extends State<link> {
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
        ],
      ),
    );
  }
}
