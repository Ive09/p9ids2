import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:p9ids2/Pages/AutosLista.dart';
import 'package:p9ids2/Pages/ServiciosLista.dart';
import 'package:p9ids2/Pages/EtapasLista.dart';
import 'package:p9ids2/Utils/Ambiente.dart';

import '../Model/ServiciosResponse.dart';
import 'package:http/http.dart' as http;

import 'Servicio.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Colors.white,
       appBar: AppBar(
         backgroundColor: Colors.white,
         title: const Text('CarWash'),
       ),
     body: SingleChildScrollView(
         child: Center(child:
          Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Text('Bienvenido'),
             Text('a la aplicación'),
             Text('de autolavado'),
             Image.network('https://static.vecteezy.com/system/resources/thumbnails/010/486/942/small_2x/blue-car-wash-auto-detailing-logo-vector.jpg'),

             ElevatedButton(
               onPressed: () {
                 Navigator.push(context,
                   MaterialPageRoute(
                       builder: (context)=> const Servicioslista()
                   ),
                 );
               },
               child: const Text('Ver Servicios'),
             ),

             ElevatedButton(
               onPressed: () {
                 Navigator.push(context,
                   MaterialPageRoute(
                       builder: (context)=> const Autoslista()
                   ),
                 );
               },
               child: const Text('Ver Autos'),
             ),


           ],
          )
         ),
     ),
   );
  }
}
