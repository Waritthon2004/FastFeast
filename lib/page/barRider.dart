import 'package:fast_feast/page/homeRider.dart';
import 'package:fast_feast/page/login.dart';
import 'package:fast_feast/page/riderStatus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class BarRider extends StatelessWidget {
  const BarRider({super.key});

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
      currentIndex: 0,
      selectedItemColor: const Color(0xFF5D939F),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      onTap: _onItemTapped,
    );
  }
   void _onItemTapped(int index) {
 
    switch (index) {
      case 0:
        Get.to(const Homerider());
        break;
      case 1:
      Get.to(const Riderstatus());
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
                  // Cancel Button (Gray)
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 13), // Padding
                    ),
                    child: const Text(
                      'ยกเลิก',
                      style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(width: 10), // Space between buttons

                  // Yes Button (Green)
                  ElevatedButton(
                    onPressed: () {
                   Get.to(const Login());
                  
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 231, 17, 17), // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 39, vertical: 13), // Padding
                    ),
                    child: const Text(
                      'ใช่',
                      style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
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
