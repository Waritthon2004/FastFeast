import 'package:flutter/material.dart';

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
    );
  }
}
