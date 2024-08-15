// To parse this JSON data, do
//
//     final tripsGetResponse = tripsGetResponseFromJson(jsonString);

import 'dart:convert';

List<TripsGetResponses> tripsGetResponseFromJson(String str) =>
    List<TripsGetResponses>.from(
        json.decode(str).map((x) => TripsGetResponses.fromJson(x)));

String tripsGetResponseToJson(List<TripsGetResponses> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TripsGetResponses {
  int idx;
  String name;
  String country;
  String coverimage;
  String detail;
  int price;
  int duration;
  String destinationZone;

  TripsGetResponses({
    required this.idx,
    required this.name,
    required this.country,
    required this.coverimage,
    required this.detail,
    required this.price,
    required this.duration,
    required this.destinationZone,
  });

  factory TripsGetResponses.fromJson(Map<String, dynamic> json) =>
      TripsGetResponses(
        idx: json["idx"],
        name: json["name"],
        country: json["country"],
        coverimage: json["coverimage"],
        detail: json["detail"],
        price: json["price"],
        duration: json["duration"],
        destinationZone: json["destination_zone"],
      );

  Map<String, dynamic> toJson() => {
        "idx": idx,
        "name": name,
        "country": country,
        "coverimage": coverimage,
        "detail": detail,
        "price": price,
        "duration": duration,
        "destination_zone": destinationZone,
      };
}
