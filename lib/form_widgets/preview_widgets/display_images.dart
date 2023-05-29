import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../app_provider/form_provider.dart';
import '../../form_screens/form_constants.dart';

class FormImagePreviewDisplay extends StatefulWidget {
  final Map<String, dynamic> widgetJson;
  final FormProvider provider;
  final String pageId;
  final String fieldId;
  final bool isSignature;
  const FormImagePreviewDisplay({
    Key? key,
    required this.pageId,
    required this.fieldId,
    required this.provider,
    required this.widgetJson,
    this.isSignature = false,
  }) : super(key: key);

  @override
  State<FormImagePreviewDisplay> createState() =>
      _FormImagePreviewDisplayState();
}

class _FormImagePreviewDisplayState extends State<FormImagePreviewDisplay> {
  /// Actual images data
  List<Uint8List> _imageFileList = [];

  /// Because after taking photo build is called again so images are added already on top of existing images
  bool _isListsInitializedAlready = false;

  /// to take count of lengths index of images

  /// Images paths list for adding in form response data
  List<String> _imageFileListPaths = [];

  /// Get Initial Images From FirebaseStorage
  Future<void> _setInitialImagesData() async {
    // debugPrint('setInitialImageData called\n');
    if (_isListsInitializedAlready == false) {
      dynamic listOfImagesFromDatabase =
          widget.provider.getResult['${widget.pageId},${widget.fieldId}'];

      List<dynamic> imageList = [];
      if (listOfImagesFromDatabase.runtimeType == String) {
        imageList.add(listOfImagesFromDatabase);
      } else {
        imageList = List<dynamic>.from(listOfImagesFromDatabase ?? []);
      }

      if (imageList.isNotEmpty) {
        var ref = await FirebaseStorage.instance.ref();
        _imageFileList.clear();
        _imageFileListPaths.clear();
        for (var path in imageList) {
          await ref.child(path).getData().then((value) {
            if (value != null) {
              _imageFileList.add(value);
              _imageFileListPaths.add(path);
            }
          });
        }
      }
      _isListsInitializedAlready = true;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _getLabel() {
    String label = widget.widgetJson['label'];

    return RichText(
      text: TextSpan(
        text: '$label',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontSize: kLabelFontSize,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      margin: const EdgeInsets.only(bottom: 15),
      // decoration: containerElevationDecoration,
      child: FutureBuilder(
        future: _setInitialImagesData(),
        builder: (context, AsyncSnapshot<void> form) {
          if (form.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                _getLabel(),
                const SizedBox(
                  height: 15,
                ),

                /// Display Images
                if (_imageFileList.isNotEmpty)
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _imageFileList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => _showImagesInPopUp(index),
                            );
                          },
                          child: !widget.isSignature
                              ? Image.memory(
                                  _imageFileList[index],
                                  fit: BoxFit.cover,
                                )
                              : Image.memory(
                                  _imageFileList[index],
                                  fit: BoxFit.contain,
                                  height: 80,
                                  width: 150,
                                ),
                        ),
                      );
                    },
                  ),
              ],
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Image.memory(
              _imageFileList[index],
            ),
          ],
        ),
      ),
    );
  }
}
