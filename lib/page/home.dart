import 'package:fast_feast/page/bar.dart';
import 'package:fast_feast/page/drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://scontent-bkk1-2.xx.fbcdn.net/v/t39.30808-6/418475547_3527827574134521_421755393680319339_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeEdVbCSMT19XcCJXhl5nM39mQjXit1mkmGZCNeK3WaSYSp5wgXWCPNiHHAh6XVgQnTipxlh1_zNMxK-9zURA1v6&_nc_ohc=J9ZaSFck58oQ7kNvgGn0dVw&_nc_ht=scontent-bkk1-2.xx&_nc_gid=AL4xba1YgAtt9fnC3FLjEND&oh=00_AYDX2uobSD2wOqFC8pWgrhdLz-oJk2xp3FkeCYrrHFq8gA&oe=67158B07",
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
        bottomNavigationBar: const Bar());
  }
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

Widget body() {
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Column(
      children: [
        Container(
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
        Container(
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
        )
      ],
    ),
  );
}
