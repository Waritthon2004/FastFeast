import 'package:cloud_firestore/cloud_firestore.dart'; // ใช้สำหรับ GeoPoint

class User {
  String address;
  GeoPoint location;
  String name;
  String password;
  String phone;
  int type;
  String url;

  User({
    required this.address,
    required this.location,
    required this.name,
    required this.password,
    required this.phone,
    required this.type,
    required this.url,
  });

  // ฟังก์ชันสำหรับแปลงจาก Firestore Document เป็น Model
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      address: json['address'],
      location: json['location'], // Firestore เก็บเป็น GeoPoint โดยตรง
      name: json['name'],
      password: json['password'],
      phone: json['phone'],
      type: json['type'],
      url: json['url'],
    );
  }

  // ฟังก์ชันสำหรับแปลงจาก Model เป็น JSON (เพื่อนำไปใช้บันทึกใน Firestore)
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'location': location, // Firestore รองรับ GeoPoint
      'name': name,
      'password': password,
      'phone': phone,
      'type': type,
      'url': url,
    };
  }
}
