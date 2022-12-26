import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../app_provider/form_provider.dart';
import '../app_services/database/uploader.dart';
import '../app_utils/app_constants.dart';
import 'get_signature.dart';

class FormSignature extends StatefulWidget {
  final FormProvider provider;
  final String pageId;
  final String fieldId;
  final Map<String, dynamic> widgetJson;
  const FormSignature({
    Key? key,
    required this.pageId,
    required this.fieldId,
    required this.provider,
    required this.widgetJson,
  }) : super(key: key);
  @override
  State<FormSignature> createState() => _FormSignatureState();
}

class _FormSignatureState extends State<FormSignature> {
  Uint8List? _signatureImage;

  Future<void> _getImageFromGallery(FormFieldState formState) async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      // debugPrint('image is not null\n\n');
      _signatureImage = await image.readAsBytes();
      formState.didChange(_signatureImage);
      if (_signatureImage != null) {
        // debugPrint('image.bytes is not null\n\n');
        await _addImage(_signatureImage!);
      }
    }
  }

  Future<void> _addImage(var image) async {
    String _dbPath =
        '${widget.provider.assignmentId}/${widget.pageId}/${widget.fieldId}';
    UploadTask? task = await FileUploader.uploadFile(
        dbPath: _dbPath, fileData: _signatureImage!);

    if (task != null) {
      // widget.provider.updateData(
      //     pageId: widget.pageId, fieldId: widget.fieldId, value: _dbPath);
    }
  }

  Future<void> _deleteFromDatabase() async {
    String _dbPath =
        '${widget.provider.assignmentId}/${widget.pageId}/${widget.fieldId}';
    if (_signatureImage != null) {
      await FileUploader.deleteFile(dbPath: _dbPath);
      widget.provider.deleteData(_dbPath);
    }
  }

  Future<void> _initializeSignatureFromDatabase() async {
    String? path =
        widget.provider.getResult['${widget.pageId},${widget.fieldId}'];
    if (path != null) {
      Uint8List? image = await FirebaseStorage.instance.ref(path).getData();
      if (image != null) {
        _signatureImage = image;
      }
    }
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
      decoration: containerElevationDecoration,
      child: FutureBuilder(
        future: _initializeSignatureFromDatabase(),
        builder: (context, AsyncSnapshot<void> form) {
          if (form.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return FormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              initialValue: _signatureImage,
              validator: (signature) {
                if (widget.widgetJson.containsKey('required') &&
                    widget.widgetJson['required'] == true) {
                  return 'Please Add Signature';
                }
                return null;
              },
              builder: (formState) {
                return Column(
                  children: [
                    SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width - 30,
                      child: _signatureImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(
                                _signatureImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Text(''),
                    ),
                    const Divider(thickness: 1.5),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () async {
                              /// first delete from database
                              await _deleteFromDatabase();

                              /// then delete from local ram
                              _signatureImage = null;

                              /// update formstate
                              formState.didChange(_signatureImage);
                            },
                            tooltip: 'Clear',
                            icon: const Icon(
                              Icons.close,
                              size: 30,
                              color: CupertinoColors.destructiveRed,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  await Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const GetSignature(),
                                    ),
                                  )
                                      .then((image) async {
                                    if (image != null) {
                                      // debugPrint(
                                      // 'signature runtimetype --> ${image.runtimeType}\n\n');
                                      _signatureImage = image;
                                      await _addImage(image);
                                    }
                                    formState.didChange(_signatureImage);
                                  });
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.pencil,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              IconButton(
                                onPressed: () async {
                                  await _getImageFromGallery(formState);
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.image,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
}
