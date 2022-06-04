import 'package:app/models/Pessoa.dart';
import 'package:app/models/Historico.dart';
import 'package:app/services/remote_service.dart';
import 'package:flutter/material.dart';

class HistoricoPage extends StatefulWidget {
  // In the constructor, require a Todo.
  const HistoricoPage({Key? key, required this.pessoa}) : super(key: key);

  // Declare a field that holds the Todo.
  final Pessoa pessoa;

  @override
  _HistoricoPageState createState() => _HistoricoPageState(pessoa);
}

class _HistoricoPageState extends State<HistoricoPage> {
  //API
  Pessoa pessoa;
  _HistoricoPageState(this.pessoa);

  List<Historico>? historico;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();

    // fetch data from API
    getData(pessoa.pessoaId);
  }

  getData(pessoaId) async {
    historico = await RemoteService().getHistorico(pessoaId);
    if (historico != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  //APP
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Historico Page"),
      ),
      body: Visibility(
        visible: isLoaded,
        child: ListView.builder(
            itemCount: historico?.length,
            itemBuilder: ((context, index) {
              return ListTile(
                title: Text(
                  historico![index].rotaNome,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              );
            })),
        replacement: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
