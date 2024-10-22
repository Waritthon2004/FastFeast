import 'dart:developer';

import 'package:fast_feast/page/bar.dart';
import 'package:fast_feast/page/drawer.dart';
import 'package:fast_feast/page/process_send.dart';
import 'package:fast_feast/page/sender.dart';
import 'package:fast_feast/shared/appData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserInfo user;
  void initState() {
    super.initState();
    user = context.read<AppData>().user;
  }

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
          drawer: const MyDrawer(),
          body: SingleChildScrollView(
            child: Column(
              children: [header(context), body()],
            ),
          ),
          bottomNavigationBar: const Bar()),
    );
  }

  Widget header(BuildContext context) {
    return Container(
      color: const Color(0xFF1ABBE0),
      width: MediaQuery.of(context).size.width,
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Hi Ruj", style: TextStyle(color: Colors.white)),
              const Text("What are you looking for ?",
                  style: TextStyle(color: Colors.white)),
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
                      child: Row(
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
                            child: Text(user.address,
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
}

Widget body() {
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Column(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(const SenderPage());
          },
          child: SizedBox(
            width: 300,
            height: 100,
            child: Card(
              color: Colors.white,
              elevation: 8,
              child: Center(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Image.asset(
                        "assets/image/buy.png",
                        width: 80,
                        height: 80,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 40),
                      child: Text(
                        "ส่งสินค้า",
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(const ProcessSendPage());
          },
          child: Container(
            width: 300,
            height: 100,
            child: Card(
              color: Colors.white,
              elevation: 8,
              child: Center(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Image.asset(
                        "assets/image/give.png",
                        width: 80,
                        height: 80,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 40),
                      child: Text(
                        "รับสินค้า",
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    ),
  );
}
