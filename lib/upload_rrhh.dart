import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'storage_services.dart';

class uploadRRHH extends StatefulWidget {
  uploadRRHH({Key? key}) : super(key: key);

  @override
  State<uploadRRHH> createState() => _uploadRRHHState();
}

class _uploadRRHHState extends State<uploadRRHH> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Archivos'),
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

                        return ListTile(
                          title: Text(
                            datos,
                            style: const TextStyle(fontSize: 18),
                          ),
                          subtitle: const Text('pendiante'),
                          leading: const Icon(Icons.archive),
                          //trailing: ,
                        );
                      },
                    ),
                  );
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

          storage.uploadFile(path, fileName);

          setState(() {});
        },
      ),
    );
  }
}
