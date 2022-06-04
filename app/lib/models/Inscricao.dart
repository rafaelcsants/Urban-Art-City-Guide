import 'dart:convert';

List<Inscricao> inscricaoFromJson(String str) =>
    List<Inscricao>.from(json.decode(str).map((x) => Inscricao.fromJson(x)));

String inscricaoToJson(List<Inscricao> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Inscricao {
  Inscricao({
    required this.inscricaoId,
    required this.inscricaoAssignId,
    required this.inscricaoPessoaId,
  });

  int inscricaoId;
  int inscricaoAssignId;
  int inscricaoPessoaId;

  factory Inscricao.fromJson(Map<String, dynamic> json) => Inscricao(
        inscricaoId: json["inscricao_id"],
        inscricaoAssignId: json["inscricao_assign_id"],
        inscricaoPessoaId: json["inscricao_pessoa_id"],
      );

  Map<String, dynamic> toJson() => {
        "inscricao_id": inscricaoId,
        "inscricao_assign_id": inscricaoAssignId,
        "inscricao_pessoa_id": inscricaoPessoaId,
      };
}
