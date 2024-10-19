import 'package:fast_feast/page/bar.dart';
import 'package:fast_feast/page/drawer.dart';
import 'package:flutter/material.dart';

class ProcessSendPage extends StatefulWidget {
  const ProcessSendPage({super.key});

  @override
  State<ProcessSendPage> createState() => _ProcessSendPageState();
}

class _ProcessSendPageState extends State<ProcessSendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.white, // สีพื้นหลัง
                  borderRadius: BorderRadius.circular(15), // ขอบโค้ง
                ),
                child: Column(
                  children: [const Text("สินค้าไปส่ง"), content()],
                ),
              ),
            )
          ],
        ),
      ),
      drawer: const MyDrawer(),
      bottomNavigationBar: const Bar(),
    );
  }
}

Widget content() {
  return Padding(
    padding: const EdgeInsets.only(top: 20),
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
            Image.network(
                "https://i.pinimg.com/enabled_lo/564x/7a/c8/30/7ac8304987fd3eb12b13ac28b9e06f02.jpg"),
            const Column(
              children: [
                Text("Ice bear"),
                Text("Ruj"),
                Row(
                  children: [
                    Icon(Icons.location_pin,
                        color: Color.fromARGB(255, 41, 94, 240), size: 30),
                    Text("Roi-et")
                  ],
                ),
              ],
            ),
            Icon(Icons.search,
                color: Color.fromARGB(255, 41, 94, 240), size: 30)
          ],
        )),
  );
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
