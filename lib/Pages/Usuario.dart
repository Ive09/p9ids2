import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:p9ids2/Model/ServiciosResponse.dart';
import 'package:p9ids2/Model/UsuariosResponse.dart';
import 'package:p9ids2/Pages/Etapa.dart';
import 'package:p9ids2/Pages/EtapasLista.dart';
import 'package:p9ids2/Utils/Ambiente.dart';
import 'package:quickalert/quickalert.dart';

class Usuario extends StatefulWidget {
  const Usuario({super.key});

  @override
  State<Usuario> createState() => _UsuarioState();
}

class _UsuarioState extends State<Usuario> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();


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
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor llenar este campo';
                  }
                },
                controller: txtName,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Correo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor llenar este campo';
                  }
                },
                controller: txtEmail,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contraseña'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor llenar este campo';
                  }
                },
                controller: txtPassword,
              ),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final response = await http.post(
                      Uri.parse('${Ambiente.urlServer}/api/crear'),
                      body: jsonEncode(<String, dynamic>{
                        'name': txtName.text,
                        'email': txtEmail.text,
                        'password': txtPassword.text,
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
                child: const Text('Crear'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
