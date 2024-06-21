import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:p9ids2/Model/EtapasResponse.dart';
import 'package:p9ids2/Utils/Ambiente.dart';
import 'package:quickalert/quickalert.dart';

class Etapa extends StatefulWidget {
  final int idServicio;
  final int idEtapa;
  const Etapa({Key? key, required this.idEtapa, required this.idServicio}) : super(key: key);


  @override
  State<Etapa> createState() => _EtapaState();
}

class _EtapaState extends State<Etapa> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController txtNombre = TextEditingController();
  final TextEditingController txtDuracion = TextEditingController();
  final TextEditingController txtIdServicio = TextEditingController();

  void fnDatosEtapa() async {
    final response = await http.post(
      Uri.parse('${Ambiente.urlServer}/api/etapa'),
      body: jsonEncode(<String, dynamic>{
        'id': widget.idEtapa,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
    );
    Map<String, dynamic> responseJson = jsonDecode(response.body);
    final etapaResponse = EtapasResponse.fromJson(responseJson);
    txtNombre.text = etapaResponse.nombre;
    txtDuracion.text = etapaResponse.duracion;
    txtIdServicio.text = etapaResponse.id_servicio.toString();
  }

  @override
  void initState() {
    super.initState();
    if (widget.idEtapa != 0) {
      fnDatosEtapa();
    }

    txtIdServicio.text=widget.idServicio.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Formulario de etapas"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(

            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor llenar este campo';
                  }
                },
                controller: txtNombre,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Duración'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor llenar este campo';
                  }
                },
                controller: txtDuracion,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final response = await http.post(
                      Uri.parse('${Ambiente.urlServer}/api/etapa/guardar'),
                      body: jsonEncode(<String, dynamic>{
                        'id': widget.idEtapa,
                        'nombre': txtNombre.text,
                        'duracion': txtDuracion.text,
                        'id_servicio': txtIdServicio.text,
                      }),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Accept': 'application/json'
                      },
                    );

                    print(response.body);
                    if (response.body == 'OK') {
                      Navigator.pop(context);
                    } else {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: 'Oops...',
                        text: response.body,
                      );
                    }
                  }
                },
                child: const Text('Enviar'),
              ),
              Visibility(
                visible: widget.idEtapa != 0,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final response = await http.post(
                        Uri.parse('${Ambiente.urlServer}/api/etapa/eliminar'),
                        body: jsonEncode(<String, dynamic>{
                          'id': widget.idEtapa,
                        }),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                          'Accept': 'application/json'
                        },
                      );

                      print(response.body);
                      if (response.body == 'OK') {
                        Navigator.pop(context);
                      } else {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: 'Oops...',
                          text: response.body,
                        );
                      }
                    }
                  },
                  child: const Text('Eliminar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
