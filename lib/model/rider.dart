import 'dart:convert';

Rider riderFromJson(String str) => Rider.fromJson(json.decode(str));

String riderToJson(Rider data) => json.encode(data.toJson());

class Rider {
  String images;
  String license;
  String name;
  String password;
  String phone;

  Rider({
    required this.images,
    required this.license,
    required this.name,
    required this.password,
    required this.phone,
  });

  factory Rider.fromJson(Map<String, dynamic> json) => Rider(
        images: json["images"],
        license: json["license"],
        name: json["name"],
        password: json["password"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "images": images,
        "license": license,
        "name": name,
        "password": password,
        "phone": phone,
      };
}
