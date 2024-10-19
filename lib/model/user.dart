// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  String address;
  String location;
  String name;
  String password;
  String phone;

  User({
    required this.address,
    required this.location,
    required this.name,
    required this.password,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        address: json["address"],
        location: json["location"],
        name: json["name"],
        password: json["password"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "location": location,
        "name": name,
        "password": password,
        "phone": phone,
      };
}
