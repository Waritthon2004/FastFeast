import 'package:fast_feast/page/barRider.dart';
import 'package:fast_feast/page/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class Homerider extends StatefulWidget {
  const Homerider({super.key});

  @override
  State<Homerider> createState() => _HomeriderState();
}

class _HomeriderState extends State<Homerider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1ABBE0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://scontent.fkkc3-1.fna.fbcdn.net/v/t39.30808-6/418475547_3527827574134521_421755393680319339_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeEdVbCSMT19XcCJXhl5nM39mQjXit1mkmGZCNeK3WaSYSp5wgXWCPNiHHAh6XVgQnTipxlh1_zNMxK-9zURA1v6&_nc_ohc=EGyqa2atILQQ7kNvgH29C8H&_nc_ht=scontent.fkkc3-1.fna&_nc_gid=AsHfHHfap3Zg_3H-Jjlxf7S&oh=00_AYA7OJtV-RRSy7W5SkEv5bsQ1fYe1vOpLOrPZ_n__wJ_rg&oe=6700AB47",
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
            children: [
              header(context),
              const Padding(
                padding: EdgeInsets.only(top: 30, bottom: 5),
                child: Text(
                  "รายการสินค้าที่ต้องส่ง",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 51, 48, 70)),
                ),
              ),
              const Divider(
                indent: 40,
                endIndent: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DeliveryItemWidget(
                      title: 'ตลาดน้อย',
                      location: 'ตึก IT มสส',
                    ),
                    SizedBox(height: 16),
                    DeliveryItemWidget(
                      title: 'ตลาดน้อย',
                      location: 'หอพักชาย',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BarRider());
  }
}

Widget header(BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
      color: Color(0xFF1ABBE0),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20), // Bottom-left corner radius
        bottomRight: Radius.circular(20), // Bottom-right corner radius
      ),
    ),
    width: MediaQuery.of(context).size.width,
    height: 150,
    padding: const EdgeInsets.only(left: 50, bottom: 30),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4), // Space for the white frame
          decoration: const BoxDecoration(
            color: Colors.white, // White frame color
            shape: BoxShape.circle,
          ),
          child: const CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage(
              'assets/image/ruj.jpg', // Replace with your image asset
            ),
          ),
        ),
        const SizedBox(width: 9),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'สวัสดี',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8, bottom: 3),
              child: Text(
                'PuraChuay', // Replace with your user name
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class DeliveryItemWidget extends StatelessWidget {
  final String title;
  final String location;

  DeliveryItemWidget({required this.title, required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.local_shipping, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    width:
                        1, // This controls the thickness of the vertical line
                    height: 40, // This controls the height of the line
                    color: Colors.grey, // Line color
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(location, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 56, 104, 248),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                minimumSize: const Size(100, 50),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(16), // Border radius of 10
                ),
              ),
              child: const Text(
                'รับงาน',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
