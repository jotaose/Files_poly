import 'package:archivos_polyrev/storage_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class terrenoObras extends StatefulWidget {
  terrenoObras({Key? key}) : super(key: key);

  @override
  State<terrenoObras> createState() => _terrenoObrasState();
}

class _terrenoObrasState extends State<terrenoObras> {
  final Storage storage = Storage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OPERACIONES'),
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: storage.listFilesOperaciones(),
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
                              final obUrl = await storage.downloadURLOP(datos);

                              storage.deleteArchivo(obUrl);
                              //necesito la url para eliminar un archivo

                              setState(() {
                                obUrl;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Archivo Eliminado....'),
                                  ),
                                );
                              });
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
            allowedExtensions: ['pdf', 'docx', 'jpg', 'png'],
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
          final fileNameOp = result.files.single.name;
          //final fileFecha = DateFormat("dd.MM.yyyy HH:mm").format(uploadata);
          final upload = storage.uploadFileOp(path, fileNameOp);

          setState(() {
            upload;
            //const CircularProgressIndicator();
          });
        },
      ),
    );
  }
}
