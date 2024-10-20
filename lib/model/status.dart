import 'package:cloud_firestore/cloud_firestore.dart'; // ใช้สำหรับ GeoPoint

class Status {
  String description;
  String destination;
  String image;
  String origin;
  String receiver;
  GeoPoint receiverlocation;
  String sender;
  GeoPoint senderlocation;
  int status;

  Status({
    required this.description,
    required this.destination,
    required this.image,
    required this.origin,
    required this.receiver,
    required this.receiverlocation,
    required this.sender,
    required this.senderlocation,
    required this.status,
  });

  // ฟังก์ชันสำหรับแปลงจาก Firestore Document เป็น Model
  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      description: json['description'],
      destination: json['destination'], // Firestore เก็บเป็น GeoPoint โดยตรง
      image: json['image'],
      origin: json['origin'],
      receiver: json['receiver'],
      receiverlocation: json['receiverlocation'],
      sender: json['sender'],
      senderlocation: json['senderlocation'],
      status: json['status'],
    );
  }

  // ฟังก์ชันสำหรับแปลงจาก Model เป็น JSON (เพื่อนำไปใช้บันทึกใน Firestore)
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'destination': destination, // Firestore รองรับ GeoPoint
      'image': image,
      'origin': origin,
      'receiver': receiver,
      'receiverlocation': receiverlocation,
      'sender': sender,
      'senderlocation': senderlocation,
      'status': status,
    };
  }
}
