import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

class PickFile {
  static Future<String?> pickFileAndGetPath(
      {List<String>? fileExtensions}) async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      allowedExtensions: fileExtensions,
      type: FileType.custom,
    );

    if (file != null) {
      debugPrint('file form picker --> ${file.files.first.path}');
      return file.files.single.path;
    }
    return null;
  }

  static Future<PlatformFile?> pickAndGetFileAsBytes(
      {List<String>? fileExtensions}) async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      allowedExtensions: fileExtensions,
      type: FileType.any,
    );

    if (file != null) {
      return file.files.first;
    }
    return null;
  }

  static Future<List<String?>> pickAndGetFileDirs(
      List<String>? fileExtensions) async {
    FilePickerResult? files = await FilePicker.platform
        .pickFiles(allowMultiple: true, allowedExtensions: fileExtensions);

    if (files != null) {
      return files.files.map((e) => e.path).toList();
    }

    return [];
  }
}
