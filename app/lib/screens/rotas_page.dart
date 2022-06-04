import 'package:app/screens/inforotas_page.dart';
import 'package:app/services/remote_service.dart';
import 'package:flutter/material.dart';
import 'package:app/models/Rota.dart';
import 'package:app/main.dart';

class RotasPage extends StatefulWidget {
  @override
  _RotasPageState createState() => _RotasPageState();
}

class _RotasPageState extends State<RotasPage> {
  //API
  List<Rota>? rotas;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();

    // fetch data from API
    getData();
  }

  getData() async {
    rotas = await RemoteService().getRotas();
    if (rotas != null) {
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
        title: Text("Rotas Page"),
      ),
      body: Visibility(
        visible: isLoaded,
        child: ListView.builder(
            itemCount: rotas?.length,
            itemBuilder: ((context, index) {
              return ListTile(
                  // margin: EdgeInsets.all(10),
                  // padding: EdgeInsets.all(10),
                  // alignment: Alignment.center,
                  // decoration: BoxDecoration(
                  //     color: Colors.green,
                  //     border: Border.all(
                  //         color:
                  //             Color.fromARGB(255, 2, 31, 3), // Set border color
                  //         width: 3.0),
                  //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //     boxShadow: [
                  //       BoxShadow(
                  //           blurRadius: 10,
                  //           color: Colors.black,
                  //           offset: Offset(1, 3))
                  //     ] // Make rounded corner of border
                  //     ),
                  title: Text(
                    rotas![index].rotaNome,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                InfoRota(rota: rotas![index])));
                  });
            })),
        replacement: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
