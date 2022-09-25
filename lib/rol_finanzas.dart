import 'package:archivos_polyrev/storage_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class rolFinanzas extends StatefulWidget {
  rolFinanzas({Key? key}) : super(key: key);

  @override
  State<rolFinanzas> createState() => _rolFinanzasState();
}

class _rolFinanzasState extends State<rolFinanzas> {
  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finanzas Archivos'),
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: storage.listFiles(),
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
                                //primero obtener la url
                                String nu = await storage.downloadFileX(datos);

                                storage.downloadFile(
                                    nu, datos, '/storage/Download');

                                print('estas descargando: $nu');
                                setState(() {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        ' Archivo en descargas....',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  );
                                });
                              },
                            ),
                            onDismissed: (direction) async {
                              final obUrl = await storage.downloadURL(datos);
                              print('Url del archivo: $obUrl');
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
          final uplo = storage.uploadFile(path, fileName);
          //FilePickerStatus.done;

          setState(() {});
        },
      ),
    );
  }
}
