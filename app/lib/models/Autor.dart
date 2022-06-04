// To parse this JSON data, do
//
//     final autor = autorFromJson(jsonString);

import 'dart:convert';

List<Autor> autorFromJson(String str) =>
    List<Autor>.from(json.decode(str).map((x) => Autor.fromJson(x)));

String autorToJson(List<Autor> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Autor {
  Autor({
    required this.autorId,
    required this.autorNome,
  });

  int autorId;
  String autorNome;

  factory Autor.fromJson(Map<String, dynamic> json) => Autor(
        autorId: json["autor_id"],
        autorNome: json["autor_nome"],
      );

  Map<String, dynamic> toJson() => {
        "autor_id": autorId,
        "autor_nome": autorNome,
      };
}
