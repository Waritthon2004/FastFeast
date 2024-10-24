import 'package:fast_feast/page/homeRider.dart';
import 'package:fast_feast/page/login.dart';
import 'package:fast_feast/page/riderStatus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BarRider extends StatefulWidget {
  // Change to StatefulWidget
  const BarRider({super.key});

  @override
  State<BarRider> createState() => _BarRiderState();
}

class _BarRiderState extends State<BarRider> {
  int _selectedIndex = 0; // Add state variable

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'หน้าแรก',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.motorcycle),
          label: 'ข้อมูลการขนส่ง',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'ออกจากระบบ',
        ),
      ],
      currentIndex: _selectedIndex, // Use the state variable
      selectedItemColor: const Color(0xFF5D939F),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) async {
    // Make async
    setState(() {
      _selectedIndex = index; // Update selected index
    });

    switch (index) {
      case 0:
        Get.to(() => const Homerider());
        break;
      case 1:
        Get.to(() => const Riderstatus());
        break;
      case 2:
        Get.defaultDialog(
          title: "",
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "ยืนยันออกจากระบบ?",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 13,
                        ),
                      ),
                      child: const Text(
                        'ยกเลิก',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Get.to(const Login());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 231, 17, 17),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 39,
                          vertical: 13,
                        ),
                      ),
                      child: const Text(
                        'ใช่',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
        break;
    }
  }
}
