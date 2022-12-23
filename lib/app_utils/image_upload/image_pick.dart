// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:veridox/app_services/database/uploader.dart';
//
// class ImagePick {
//   // static final ImagePicker _picker = ImagePicker();
//   static Future<UploadTask?> pickAndUploadSingleImageFromCamera(
//       XFile file, String dbPath) async {
//     // return await _picker
//     //     .pickImage(
//     //         source: ImageSource.camera,
//     //         preferredCameraDevice: CameraDevice.rear)
//     //     .then((file) async {
//     return await FileUploader.uploadSingleImage(file, dbPath);
//     // }
//     // );
//   }
//
//   static Future<List<UploadTask?>> pickAndUploadMultipleImageFromGallery(
//       String dbPath, List<XFile?> files) async {
//     // return
//     // await _picker.pickMultiImage().then((files) {
//     List<UploadTask?> list = [];
//     int i = 0;
//     for (var file in files) {
//       UploadTask? task =
//           await FileUploader.uploadSingleImage(file, '$dbPath$i');
//       list.add(task);
//       i++;
//     }
//     return list;
//     // }
//     //);
//   }
// }
