import 'package:fast_feast/page/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Padding(
      padding: const EdgeInsets.only(top: 30, left: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/image/luffy.jpg',
              width: 100,
            ),
          ),
          ListTile(
            title: const Text("Home"),
            leading: const Icon(Icons.home),
            onTap: () {
              Get.to(const HomePage());
            },
          ),
          const Divider(
            indent: 30,
            endIndent: 30,
          ),
          ListTile(
            title: const Text("Logout"),
            leading: const Icon(Icons.logout),
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          Expanded(child: Container()),
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text("65011212075 @ 65011212048"),
          )
        ],
      ),
    ));
  }
}
