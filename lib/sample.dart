// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:screenshot/screenshot.dart';

// class Sample extends StatefulWidget {
//   const Sample({super.key});

//   @override
//   State<Sample> createState() => _SampleState();
// }

// class _SampleState extends State<Sample> {
//   ScreenshotController _screenshotController = ScreenshotController();

//   // void saveToGallery(BuildContext context) {
  //   _screenshotController.capture().then((Uint8List? image) {
  //     //it will capture the ss
  //     if (image != null) {
  //       saveImage(image); // to save image to gallery ...
  //     } else {
  //       print('Error: Captured image is null.');
  //     }
  //   }).catchError((e) => print('Error capturing screenshot: $e'));
  // }

  // Future<void> saveImage(Uint8List bytes) async {
  //   final time = DateTime.now()
  //       .toIso8601String()
  //       .replaceAll('.', '-')
  //       .replaceAll(':', '-');

  //   final name = "screenshot_$time"; //file name of image
  //   await requestPermission(Permission
  //       .storage); //to save we need permission for that i asked for permission
  //   await ImageGallerySaver.saveImage(bytes, name: name);
  //   print('Image Saved');
  // }

  // Future<bool> requestPermission(Permission permission) async {
  //   if (await permission.isGranted) {
  //     return true;
  //   } else {
  //     var result = await permission.request();
  //     if (result == PermissionStatus.granted) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }

//   @override
//   Widget build(BuildContext context) {
//     ScreenshotController _screenshotController = ScreenshotController();
//     // i  need this context so i passed in the function ..
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Center(
//             child: Screenshot(
//               controller: _screenshotController,
//               child: Container(
//                 width: 300,
//                 height: 300,
//                 color: Colors.green,
//                 child: const Center(
//                   child: Text(
//                     'Hello World!',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 30,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           saveToGallery(context);
//         },
//         child: const Icon(
//           Icons.screenshot,
//         ),
//       ),
//     );
//   }
// }
// void saveToGallery(BuildContext context) {
//     _screenshotController.captureAsUiImage().then((image) {
//       //_screenshotController.capture().then((Uint8List? image) {
//       //it will capture the ss
//       if (image != null) {
//         saveImage(image); // to save image to gallery ...
//       } else {
//         print('Error: Captured image is null.');
//       }
//     }).catchError((e) => print('Error capturing screenshot: $e'));
//   }

//   Future<void> saveImage(bytes) async {
//     final time = DateTime.now()
//         .toIso8601String()
//         .replaceAll('.', '-')
//         .replaceAll(':', '-');

//     final name = "screenshot_$time"; //file name of image
//     await requestPermission(Permission
//         .storage); //to save we need permission for that i asked for permission
//     await ImageGallerySaver.saveImage(bytes, name: name);
//     print('Image Saved');
//   }

//   Future<bool> requestPermission(Permission permission) async {
//     if (await permission.isGranted) {
//       return true;
//     } else {
//       var result = await permission.request();
//       if (result == PermissionStatus.granted) {
//         return true;
//       }
//     }
//     return false;
//   }














// /*
// <=========================Sample 2======================>
//  Future<String> saveImageToSpecific(BuildContext context) async {
//     try {
//       final directory = await getApplicationDocumentsDirectory();
//       final String path = directory.path;
//       //final String fileName = DateTime.now().microsecondsSinceEpoch.toString();

//       // Assuming screenshotController is an instance of ScreenshotController
//       await _screenshotController.captureAndSave(
//         '$path/file.png',
//       );
//       print('success');
//       return 'success';
//       // Rest of your code...
//     } catch (error) {
//       // Handle any errors that might occur during the process
//       print('Error: $error');
//       return 'error';
//     }
//   }*/