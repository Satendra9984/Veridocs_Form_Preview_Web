import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

import '../../app_utils/pick_file/pick_file.dart';

class FileUploader {
  static Future<UploadTask?> uploadSingleFileToFirebase(
    String dbPath, {
    List<String> fileExtensions: const ['pdf', 'jpg'],
  }) async {
    return await PickFile.pickFileAndGetPath(fileExtensions: fileExtensions)
        .then((file) async {
      if (file != null) {
        Uint8List data = await File(file).readAsBytes();
        return FirebaseStorage.instance.ref(dbPath).putData(data);
      } else {
        return null;
      }
    });
  }

  static Future<UploadTask?> uploadFileFromPath(
      {required String path, required String dbPath}) async {
    try {
      Uint8List data = await File(path).readAsBytes();
      return FirebaseStorage.instance.ref(dbPath).putData(data);
    } catch (e) {
      return null;
    }
  }

  static Future<UploadTask?> uploadFile(
      {required String dbPath, required Uint8List fileData}) async {
    try {
      return FirebaseStorage.instance.ref(dbPath).putData(fileData);
    } catch (e) {
      return null;
    }
  }

  static Future<void> deleteFile({required String dbPath}) async {
    try {
      return FirebaseStorage.instance.ref(dbPath).delete();
    } catch (e) {
      return;
    }
  }
}
