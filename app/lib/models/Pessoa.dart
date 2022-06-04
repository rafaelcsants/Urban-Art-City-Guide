import 'dart:convert';

List<Pessoa> pessoaFromJson(String str) =>
    List<Pessoa>.from(json.decode(str).map((x) => Pessoa.fromJson(x)));

String pessoaToJson(List<Pessoa> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Pessoa {
  Pessoa({
    required this.pessoaId,
    required this.pessoaNome,
    required this.pessoaEmail,
    required this.pessoaPass,
  });

  int pessoaId;
  String pessoaNome;
  String pessoaEmail;
  String pessoaPass;

  factory Pessoa.fromJson(Map<String, dynamic> json) => Pessoa(
        pessoaId: json["pessoa_id"],
        pessoaNome: json["pessoa_nome"],
        pessoaEmail: json["pessoa_email"],
        pessoaPass: json["pessoa_pass"],
      );

  Map<String, dynamic> toJson() => {
        "pessoa_id": pessoaId,
        "pessoa_nome": pessoaNome,
        "pessoa_email": pessoaEmail,
        "pessoa_pass": pessoaPass,
      };
}
