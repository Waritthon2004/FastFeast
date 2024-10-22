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
  GeoPoint? riderLocation;
  String? description;
  String? destination;
  String? image;
  String? origin;
  String? receiver;
  GeoPoint? receiverlocation;
  String? rider;
  String? sender;
  GeoPoint? senderlocation;
  int? status;

  Allproduct({
    this.riderLocation,
    this.description,
    this.destination,
    this.image,
    this.origin,
    this.receiver,
    this.receiverlocation,
    this.rider,
    this.sender,
    this.senderlocation,
    this.status,
  });

  factory Allproduct.fromJson(Map<String, dynamic> json) => Allproduct(
        riderLocation: json["RiderLocation"] is GeoPoint
            ? json["RiderLocation"]
            : (json["RiderLocation"] != null
                ? GeoPoint(json["RiderLocation"]["latitude"],
                    json["RiderLocation"]["longitude"])
                : null),
        description: json["description"],
        destination: json["destination"],
        image: json["image"],
        origin: json["origin"],
        receiver: json["receiver"],
        receiverlocation: json["receiverlocation"] is GeoPoint
            ? json["receiverlocation"]
            : (json["receiverlocation"] != null
                ? GeoPoint(json["receiverlocation"]["latitude"],
                    json["receiverlocation"]["longitude"])
                : null),
        rider: json["rider"],
        sender: json["sender"],
        senderlocation: json["senderlocation"] is GeoPoint
            ? json["senderlocation"]
            : (json["senderlocation"] != null
                ? GeoPoint(json["senderlocation"]["latitude"],
                    json["senderlocation"]["longitude"])
                : null),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "RiderLocation": riderLocation != null
            ? {
                "latitude": riderLocation!.latitude,
                "longitude": riderLocation!.longitude,
              }
            : null,
        "description": description,
        "destination": destination,
        "image": image,
        "origin": origin,
        "receiver": receiver,
        "receiverlocation": receiverlocation != null
            ? {
                "latitude": receiverlocation!.latitude,
                "longitude": receiverlocation!.longitude,
              }
            : null,
        "rider": rider,
        "sender": sender,
        "senderlocation": senderlocation != null
            ? {
                "latitude": senderlocation!.latitude,
                "longitude": senderlocation!.longitude,
              }
            : null,
        "status": status,
      };
}
