// To parse this JSON data, do
//
//     final allproduct = allproductFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

List<Allproduct> allproductFromJson(String str) =>
    List<Allproduct>.from(json.decode(str).map((x) => Allproduct.fromJson(x)));

String allproductToJson(List<Allproduct> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Allproduct {
  GeoPoint riderLocation;
  String description;
  String destination;
  String image;
  String origin;
  String receiver;
  GeoPoint receiverlocation;
  String rider;
  String sender;
  GeoPoint senderlocation;
  int status;

  Allproduct({
    required this.riderLocation,
    required this.description,
    required this.destination,
    required this.image,
    required this.origin,
    required this.receiver,
    required this.receiverlocation,
    required this.rider,
    required this.sender,
    required this.senderlocation,
    required this.status,
  });

  factory Allproduct.fromJson(Map<String, dynamic> json) => Allproduct(
        riderLocation: json["RiderLocation"] is GeoPoint
            ? json["RiderLocation"]
            : GeoPoint(json["RiderLocation"]["latitude"],
                json["RiderLocation"]["longitude"]),
        description: json["description"],
        destination: json["destination"],
        image: json["image"],
        origin: json["origin"],
        receiver: json["receiver"],
        receiverlocation: json["receiverlocation"] is GeoPoint
            ? json["receiverlocation"]
            : GeoPoint(json["receiverlocation"]["latitude"],
                json["receiverlocation"]["longitude"]),
        rider: json["rider"],
        sender: json["sender"],
        senderlocation: json["senderlocation"] is GeoPoint
            ? json["senderlocation"]
            : GeoPoint(json["senderlocation"]["latitude"],
                json["senderlocation"]["longitude"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "RiderLocation": {
          "latitude": riderLocation.latitude,
          "longitude": riderLocation.longitude,
        },
        "description": description,
        "destination": destination,
        "image": image,
        "origin": origin,
        "receiver": receiver,
        "receiverlocation": {
          "latitude": receiverlocation.latitude,
          "longitude": receiverlocation.longitude,
        },
        "rider": rider,
        "sender": sender,
        "senderlocation": {
          "latitude": senderlocation.latitude,
          "longitude": senderlocation.longitude,
        },
        "status": status,
      };
}
