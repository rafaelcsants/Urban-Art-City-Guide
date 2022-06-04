// To parse this JSON data, do
//
//     final historico = historicoFromJson(jsonString);

import 'dart:convert';

List<Historico> historicoFromJson(String str) =>
    List<Historico>.from(json.decode(str).map((x) => Historico.fromJson(x)));

String historicoToJson(List<Historico> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Historico {
  Historico({
    required this.inscricaoPessoaId,
    required this.rotaNome,
  });

  int inscricaoPessoaId;
  String rotaNome;

  factory Historico.fromJson(Map<String, dynamic> json) => Historico(
        inscricaoPessoaId: json["inscricao_pessoa_id"],
        rotaNome: json["rota_nome"],
      );

  Map<String, dynamic> toJson() => {
        "inscricao_pessoa_id": inscricaoPessoaId,
        "rota_nome": rotaNome,
      };
}
