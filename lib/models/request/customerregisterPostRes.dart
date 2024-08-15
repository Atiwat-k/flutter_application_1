// To parse this JSON data, do
//
//     final customerregisterPostRes = customerregisterPostResFromJson(jsonString);

import 'dart:convert';

CustomerregisterPostRes customerregisterPostResFromJson(String str) =>
    CustomerregisterPostRes.fromJson(json.decode(str));

String customerregisterPostResToJson(CustomerregisterPostRes data) =>
    json.encode(data.toJson());

class CustomerregisterPostRes {
  String fullname;
  String phone;
  String email;
  String image;
  String password;

  CustomerregisterPostRes({
    required this.fullname,
    required this.phone,
    required this.email,
    required this.image,
    required this.password,
  });

  factory CustomerregisterPostRes.fromJson(Map<String, dynamic> json) =>
      CustomerregisterPostRes(
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
        "password": password,
      };
}
