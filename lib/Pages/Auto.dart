import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:p9ids2/Model/AutosResponse.dart';
import 'package:p9ids2/Model/ServiciosResponse.dart';
import 'package:p9ids2/Pages/Etapa.dart';
import 'package:p9ids2/Pages/EtapasLista.dart';
import 'package:p9ids2/Utils/Ambiente.dart';
import 'package:quickalert/quickalert.dart';

class Auto extends StatefulWidget {
  final int idAuto;
  const Auto({Key? key, required this.idAuto}) : super(key: key);

  @override
  State<Auto> createState() => _AutoState();
}

class _AutoState extends State<Auto> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController txtMatricula = TextEditingController();
  final TextEditingController txtColor = TextEditingController();
  final TextEditingController txtModelo = TextEditingController();
  final TextEditingController txtMarca = TextEditingController();

  void fnDatosAuto() async {
    final response = await http.post(
      Uri.parse('${Ambiente.urlServer}/api/auto'),
      body: jsonEncode(<String, dynamic>{
        'id': widget.idAuto,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
    );

    Map<String, dynamic> responseJson = jsonDecode(response.body);
    final autoResponse = AutosResponse.fromJson(responseJson);
    txtMatricula.text = autoResponse.matricula;
    txtColor.text = autoResponse.color;
    txtModelo.text = autoResponse.modelo;
    txtMarca.text = autoResponse.marca;
  }

  @override
  void initState() {
    super.initState();
    if (widget.idAuto != 0) {
      fnDatosAuto();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Formulario de auto"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Matricula'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor llenar este campo';
                  }
                },
                controller: txtMatricula,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Color'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor llenar este campo';
                  }
                },
                controller: txtColor,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Modelo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor llenar este campo';
                  }
                },
                controller: txtModelo,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Marca'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor llenar este campo';
                  }
                },
                controller: txtMarca,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final response = await http.post(
                      Uri.parse('${Ambiente.urlServer}/api/auto/guardar'),
                      body: jsonEncode(<String, dynamic>{
                        'id': widget.idAuto,
                        'matricula': txtMatricula.text,
                        'color': txtColor.text,
                        'modelo': txtModelo.text,
                        'marca': txtMarca.text,
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
                child: const Text('Guardar'),
              ),
              Visibility(
                visible: widget.idAuto != 0,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final response = await http.post(
                        Uri.parse('${Ambiente.urlServer}/api/auto/eliminar'),
                        body: jsonEncode(<String, dynamic>{
                          'id': widget.idAuto,
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
