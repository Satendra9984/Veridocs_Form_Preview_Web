import 'dart:io';
import 'dart:typed_data';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../app_provider/form_provider.dart';
import '../../form_screens/form_constants.dart';

class FormFileDisplay extends StatefulWidget {
  final Map<String, dynamic> widgetJson;
  final FormProvider provider;
  final String pageId;
  final String fieldId;
  const FormFileDisplay({
    Key? key,
    required this.pageId,
    required this.fieldId,
    required this.provider,
    required this.widgetJson,
  }) : super(key: key);

  @override
  State<FormFileDisplay> createState() => _FormFileDisplayState();
}

class _FormFileDisplayState extends State<FormFileDisplay> {
  final List<String> _filesList = [];

  /// Because after taking photo build is called again so images are added already on top of existing images
  bool _isListsInitializedAlready = false;

  @override
  void initState() {
    super.initState();
  }

  int _getCrossAxisCount() {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    int wid = width.toInt();
    int count = (wid) ~/ 150;
    // debugPrint('count --> $count');
    return count;
  }

  Widget _getLabel() {
    String label = widget.widgetJson['label'];

    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          fontSize: kLabelFontSize,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        children: [
          if (widget.widgetJson.containsKey('required') &&
              widget.widgetJson['required'] == true)
            TextSpan(
              text: ' *',
              style: TextStyle(
                color: Colors.red.shade400,
                fontSize: kLabelFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _setInitialFilesData() async {
    if (_isListsInitializedAlready == false) {
      dynamic listOfImagesFromDatabase =
          widget.provider.getResult['${widget.pageId},${widget.fieldId}'];

      List<dynamic> filesList =
          List<dynamic>.from(listOfImagesFromDatabase ?? []);
      debugPrint("listOffiles from database: $listOfImagesFromDatabase");
      if (filesList.isNotEmpty) {
        for (String stref in filesList) {
          _filesList.add(stref);
        }
      }
      _isListsInitializedAlready = true;
      debugPrint("files length: ${_filesList.length}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 15),
      child: FutureBuilder(
        future: _setInitialFilesData(),
        builder: (context, AsyncSnapshot<void> form) {
          if (form.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getLabel(),
                const SizedBox(
                  height: 15,
                ),
                if (_filesList.isNotEmpty && _filesList.isNotEmpty)
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _filesList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 2.5),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.file_copy_sharp,
                                  color: Colors.redAccent,
                                  size: 16,
                                ),
                                SizedBox(height: 2),
                              ],
                            ),
                            const SizedBox(width: 2.5),
                            TextButton(
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (context) => FutureProgressDialog(
                                    openFile(index),
                                    message: const Text(
                                      'Processing',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              style: ButtonStyle().copyWith(
                                alignment: Alignment.topCenter,
                              ),
                              child: Text(
                                'File ${index + 1}',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _getCrossAxisCount() + 1,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 1,
                      childAspectRatio: 3.5,
                    ),
                  ),
                const SizedBox(
                  height: 5,
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<String> _getFileExtension(int index) async {
    var ref = await FirebaseStorage.instance
        .ref()
        .child(_filesList[index])
        .getMetadata();

    if (ref.contentType != null) {
      String extension = ref.contentType!;
      String lastThree =
          extension.substring(extension.length - 3, extension.length);
      if (lastThree == 'pdf') {
        return '.pdf';
      } else if (lastThree == 'peg') {
        return '.jpeg';
      } else if (lastThree == 'jpg') {
        return '.jpg';
      } else if (lastThree == 'png') {
        return '.png';
      } else if (lastThree == 'ent') {
        return '.docx';
      }
    }
    return '.pdf';
  }

  Future<void> openFile(int index) async {
    var ref = await FirebaseStorage.instance
        .ref()
        .child(_filesList[index])
        .getDownloadURL();

    http.get(Uri.parse(ref)).then((response) async {
      Uint8List bodyBytes = response.bodyBytes;
      final dir = await getExternalStorageDirectory();
      String fileExtension = await _getFileExtension(index);
      final myImagePath = "${dir!.path}/myfile$fileExtension";
      File imageFile = File(myImagePath);
      if (!await imageFile.exists()) {
        imageFile.create(recursive: true);
      }
      imageFile.writeAsBytes(bodyBytes);
      await OpenFile.open(imageFile.path);
    });
  }
}
