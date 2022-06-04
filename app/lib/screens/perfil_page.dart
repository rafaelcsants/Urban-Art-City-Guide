import 'package:app/models/Pessoa.dart';
import 'package:app/screens/historico_page.dart';
import 'package:app/services/remote_service.dart';
import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  //API
  List<Pessoa>? pessoas;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();

    // fetch data from API
    getData();
  }

  getData() async {
    pessoas = await RemoteService().getPessoas();
    if (pessoas != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  //APP
  @override
  Widget build(BuildContext context) {
    var i = 0;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        title: Text(
          'Perfil',
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(
            context,
          ).unfocus(),
          child: Align(
            alignment: AlignmentDirectional(0, -0.5),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFEEEEEE),
                  border: Border.all(
                    color: Colors.black,
                    width: 1.5,
                  )),
              alignment: AlignmentDirectional(-0.0, 0),
              child: Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional(0, -0.15),
                    child: Text(
                      pessoas![i].pessoaNome,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0, -0.65),
                    child: Text(
                      pessoas![i].pessoaEmail,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0, 0.8),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.green, // foreground
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HistoricoPage(pessoa: pessoas![i])));
                      },
                      child:
                          Text('Ver Histórico', style: TextStyle(fontSize: 25)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
