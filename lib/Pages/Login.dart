import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:p9ids2/Model/LoginResponse.dart';
import 'package:p9ids2/Pages/Home.dart';
import 'package:p9ids2/Pages/Usuario.dart';
import 'package:p9ids2/Utils/Ambiente.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController txtUser = TextEditingController();
  final TextEditingController txtPass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Login"),
      ),
      body:
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network('https://static.vecteezy.com/system/resources/thumbnails/020/788/814/small_2x/icon-symbol-or-website-admin-social-login-element-concept-3d-rendering-png.png'),
            TextField(
              decoration: InputDecoration(
                  labelText: 'Usuario'
              ),
              controller: txtUser,
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: 'Contraseña'
              ),
              controller: txtPass,
              obscureText: true,
            ),
            ElevatedButton(onPressed: () async {
              final response =await http.post(Uri.parse('${Ambiente.urlServer}/api/login'),
                  body: jsonEncode(<String, dynamic>{
                    'email' : txtUser.text,
                    'password': txtPass.text,
                  }),
                  headers: <String, String>{
                'Content-Type' : 'aplication/json; charset=UTF-8'
                  }
              );

              print(response.body);

              Map<String, dynamic>responseJson=jsonDecode(response.body);
              final loginResponse= Loginresponse. fromJson(responseJson);
              if(loginResponse.acceso== "Ok")
              {
                Navigator.push(context,
                MaterialPageRoute(
                    builder: (context)=> const Home()
                )
                );
              }
              else
              {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  title: 'Oops...',
                  text: loginResponse.error,
                );
              }
            }, child: Text('Accesar')),

            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context)=> const Usuario()
                  ),
                );
              },
              child: const Text('Registrar usuario'),
            ),
          ],
        ),
      )
    );
  }
}
