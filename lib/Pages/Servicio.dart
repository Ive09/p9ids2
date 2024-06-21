import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:p9ids2/Model/ServiciosResponse.dart';
import 'package:p9ids2/Pages/Etapa.dart';
import 'package:p9ids2/Pages/EtapasLista.dart';
import 'package:p9ids2/Utils/Ambiente.dart';
import 'package:quickalert/quickalert.dart';

class Servicio extends StatefulWidget {
  final int idServicio;
  const Servicio({Key? key, required this.idServicio}) : super(key: key);

  @override
  State<Servicio> createState() => _ServicioState();
}

class _ServicioState extends State<Servicio> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController txtCodigo = TextEditingController();
  final TextEditingController txtNombre = TextEditingController();
  final TextEditingController txtDescripcion = TextEditingController();
  final TextEditingController txtPrecio = TextEditingController();

  void fnDatosServicio() async {
    final response = await http.post(
      Uri.parse('${Ambiente.urlServer}/api/servicio'),
      body: jsonEncode(<String, dynamic>{
        'id': widget.idServicio,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
    );
    Map<String, dynamic> responseJson = jsonDecode(response.body);
    final servicioResponse = ServiciosResponse.fromJson(responseJson);
    txtCodigo.text = servicioResponse.codigo;
    txtNombre.text = servicioResponse.nombre;
    txtDescripcion.text = servicioResponse.descripcion;
    txtPrecio.text = servicioResponse.precio.toString();
  }

  @override
  void initState() {
    super.initState();
    if (widget.idServicio != 0) {
      fnDatosServicio();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Formulario de servicio"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Codigo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor llenar este campo';
                  }
                },
                controller: txtCodigo,
              ),
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
                decoration: InputDecoration(labelText: 'Descripcion'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor llenar este campo';
                  }
                },
                controller: txtDescripcion,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor llenar este campo';
                  }
                },
                controller: txtPrecio,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final response = await http.post(
                      Uri.parse('${Ambiente.urlServer}/api/servicio/guardar'),
                      body: jsonEncode(<String, dynamic>{
                        'id': widget.idServicio,
                        'codigo': txtCodigo.text,
                        'nombre': txtNombre.text,
                        'descripcion': txtDescripcion.text,
                        'precio': txtPrecio.text,
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
                visible: widget.idServicio != 0,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final response = await http.post(
                        Uri.parse('${Ambiente.urlServer}/api/servicio/eliminar'),
                        body: jsonEncode(<String, dynamic>{
                          'id': widget.idServicio,
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
              Visibility(
                  visible: widget.idServicio !=0,
                  child:   ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context)=>  Etapaslista(idServicio: widget.idServicio,)
                        ),
                      );
                    },
                    child: const Text('Ver Etapas'),
                  ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
