import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:p9ids2/Pages/Auto.dart';

import 'package:p9ids2/Utils/Ambiente.dart';
import '../Model/AutosResponse.dart';
import 'package:http/http.dart' as http;
import 'Auto.dart';

class Autoslista extends StatefulWidget {
  const Autoslista({super.key});

  @override
  State<Autoslista> createState() => _AutosListaState();
}

class _AutosListaState extends State<Autoslista> {
  List<AutosResponse> autos = [];

  Widget _listViewAutos() {
    return ListView.builder(
        itemCount: autos.length,
        itemBuilder: (context, index) {
          var auto = autos[index];

          return ListTile(
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) => Auto(idAuto: auto.id,)),
              );
            },
            title: Text(auto.matricula),
            subtitle: Text(auto.marca),
          );
        }

    );
  }

  void fnObtenerAutos() async {
    var response = await http.get(
      Uri.parse('${Ambiente.urlServer}/api/autos'),
      headers: <String, String>{
        'Content-Type': 'aplication/json; charset=UTF-8'
      },
    );
    print(response.body);
    Iterable mapAutos = jsonDecode(response.body);
    autos = List<AutosResponse>.from(mapAutos.map((model) =>
        AutosResponse.fromJson(model)));
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnObtenerAutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Autos"),
        actions: <Widget>[
          PopupMenuButton <String>(onSelected: (String value) {
            fnObtenerAutos();
          },
              itemBuilder: (BuildContext context) {
                return {'Actualizar lista'}.map((String item) {
                  return PopupMenuItem<String>(value: item, child: Text(item)
                  );
                }).toList();
              }
          ),
        ],
      ),
      body: _listViewAutos(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => const Auto(idAuto: 0,)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}