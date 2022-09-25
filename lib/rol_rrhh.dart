import 'dart:io';
import 'package:archivos_polyrev/test_firebase_api.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:archivos_polyrev/storage_services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class rr_hh extends StatefulWidget {
  rr_hh({Key? key}) : super(key: key);

  @override
  State<rr_hh> createState() => _rr_hhState();
}

@override
void initState() {}

class _rr_hhState extends State<rr_hh> {
  final Storage storage = Storage();
  UploadTask? task;
  File? file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RRHH'),
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: storage.listFilesRRHH(),
              builder: (BuildContext context,
                  AsyncSnapshot<firebase_storage.ListResult> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.items.length,
                      itemBuilder: (BuildContext context, int index) {
                        String datos = snapshot.data!.items[index].name;

                        List<String> _text = [datos];

                        for (var res in _text) {
                          print(res);
                        }

                        //lista vacia para agregar los datos del checkbox

                        //print('aqui van $datos');

                        return Dismissible(
                            key: Key(datos),
                            background: Container(
                              alignment: AlignmentDirectional.centerEnd,
                              color: Colors.red,
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: ListTile(
                              title: Text(
                                datos,
                                style: const TextStyle(fontSize: 18),
                              ),
                              subtitle: const Text('pendiente'),
                              leading: const Icon(Icons.archive),
                              //trailing: ,
                              onLongPress: () async {
                                String url = await storage.downloadURL(datos);

                                storage.downloadFile(
                                    url, datos, '/storage/Download');

                                setState(() {
                                  datos;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'archivo en descargas....',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  );
                                });
                              },
                            ),
                            onDismissed: (direction) async {
                              final obUrl = await storage.downloadURL(datos);

                              storage.deleteArchivo(obUrl);
                              //necesito la url para eliminar un archivo
                              setState(() {});
                            });
                      },
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) {
                  //return const CircularProgressIndicator();
                }
                return Container();
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await FilePicker.platform.pickFiles(
            allowMultiple: false,
            type: FileType.custom,
            allowedExtensions: ['pdf', 'docx'],
          );

          if (result == null) {
            final path = result!.files.single.path;
            setState(() {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Archivo no seleccionado...'),
                ),
              );
            });
            return;
          }

          final path = result.files.single.path!;
          final fileName = result.files.single.name;
          // final fileFecha = DateFormat("dd.MM.yyyy HH:mm").format(uploadata);
          storage.uploadRR(path, fileName);
          FilePickerStatus.done;

          setState(() {});
        },
      ),
    );
  }
}
