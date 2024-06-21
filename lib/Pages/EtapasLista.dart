import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:p9ids2/Model/EtapasResponse.dart';
import 'package:p9ids2/Pages/Etapa.dart';

import 'package:p9ids2/Utils/Ambiente.dart';
import '../Model/ServiciosResponse.dart';
import 'package:http/http.dart' as http;
import 'Servicio.dart';

class Etapaslista extends StatefulWidget {
  final int idServicio;
  const Etapaslista({super.key, required this.idServicio});

  @override
  State<Etapaslista> createState() => _EtapasListaState();
}

class _EtapasListaState extends State<Etapaslista> {
  List<EtapasResponse> etapas = [];

  Widget _listViewEtapas() {
    return ListView.builder(
        itemCount: etapas.length,
        itemBuilder: (context, index) {
          var etapa = etapas[index];

          return ListTile(
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) => Etapa(idEtapa: etapa.id, idServicio: widget.idServicio,)),
              );
            },
            title: Text(etapa.nombre),
            subtitle: Text(etapa.duracion),
          );
        }

    );
  }

  void fnObtenerEtapas() async {
    var response = await http.post(
      Uri.parse('${Ambiente.urlServer}/api/etapas'),
      headers: <String, String>{
        'Content-Type': 'aplication/json; charset=UTF-8'
      },
      body: jsonEncode(<String, dynamic>{
      'idservicio' : widget.idServicio,
    }),
    );
    print(response.body);
    Iterable mapServicios = jsonDecode(response.body);
    etapas = List<EtapasResponse>.from(mapServicios.map((model) =>
        EtapasResponse.fromJson(model)));
    setState(() {
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnObtenerEtapas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Etapas"),
        actions: <Widget>[
          PopupMenuButton <String>(onSelected: (String value) {
            fnObtenerEtapas();
          },
              itemBuilder: (BuildContext context) {
                return {'Actualizar lista'}.map((String item) {
                  return PopupMenuItem<String>(value: item, child: Text(item)
                  );
                }).toList();
              },
          ),
        ],
      ),
      body: _listViewEtapas(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
            MaterialPageRoute(
                builder: (context) =>  Etapa(idEtapa: 0,idServicio: widget.idServicio,)),
          );
        },
        child: const Icon(Icons.add),
      ),


    );
  }
}