import 'package:fast_feast/page/homeRider.dart';
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
          icon: Icon(Icons.touch_app),
          label: 'รับสินค้า',
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
      
        break;
     
    }
  }
}
