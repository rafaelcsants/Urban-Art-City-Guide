import 'package:app/models/Arte.dart';
import 'package:flutter/material.dart';
import 'package:app/models/Autor.dart';
import 'package:app/services/remote_service.dart';
import 'dart:async';

class InfoArtes extends StatefulWidget {
  // In the constructor, require a Todo.
  const InfoArtes({Key? key, required this.arte}) : super(key: key);

  final Arte arte;

  @override
  _InfoArtesState createState() => _InfoArtesState(arte);
}

class _InfoArtesState extends State<InfoArtes> {
  Arte arte;
  _InfoArtesState(this.arte); //constructor

  var isLoaded = false;

  @override
  void initState() {
    super.initState();

    // fetch data from API
    getData1();
  }

  List<Autor>? autores;

  getData1() async {
    autores = await RemoteService().getAutores();
    if (autores != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(title: Text(arte.artesNome)),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional(0.00, -1),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  child: Image.network(
                    'http://gau.cm-lisboa.pt/fileadmin/templates/gau/app_v2/img.php?ficheiro_id=${arte.imagem}',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Stack(
                alignment: AlignmentDirectional(0.050000000000000044, 0),
                children: [
                  Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Text(
                        "Autor:" + autores![arte.artesAutorId - 1].autorNome,
                        style: TextStyle(fontSize: 25)),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0, -0.2),
                    child: Text(arte.artesDisc, style: TextStyle(fontSize: 25)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
