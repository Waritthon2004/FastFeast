// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  String description;
  String image;
  String receiver;

  Product({
    required this.description,
    required this.image,
    required this.receiver,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        description: json["description"],
        image: json["image"],
        receiver: json["receiver"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "image": image,
        "receiver": receiver,
      };
}
