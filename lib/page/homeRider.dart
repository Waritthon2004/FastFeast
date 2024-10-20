import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_feast/page/barRider.dart';
import 'package:fast_feast/page/drawer.dart';
import 'package:fast_feast/page/riderStatus.dart';
import 'package:fast_feast/shared/appData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Homerider extends StatefulWidget {
  const Homerider({Key? key}) : super(key: key);

  @override
  State<Homerider> createState() => _HomeriderState();
}

class _HomeriderState extends State<Homerider> {
  late UserInfo user;
  late Future<QuerySnapshot> loadData;

  @override
  void initState() {
    super.initState();
    user = context.read<AppData>().user;
    loadData = loadDataAsync();
  }

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
                  image: AssetImage('assets/image/default_profile.png'),
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
            _buildHeader(),
            _buildDeliveryList(),
          ],
        ),
      ),
      bottomNavigationBar: const BarRider(),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1ABBE0),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      height: 150,
      padding: const EdgeInsets.only(left: 50, bottom: 30),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/image/ruj.jpg'),
            ),
          ),
          const SizedBox(width: 9),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'สวัสดี',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 3),
                child: Text(
                  user.name ?? 'User',
                  style: const TextStyle(
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

  Widget _buildDeliveryList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            "รายการสินค้าที่ต้องส่ง",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 51, 48, 70),
            ),
          ),
          const Divider(indent: 40, endIndent: 40),
          FutureBuilder<QuerySnapshot>(
            future: loadData,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text("No deliveries available");
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs[index];
                  return DeliveryItemWidget(
                    origin: doc['origin'],
                    location: doc['destination'],
                    doc: doc.id,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

 Future<QuerySnapshot> loadDataAsync() async {
  try {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('send');
    QuerySnapshot querySnapshot = await collectionRef.get();
    
    log("Number of documents: ${querySnapshot.docs.length}");
    
    for (var doc in querySnapshot.docs) {
      log("Document ID: ${doc.id}");
      log("Document data: ${doc.data()}");
      
      // If you want to see specific fields:
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    }
    
    return querySnapshot;
  } catch (err) {
    log("Error in loadDataAsync: $err");
    rethrow;
  }
}
}

class DeliveryItemWidget extends StatelessWidget {
  final String origin;
  final String location;
  final String doc;  
  DeliveryItemWidget({required this.origin, required this.location, required this.doc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
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
                        origin,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                      Text(location, style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: ()async {
                  var db = FirebaseFirestore.instance;
                  var data = {
                  'status': 1,
                };
      log(data.toString());

      await db.collection('user').doc().set(data);
                  Get.to(Riderstatus());

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 56, 104, 248),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  minimumSize: const Size(100, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16), // Border radius of 10
                  ),
                ),
                child: const Text(
                  'รับงาน',
                  style:
                      TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}