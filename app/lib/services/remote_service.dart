import 'dart:convert';
import 'package:app/models/Arte.dart';
import 'package:app/models/ArtebyRota.dart';
import 'package:app/models/Autor.dart';
import 'package:app/models/Historico.dart';
import 'package:app/models/Inscricao.dart';
import 'package:app/models/Pessoa.dart';
import 'package:app/models/Rota.dart';
import 'package:http/http.dart' as http;

class RemoteService {
  /////////// PESSOAS
  Future<List<Pessoa>?> getPessoas() async {
    var client = http.Client();

    var uri = Uri.parse('https://urbanartcityguide.herokuapp.com/api/pessoas');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return pessoaFromJson(json);
    }
  }

  /////////// INSCRICAO
  Future<List<Inscricao>?> submitInscricao(
      int rotaId, int inscricaoPessoaId) async {
    var client = http.Client();

    Map data = {
      'rotaId': rotaId.toString(),
      'pessoaId': inscricaoPessoaId.toString()
    };
    print(data);

    var uri = Uri.parse(
        'https://urbanartcityguide.herokuapp.com/api/pessoas/inscricao');
    final response = await client.post(uri,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));
    if (response.statusCode == 200) {
      var json = response.body;
      return inscricaoFromJson(json);
    }
    return null;
  }

  /////////// Autores
  Future<List<Autor>?> getAutores() async {
    var client = http.Client();

    var uri = Uri.parse(
        'https://urbanartcityguide.herokuapp.com/api/pessoas/autores');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return autorFromJson(json);
    }
  }

  /////////// ROTAS
  Future<List<Rota>?> getRotas() async {
    var client = http.Client();

    var uri = Uri.parse('https://urbanartcityguide.herokuapp.com/api/rota');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return rotaFromJson(json);
    }
  }

  /////////// LOGIN
  Future<List<Pessoa>?> Login(String email, String pass) async {
    var client = http.Client();

    Map data = {'email': email, 'password': pass};

    var uri =
        Uri.parse('https://urbanartcityguide.herokuapp.com/api/pessoas/login');
    final response = await client.post(uri,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      var json = response.body;
      return pessoaFromJson(json);
    }
  }

  /////////// ARTES
  Future<List<Arte>> getArtes() async {
    var client = http.Client();

    var uri = Uri.parse('https://urbanartcityguide.herokuapp.com/api/artes');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return arteFromJson(json);
    } else
      return ([]);
  }

  /////////// ARTES BY ROTA?ID
  Future<List<ArteByRota>> getArtesRota(int rotaId) async {
    var client = http.Client();

    var uri = Uri.parse(
        'https://urbanartcityguide.herokuapp.com/api/artes/byRota/${rotaId}');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return artebyrotaFromJson(json);
    }
    return ([]);
  }

  /////////// Historico
  Future<List<Historico>?> getHistorico(int pessoaId) async {
    var client = http.Client();

    var uri = Uri.parse(
        'https://urbanartcityguide.herokuapp.com/api/pessoas/historico/${pessoaId}');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return historicoFromJson(json);
    }
  }

  /////////// LOGIN
  Future<Pessoa?> login(String email, String pass) async {
    final response = await http.post(
        Uri.parse('https://urbanartcityguide.herokuapp.com/api/pessoas/login'),
        body: {
          'email': email,
          'pass': pass,
        });
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return new Pessoa.fromJson(json);
    }
  }
}
