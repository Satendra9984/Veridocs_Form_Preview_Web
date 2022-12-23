import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerImageInput extends StatefulWidget {
  const ImagePickerImageInput({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<ImagePickerImageInput> createState() => _ImagePickerImageInputState();
}

class _ImagePickerImageInputState extends State<ImagePickerImageInput> {
  List<XFile>? _imageFileList;
  late BuildContext cont;
  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;
  bool isVideo = false;

  // VideoPlayerController? _controller;
  // VideoPlayerController? _toBeDisposed;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  // Future<void> _playVideo(XFile? file) async {
  //   if (file != null && mounted) {
  //     await _disposeVideoController();
  //     late VideoPlayerController controller;
  //     if (kIsWeb) {
  //       controller = VideoPlayerController.network(file.path);
  //     } else {
  //       controller = VideoPlayerController.file(File(file.path));
  //     }
  //     _controller = controller;
  //     const double volume = kIsWeb ? 0.0 : 1.0;
  //     await controller.setVolume(volume);
  //     await controller.initialize();
  //     await controller.setLooping(true);
  //     await controller.play();
  //     setState(() {});
  //   }
  // }

  Future<List<Uint8List>?> _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    List<Uint8List>? image = [];

    // if (_controller != null) {
    //   await _controller!.setVolume(0.0);
    // }
    if (isVideo) {
      final XFile? file = await _picker.pickVideo(
          source: source, maxDuration: const Duration(seconds: 10));
      // await _playVideo(file);
    } else if (isMultiImage) {
      try {
        final List<XFile>? pickedFileList = await _picker.pickMultiImage(
          maxWidth: null,
          maxHeight: null,
          imageQuality: 50,
        );

        if (kDebugMode) {
          print('path.........${pickedFileList?[0].path}');
        }

        if (pickedFileList != null) {
          for (int i = 0; i < pickedFileList.length; i++) {
            Uint8List f = await pickedFileList[i].readAsBytes();
            image.add(f);
          }
        }
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    } else {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: null,
          maxHeight: null,
          imageQuality: 50,
        );

        if (kDebugMode) {
          print('path.........${pickedFile?.path}');
        }
        File file = File(pickedFile!.path);
        image.add(await file.readAsBytes());
        file.deleteSync(recursive: true);
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    }
    return image;
  }

  @override
  void deactivate() {
    // if (_controller != null) {
    //   _controller!.setVolume(0.0);
    //   _controller!.pause();
    // }
    super.deactivate();
  }

  @override
  void dispose() {
    _disposeVideoController();
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Future<void> _disposeVideoController() async {
    // if (_toBeDisposed != null) {
    //   await _toBeDisposed!.dispose();
    // }
    // _toBeDisposed = _controller;
    // _controller = null;
  }

  // Widget _previewVideo() {
  //   final Text? retrieveError = _getRetrieveErrorWidget();
  //   if (retrieveError != null) {
  //     return retrieveError;
  //   }
  //   // if (_controller == null) {
  //   //   return const Text(
  //   //     'You have not yet picked a video',
  //   //     textAlign: TextAlign.center,
  //   //   );
  //   // }
  //   // return Padding(
  //     padding: const EdgeInsets.all(10.0),
  //     child: AspectRatioVideo(_controller),
  //   );
  // }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: ListView.builder(
          key: UniqueKey(),
          itemBuilder: (BuildContext context, int index) {
            // Why network for web?
            // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
            return Semantics(
              label: 'image_picker_example_picked_image',
              child: kIsWeb
                  ? Image.network(_imageFileList![index].path)
                  : Image.file(File(_imageFileList![index].path)),
            );
          },
          itemCount: _imageFileList!.length,
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _handlePreview() {
    if (isVideo) {
      return _previewImages();
    } else {
      return _previewImages();
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        isVideo = true;
        // await _playVideo(response.file);
      } else {
        isVideo = false;
        setState(() {
          if (response.files == null) {
            _setImageFileListFromFile(response.file);
          } else {
            _imageFileList = response.files;
          }
        });
      }
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  void justNavigatePop(XFile? imageFile) {
    Navigator.pop(cont, imageFile);
  }

  @override
  Widget build(BuildContext context) {
    cont = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
            ? FutureBuilder<void>(
                future: retrieveLostData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Text(
                        'You have not yet picked an image.',
                        textAlign: TextAlign.center,
                      );
                    case ConnectionState.done:
                      return _handlePreview();
                    default:
                      if (snapshot.hasError) {
                        return Text(
                          'Pick image/video error: ${snapshot.error}}',
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return const Text(
                          'You have not yet picked an image.',
                          textAlign: TextAlign.center,
                        );
                      }
                  }
                },
              )
            : _handlePreview(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Semantics(
            label: 'image_picker_example_from_gallery',
            child: FloatingActionButton(
              onPressed: () async {
                isVideo = false;
                await _onImageButtonPressed(ImageSource.camera,
                        context: context)
                    .then((value) {
                  debugPrint('list of length --> ${value?.length}');
                  Navigator.pop(context, value);
                });
              },
              heroTag: 'image0',
              tooltip: 'Pick Image from gallery',
              child: const Icon(Icons.camera),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              onPressed: () async {
                isVideo = false;
                _onImageButtonPressed(ImageSource.gallery,
                        context: context, isMultiImage: true)
                    .then((value) {
                  debugPrint('list of length --> ${value?.length}');

                  Navigator.pop(context, value);
                });
              },
              heroTag: 'image1',
              tooltip: 'Pick Multiple Image from gallery',
              child: const Icon(Icons.photo_library),
            ),
          ),
        ],
      ),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);
