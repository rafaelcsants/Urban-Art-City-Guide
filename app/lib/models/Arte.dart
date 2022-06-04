// To parse this JSON data, do
//
//     final arte = arteFromJson(jsonString);

import 'dart:convert';

List<Arte> arteFromJson(String str) =>
    List<Arte>.from(json.decode(str).map((x) => Arte.fromJson(x)));

String arteToJson(List<Arte> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Arte {
  Arte({
    required this.artesId,
    required this.artesNome,
    required this.artesDisc,
    required this.artesAutorId,
    required this.latitude,
    required this.longitude,
    required this.imagem,
  });

  int artesId;
  String artesNome;
  String artesDisc;
  int artesAutorId;
  double latitude;
  double longitude;
  int imagem;

  factory Arte.fromJson(Map<String, dynamic> json) => Arte(
        artesId: json["artes_id"],
        artesNome: json["artes_nome"],
        artesDisc: json["artes_disc"],
        artesAutorId: json["artes_autor_id"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        imagem: json["imagem"],
      );

  Map<String, dynamic> toJson() => {
        "artes_id": artesId,
        "artes_nome": artesNome,
        "artes_disc": artesDisc,
        "artes_autor_id": artesAutorId,
        "latitude": latitude,
        "longitude": longitude,
        "imagem": imagem,
      };
}
