import 'package:fast_feast/page/login.dart';
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
              child: const Text("login"))
        ],
      ),
    );
  }
}
