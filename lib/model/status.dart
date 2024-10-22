import 'package:cloud_firestore/cloud_firestore.dart';

class Status {
  GeoPoint? riderLocation;
  String? description;
  String? destination;
  String? image;
  String? origin;
  String? receiver;
  GeoPoint? receiverLocation;
  String? sender;
  GeoPoint? senderLocation;
  String? rider;
  String? statusImage;
  int? status;

  Status({
    this.rider,
    this.statusImage,
    this.riderLocation,
    this.description,
    this.destination,
    this.image,
    this.origin,
    this.receiver,
    this.receiverLocation,
    this.sender,
    this.senderLocation,
    this.status,
  });

  // Function to convert Firestore Document to Model
  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      rider: json['rider'],
      riderLocation: json['RiderLocation'] != null
          ? json['RiderLocation'] as GeoPoint
          : null,
      description: json['description'],
      destination: json['destination'],
      image: json['image'],
      origin: json['origin'],
      statusImage: json['Statusimage'],
      receiver: json['receiver'],
      receiverLocation: json['receiverlocation'] != null
          ? json['receiverlocation'] as GeoPoint
          : null,
      sender: json['sender'],
      senderLocation: json['senderlocation'] != null
          ? json['senderlocation'] as GeoPoint
          : null,
      status: json['status'],
    );
  }

  // Function to convert Model to JSON (for saving to Firestore)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (rider != null) data['rider'] = rider;
    if (riderLocation != null) data['RiderLocation'] = riderLocation;
    if (description != null) data['description'] = description;
    if (destination != null) data['destination'] = destination;
    if (image != null) data['image'] = image;
    if (origin != null) data['origin'] = origin;
    if (receiver != null) data['receiver'] = receiver;
    if (receiverLocation != null) data['receiverlocation'] = receiverLocation;
    if (sender != null) data['sender'] = sender;
    if (senderLocation != null) data['senderlocation'] = senderLocation;
    if (statusImage != null) data['Statusimage'] = statusImage;
    if (status != null) data['status'] = status;
    return data;
  }
}
