import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

//subir un archivo
  Future<void> uploadFile(
    String filePath,
    String fileName,
    //DateTime fileDate,
  ) async {
    File file = File(filePath);
    try {
      await storage.ref('finanzas/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  //subir un archivo desde rrhh
  Future<void> uploadRR(String filePathRR, String fileNameRR) async {
    File file = File(filePathRR);
    try {
      await storage.ref('rrhh/$fileNameRR').putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  //subir un archivo desde operaciones
  Future<void> uploadFileOp(
    String filePath,
    String fileNameOp,
    //DateTime fileDate,
  ) async {
    File file = File(filePath);
    try {
      await storage.ref('operaciones/$fileNameOp').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

//listar todos los archivos en cloud firebase Storage
  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult result =
        await storage.ref('finanzas').listAll();

    result.items.forEach((firebase_storage.Reference ref) {});

    return result;
  }

  //listar archivos de operaciones
  Future<firebase_storage.ListResult> listFilesOperaciones() async {
    firebase_storage.ListResult result =
        await storage.ref('operaciones').listAll();

    result.items.forEach((firebase_storage.Reference ref) {});

    return result;
  }

//listar archivos de rrhh
  Future<firebase_storage.ListResult> listFilesRRHH() async {
    firebase_storage.ListResult result = await storage.ref('rrhh').listAll();

    result.items.forEach((firebase_storage.Reference ref) {});

    return result;
  }
  //metodo para eliminar una archivo desde  Storage

  Future<void> deleteArchivo(String url) async {
    try {
      //
      await storage.refFromURL(url).delete();
      //
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  //metodo para obtener la url
  Future<String> downloadURL(String imageName) async {
    final urlDownload =
        await storage.ref('finanzas/$imageName').getDownloadURL();

    //print('Download-Link: $urlDownload');
    return urlDownload;
  }

  //metodo para obtener la url
  Future<String> downloadURLOP(String imageName) async {
    final urlDownload =
        await storage.ref('operaciones/$imageName').getDownloadURL();

    //print('Download-Link: $urlDownload');
    return urlDownload;
  }

//metodo eliminar RRHH
  Future<String> downloadURLRRHH(String imageName) async {
    final urlDownload = await storage.ref('rrhh/$imageName').getDownloadURL();

    //print('Download-Link: $urlDownload');
    return urlDownload;
  }

  //metodo para descargar archivos
  Future<String> downloadFile(String url, String fileName, String dir) async {
    HttpClient httpClient = HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';

    try {
      myUrl = '$url/$fileName';
      var request = await httpClient.getUrl(Uri.parse(myUrl));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '$dir/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      } else {
        filePath = 'Error codigo: ${response.statusCode}';
      }
    } catch (ex) {
      filePath = 'Can not fetch url';
    }

    return filePath;
  }

  //para hacer pruebas de descargas
  //si la url es distinta o null subir el archivo de lo contrario no subir decir que el archivo
  //existe

  Future<String> downloadFileX(String url) async {
    Directory appDoc = await getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDoc.path}/$url');
    String fileToDownload = 'finanzas/$url';

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref(fileToDownload)
          .writeToFile(downloadToFile);
    } on firebase_core.FirebaseException catch (e) {
      print('Download error: $e');
    }
    return url;
  }
}
