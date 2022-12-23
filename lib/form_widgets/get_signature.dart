import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:signature/signature.dart';

import '../app_utils/app_constants.dart';

class GetSignature extends StatefulWidget {
  const GetSignature({
    Key? key,
  }) : super(key: key);

  @override
  State<GetSignature> createState() => _GetSignatureState();
}

class _GetSignatureState extends State<GetSignature> {
  late final SignatureController _signatureController;

  @override
  void initState() {
    _signatureController = SignatureController(penStrokeWidth: 4.0);

    super.initState();
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 400,
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(5),
            decoration: containerElevationDecoration,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Signature(
                controller: _signatureController,
                backgroundColor: const Color(0XFFFAE5D3),
                width: MediaQuery.of(context).size.width - 20,
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  _signatureController.clear();
                },
                tooltip: 'Clear',
                icon: const Icon(
                  Icons.close,
                  size: 50,
                  color: CupertinoColors.destructiveRed,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              IconButton(
                onPressed: () {
                  _saveToGallery();
                },
                icon: const FaIcon(
                  FontAwesomeIcons.check,
                  size: 45,
                  color: CupertinoColors.systemGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _saveToGallery() async {
    if (_signatureController.isEmpty) {
      debugPrint('image empty');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('There is no signature found!!!')));
    } else {
      Uint8List? image = await _signatureController.toPngBytes();
      if (image != null) {
        await ImageGallerySaver.saveImage(image);
        Navigator.pop(context, image);
      }
    }
  }
}
