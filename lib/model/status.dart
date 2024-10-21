import 'package:cloud_firestore/cloud_firestore.dart';

class Status {
  GeoPoint? RiderLocation;
  String? description;
  String? destination;
  String? image;
  String? origin;
  String? receiver;
  GeoPoint? receiverlocation;
  String? sender;
  GeoPoint? senderlocation;
  String? rider;
  int? status;

  Status({
    this.rider,
    this.RiderLocation,
    this.description,
    this.destination,
    this.image,
    this.origin,
    this.receiver,
    this.receiverlocation,
    this.sender,
    this.senderlocation,
    this.status,
  });

  // ฟังก์ชันสำหรับแปลงจาก Firestore Document เป็น Model
  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      rider: json['rider'],
      RiderLocation: json['RiderLocation'],
      description: json['description'],
      destination: json['destination'],
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
    final Map<String, dynamic> data = <String, dynamic>{};
    if (rider != null) data['rider'] = rider;
    if (RiderLocation != null) data['RiderLocation'] = RiderLocation;
    if (description != null) data['description'] = description;
    if (destination != null) data['destination'] = destination;
    if (image != null) data['image'] = image;
    if (origin != null) data['origin'] = origin;
    if (receiver != null) data['receiver'] = receiver;
    if (receiverlocation != null) data['receiverlocation'] = receiverlocation;
    if (sender != null) data['sender'] = sender;
    if (senderlocation != null) data['senderlocation'] = senderlocation;
    if (status != null) data['status'] = status;
    return data;
  }
}
