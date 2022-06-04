// To parse this JSON data, do
//
//     final arte = arteFromJson(jsonString);

import 'dart:convert';

List<ArteByRota> artebyrotaFromJson(String str) =>
    List<ArteByRota>.from(json.decode(str).map((x) => ArteByRota.fromJson(x)));

String artebyrotaToJson(List<ArteByRota> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ArteByRota {
  ArteByRota({
    required this.artesId,
    // required this.rotaId,
  });

  int artesId;
  // int rotaId;

  factory ArteByRota.fromJson(Map<String, dynamic> json) => ArteByRota(
        artesId: json["artes_id"],
        // rotaId: json["rota_id"],
      );

  Map<String, dynamic> toJson() => {
        "artes_id": artesId,
        // "rota_id": rotaId,
      };
}
