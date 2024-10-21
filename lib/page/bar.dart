import 'package:fast_feast/page/home.dart';
import 'package:fast_feast/page/sendlist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Bar extends StatelessWidget {
  const Bar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'หน้าแรก',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_car),
          label: 'สินค้าที่กำลังไปส่ง',
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
        Get.to(const HomePage());
        break;
      case 1:
        Get.to(const Sendlist());
        break;
      case 2:
        break;
    }
  }
}
