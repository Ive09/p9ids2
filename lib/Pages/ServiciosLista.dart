import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:p9ids2/Utils/Ambiente.dart';
import '../Model/ServiciosResponse.dart';
import 'package:http/http.dart' as http;
import 'Servicio.dart';

class Servicioslista extends StatefulWidget {
  const Servicioslista({super.key});

  @override
  State<Servicioslista> createState() => _ServiciosListaState();
}

class _ServiciosListaState extends State<Servicioslista> {
  List<ServiciosResponse> servicios = [];

  Widget _listViewServicios() {
    return ListView.builder(
        itemCount: servicios.length,
        itemBuilder: (context, index) {
          var servicio = servicios[index];

          return ListTile(
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) => Servicio(idServicio: servicio.id,)),
              );
            },
            title: Text(servicio.codigo),
            subtitle: Text(servicio.descripcion),
          );
        }

    );
  }

  void fnObtenerServicios() async {
    var response = await http.get(
      Uri.parse('${Ambiente.urlServer}/api/servicios'),
      headers: <String, String>{
        'Content-Type': 'aplication/json; charset=UTF-8'
      },
    );
    print(response.body);
    Iterable mapServicios = jsonDecode(response.body);
    servicios = List<ServiciosResponse>.from(mapServicios.map((model) =>
        ServiciosResponse.fromJson(model)));
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnObtenerServicios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Servicios"),
        actions: <Widget>[
          PopupMenuButton <String>(onSelected: (String value) {
            fnObtenerServicios();
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
      body: _listViewServicios(),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => const Servicio(idServicio: 0,)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}