import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_provider/form_provider.dart';
import '../app_services/database/uploader.dart';
import '../app_utils/app_constants.dart';
import 'image_upload.dart';

class FormImageInput extends StatefulWidget {
  final Map<String, dynamic> widgetJson;
  final FormProvider provider;
  final String pageId;
  final String fieldId;
  const FormImageInput({
    Key? key,
    required this.pageId,
    required this.fieldId,
    required this.provider,
    required this.widgetJson,
  }) : super(key: key);

  @override
  State<FormImageInput> createState() => _FormImageInputState();
}

class _FormImageInputState extends State<FormImageInput> {
  /// Actual images data
  final List<Uint8List> _imageFileList = [];

  /// Because after taking photo build is called again so images are added already on top of existing images
  bool _isListsInitializedAlready = false;

  /// to take count of lengths index of images
  int _imageIndex = 0;

  /// Images paths list for adding in form response data
  final List<String> _imageFileListPaths = [];

  /// Add list of Images that we got from local storage/camera
  Future<void> _addImageToList(List<Uint8List> image) async {
    int j = 0;
    int i = _imageFileList.length;
    while (i < 3 && j < image.length) {
      _imageFileList.add(image[j]);
      await _addImageToDatabase(image[j], i);
      i++;
      j++;
    }
  }

  Future<void> _addImageToDatabase(Uint8List image, int index) async {
    String dbPath =
        '${widget.provider.assignmentId}/${widget.pageId},${widget.fieldId}/$_imageIndex';
    UploadTask? task =
        await FileUploader.uploadFile(dbPath: dbPath, fileData: image);

    if (task != null) {
      _imageFileListPaths.add(dbPath);
      await _updateData();
      _imageIndex++;
    }
  }

  Future<void> _updateData() async {
    // widget.provider.updateData(
    //   pageId: widget.pageId,
    //   fieldId: widget.fieldId,
    //   value: _imageFileListPaths,
    // );
    // await widget.provider.saveDraftData();
  }

  /// delete image from database
  Future<void> _deleteImage(int index) async {
    String dbPath = _imageFileListPaths[index];

    await FirebaseStorage.instance.ref(dbPath).delete().then((value) async {
      setState(() {
        _imageFileList.removeAt(index);
        _imageFileListPaths.removeAt(index);
      });
      await _updateData();
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Expanded(
                flex: 2,
                child: Icon(
                  Icons.error_outline,
                  size: 32,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 8,
                child: Text(
                  'File ${index + 1} not deleted, try after some time',
                  style: const TextStyle(
                    // color: Colors.redAccent,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                // backgroundColor: Colors.redAccent.shade200,
                elevation: 5,
              ),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    });
  }

  Widget _showDeleteImageAlertDialog(int index) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Text(
        'Delete Image ${index + 1} ?',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            await _deleteImage(index).then((value) {
              Navigator.pop(context);
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent.shade200,
            elevation: 5,
          ),
          child: const Text('Yes'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            elevation: 5,
          ),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  /// number of images can be placed in horizontally
  int _getCrossAxisCount() {
    try {
      Size size = MediaQuery.of(context).size;
      double width = size.width;
      int count = width ~/ 150;
      return count;
    } catch (e) {
      return 2;
    }
  }

  /// Get Initial Images From FirebaseStorage
  Future<void> _setInitialImagesData() async {
    if (_isListsInitializedAlready == false) {
      dynamic listOfImagesFromDatabase =
          widget.provider.getResult['${widget.pageId},${widget.fieldId}'];

      List<dynamic>? imageList =
          List<dynamic>.from(listOfImagesFromDatabase ?? []);
      if (imageList.isNotEmpty) {
        Reference ref = FirebaseStorage.instance.ref();

        for (var path in imageList) {
          await ref.child(path).getDownloadURL().then((value) async {
            if (value != null) {
              _imageFileListPaths.add(path);
            }
          });
        }
        _imageIndex = imageList.length;
      }
      _isListsInitializedAlready = true;
    }
  }

  @override
  void initState() {
    // debugPrint('initstate called');
    super.initState();
  }

  @override
  void dispose() {
    // debugPrint('dispose called');
    super.dispose();
  }

  Widget _getLabel() {
    String label = widget.widgetJson['label'];

    return RichText(
      text: TextSpan(
        text: '$label',
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: containerElevationDecoration,
      child: FutureBuilder(
        future: _setInitialImagesData(),
        builder: (context, AsyncSnapshot<void> form) {
          if (form.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return FormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              initialValue: _imageFileList,
              validator: (list) {
                if (widget.widgetJson.containsKey('required') &&
                    widget.widgetJson['required'] == true &&
                    _imageFileList.isEmpty) {
                  return 'Please add some images';
                }
                return null;
              },
              builder: (formState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    _getLabel(),
                    const SizedBox(
                      height: 15,
                    ),

                    /// Display Images
                    if (_imageFileListPaths.isNotEmpty)
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: _imageFileListPaths.length,
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
                              children: [
                                const SizedBox(width: 5),
                                const Icon(
                                  Icons.image,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(width: 5),
                                TextButton(
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            _showImagesInPopUp(index));
                                    // debugPrint(
                                    //     'launching path-> ${_imageFileListPaths[index]}');
                                    // await launchUrl(
                                    //     Uri(path: _imageFileListPaths[index]));
                                  },
                                  child: Text(
                                    'Image ${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 0),
                                IconButton(
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          _showDeleteImageAlertDialog(index),
                                    );
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

                    if (_imageFileListPaths.isNotEmpty)
                      const SizedBox(height: 10),

                    /// For adding new images
                    if (_imageFileList.length < 3)
                      ElevatedButton(
                        child: const Icon(Icons.add_a_photo_outlined, size: 24),
                        onPressed: () async {
                          await Navigator.of(context)
                              .push(CupertinoPageRoute(builder: (context) {
                            return const ImagePickerImageInput(
                              title: "Image",
                            );
                          })).then((value) async {
                            if (value != null) {
                              await _addImageToList(value);
                              formState.didChange(_imageFileList);
                            }
                          });
                        },
                      ),

                    /// validation widget
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

  Widget _showImagesInPopUp(int index) {
    return AlertDialog(
      content: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Image ${index + 1}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Image.network(_imageFileListPaths[index]),
          ],
        ),
      ),
    );
  }
}
