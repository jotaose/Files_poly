import 'dart:io';
import 'package:archivos_polyrev/rol_finanzas.dart';
import 'package:archivos_polyrev/upload_rrhh.dart';
import 'package:archivos_polyrev/upload_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:archivos_polyrev/rol_operaciones.dart';
import 'package:archivos_polyrev/rol_rrhh.dart';
import 'dart:core';
import 'storage_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MiApp());
}

class MiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Mi App",
      home: Inicio(),
    );
  }
}

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final Storage storage = Storage();

  UploadTask? task;
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pruebas de Todo"),
        ),
        body: ListView(
          children: <Widget>[
            miCardFinanzas(),
            miCardTest(),
            miCardUpload(),
          ],
        ));
  }

  Card miCardUpload() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(15),
      elevation: 10,
      child: Column(
        children: <Widget>[
          const ListTile(
            contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
            title: Text('upload'),
            subtitle: Text('metodo subir archivo'),
            leading: Icon(Icons.money_rounded),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                  onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => uploadRRHH(),
                          ),
                        )
                      },
                  child: const Text('Ir')),
              //TextButton(onPressed: () => {}, child: const Text('Cancelar'))
            ],
          ),
        ],
      ),
    );
  }

  Card miCardTest() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(15),
      elevation: 10,
      child: Column(
        children: <Widget>[
          const ListTile(
            contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
            title: Text('PRUEBAS'),
            subtitle: Text('Para Hacer Pruebas'),
            leading: Icon(Icons.money_rounded),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                  onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => uploadTest(),
                          ),
                        )
                      },
                  child: const Text('Ir')),
              //TextButton(onPressed: () => {}, child: const Text('Cancelar'))
            ],
          ),
        ],
      ),
    );
  }

  Card miCardFinanzas() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(15),
      elevation: 10,
      child: Column(
        children: <Widget>[
          const ListTile(
            contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
            title: Text('FINANZAS'),
            subtitle: Text('Todo lo relacionado con finanzas'),
            leading: Icon(Icons.money_rounded),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                  onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => rolFinanzas(),
                          ),
                        )
                      },
                  child: const Text('Ir')),
              //TextButton(onPressed: () => {}, child: const Text('Cancelar'))
            ],
          ),
        ],
      ),
    );
  }
}
