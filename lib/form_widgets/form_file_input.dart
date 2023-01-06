import 'dart:io';
import 'dart:typed_data';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_provider/form_provider.dart';
import '../app_services/database/uploader.dart';
import '../app_utils/app_constants.dart';

class FormFileInput extends StatefulWidget {
  final Map<String, dynamic> widgetJson;
  final FormProvider provider;
  final String pageId;
  final String fieldId;
  const FormFileInput({
    Key? key,
    required this.pageId,
    required this.fieldId,
    required this.provider,
    required this.widgetJson,
  }) : super(key: key);

  @override
  State<FormFileInput> createState() => _FormFileInputState();
}

class _FormFileInputState extends State<FormFileInput> {
  final List<String> _filesList = [];

  /// Because after taking photo build is called again so images are added already on top of existing images
  bool _isListsInitializedAlready = false;

  /// to take count of lengths index of images
  int _fileIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  int _getCrossAxisCount() {
    double width = MediaQuery.of(context).size.width;
    double margin = width * 0.30;

    if (width - 2 * margin < 500) {
      margin = (width - 500) / 2;
    }
    width -= 2 * margin;
    int wid = width.toInt();
    int count = (wid) ~/ 150;
    debugPrint('count --> $count');
    return count;
  }

  Widget _getLabel() {
    String label = widget.widgetJson['label'];

    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          fontSize: 17,
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
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  /// function for adding/updating file to database
  Future<void> _addData() async {
    // debugPrint('adding files but filesLength - ${_filesList.length}');
    FilePickerResult? fileGet = await FilePicker.platform.pickFiles();

    if (fileGet != null) {
      PlatformFile file = fileGet.files.first;
      // debugPrint('adding file of extension ${file!.extension}');
      Uint8List? fileBytes = await File(file.path!).readAsBytes();
      String dbPath =
          '${widget.provider.assignmentId}/${widget.pageId},${widget.fieldId}/$_fileIndex';

      // debugPrint('uploading file at ${_dbPath}');

      showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(
          FileUploader.uploadFile(dbPath: dbPath, fileData: fileBytes)
              .then((task) async {
            if (task != null) {
              setState(() {
                _filesList.add(dbPath);
              });
              _fileIndex++;
              await _updateData();
            }
          }),
          message: const Center(
            child: Text(
              'Adding File',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }
  }

  /// update field data in database
  Future<void> _updateData() async {
    // widget.provider.updateData(
    //   pageId: widget.pageId,
    //   fieldId: widget.fieldId,
    //   value: _filesList,
    // );
    // await widget.provider.saveDraftData();
  }

  /// for deleting a file
  Future<void> _deleteFile(int index) async {
    await FirebaseStorage.instance
        .ref()
        .child(_filesList[index])
        .delete()
        .then((value) async {
      setState(() {
        _filesList.removeAt(index);
      });
      await _updateData();
    }).catchError(
      (e) {
        return;
      },
    );
  }

  Widget _showDeleteFileAlertDialog(int index) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Text(
        'Delete File ${index + 1} ?',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context, true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent.shade200,
            elevation: 5,
          ),
          child: const Text('Yes'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            // backgroundColor: Colors.redAccent.shade200,
            elevation: 5,
          ),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Future<void> _setInitialFilesData() async {
    if (_isListsInitializedAlready == false) {
      dynamic listOfImagesFromDatabase =
          widget.provider.getResult['${widget.pageId},${widget.fieldId}'];

      List<dynamic> filesList =
          List<dynamic>.from(listOfImagesFromDatabase ?? []);

      if (filesList.isNotEmpty) {
        for (String stref in filesList) {
          _filesList.add(stref);
        }
        _fileIndex = filesList.length;
      }
      _isListsInitializedAlready = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    _getCrossAxisCount();
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: containerElevationDecoration,
      child: FutureBuilder(
        future: _setInitialFilesData(),
        builder: (context, AsyncSnapshot<void> form) {
          if (form.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return FormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              initialValue: _filesList,
              validator: (fileList) {
                if (widget.widgetJson.containsKey('required') &&
                    widget.widgetJson['required'] == true &&
                    _filesList.isEmpty) {
                  return 'Please select a file';
                } else if (_filesList.length < 3) {
                  return null;
                }
                return null;
              },
              builder: (formState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getLabel(),
                    const SizedBox(
                      height: 15,
                    ),
                    if (_filesList.isNotEmpty)
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: _filesList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(width: 5),
                                const Icon(
                                  Icons.file_copy_sharp,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(width: 5),
                                TextButton(
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          FutureProgressDialog(
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
                                  child: Text(
                                    'File ${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          _showDeleteFileAlertDialog(
                                        index,
                                      ),
                                    ).then((delete) {
                                      if (delete != null && delete == true) {
                                        // debugPrint('delete choice = $delete');
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              FutureProgressDialog(
                                            _deleteFile(index),
                                            message: Center(
                                              child: Text(
                                                'Deleting File ${index + 1}',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                  ),
                                  splashRadius: 10.0,
                                ),
                              ],
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _getCrossAxisCount(),
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 1,
                          childAspectRatio: 3.5,
                          // mainAxisSpacing:
                        ),
                      ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (_filesList.length < 3)
                      ElevatedButton(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('Add File'),
                            SizedBox(width: 10),
                            Icon(Icons.file_upload_outlined),
                          ],
                        ),
                        onPressed: () async {
                          await _addData();
                        },
                      ),
                    if (formState.hasError)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: CupertinoColors.systemRed,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              formState.errorText!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: CupertinoColors.systemRed,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
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
    debugPrint('file url-> $ref');
    Uri link = Uri.parse(ref);
    if (await canLaunchUrl(link)) {
      await launchUrl(link, mode: LaunchMode.platformDefault);
    }

    // http.get(Uri.parse(ref)).then((response) async {
    //   Uint8List bodyBytes = response.bodyBytes;
    //   final dir = await getExternalStorageDirectory();
    //   String fileExtension = await _getFileExtension(index);
    //   debugPrint('file extension = $fileExtension');
    //   final myImagePath = "${dir!.path}/myfile$fileExtension";
    //   File imageFile = File(myImagePath);
    //   if (!await imageFile.exists()) {
    //     imageFile.create(recursive: true);
    //   }
    //   imageFile.writeAsBytes(bodyBytes);
    //   // final result = await OpenFile.open(imageFile.path);
    //
    //   // setState(() {
    //   // String _openResult = "type=${result.type}  message=${result.message}";
    //   // });
    //   // debugPrint('open rsult = $_openResult');
    // });
  }
}
