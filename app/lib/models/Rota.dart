// To parse this JSON data, do
//
//     final rota = rotaFromJson(jsonString);

import 'dart:convert';

List<Rota> rotaFromJson(String str) =>
    List<Rota>.from(json.decode(str).map((x) => Rota.fromJson(x)));

String rotaToJson(List<Rota> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Rota {
  Rota({
    required this.rotaId,
    required this.rotaNome,
    required this.rotaDisc,
    required this.rotaCap,
  });

  int rotaId;
  String rotaNome;
  String rotaDisc;
  int rotaCap;

  factory Rota.fromJson(Map<String, dynamic> json) => Rota(
        rotaId: json["rota_id"],
        rotaNome: json["rota_nome"],
        rotaDisc: json["rota_disc"],
        rotaCap: json["rota_cap"],
      );

  Map<String, dynamic> toJson() => {
        "rota_id": rotaId,
        "rota_nome": rotaNome,
        "rota_disc": rotaDisc,
        "rota_cap": rotaCap,
      };
}
