import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  String coordinate = '';
  String latitide = '';
  String longitude = '';
  XFile? selectedImage;
  Future<void> _openCamera() async {
    final PermissionStatus cameraStatus = await Permission.camera.request();

    if (cameraStatus.isGranted) {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      if (image != null) {
        setState(() {
          selectedImage = image;
        });
      }
    } else if (cameraStatus.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Camera permission is denied.'),
      ));
    } else if (cameraStatus.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Camera permission is permanently denied. Open app settings to enable it.'),
      ));
      openAppSettings();
    }
  }

  Future<void> _getLocation() async {
    final PermissionStatus locationStatus = await Permission.location.request();
    if (locationStatus.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        coordinate = position.toString();
        latitide = position.latitude.toString();
        longitude = position.longitude.toString();
      });
      // return position;
    }
    if (locationStatus.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Location is recommended for effective performance'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
             selectedImage != null
                ? Image.file(
                    File(selectedImage!.path),
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : Container(),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Center(
                child: GestureDetector(
                    onTap: _openCamera,
                    child: const CircleAvatar(
                      child: Icon(Icons.camera),
                    )),
              ),
              Center(
                child: GestureDetector(
                    onTap: _getLocation,
                    child: const CircleAvatar(
                      child: Icon(Icons.my_location),
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(coordinate,
                  style: const TextStyle(fontSize: 18, color: Colors.orange)),
              const SizedBox(
                height: 15,
              ),
              Text(latitide,
                  style: const TextStyle(fontSize: 18, color: Colors.orange)),
              const SizedBox(
                height: 15,
              ),
              Text(longitude,
                  style: const TextStyle(fontSize: 18, color: Colors.orange)),
            ]),
          ],
        ),
      ),
    );
  }
}












// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

// class Camera extends StatefulWidget {
//   const Camera({Key? key}) : super(key: key);

//   @override
//   State<Camera> createState() => _CameraState();
// }

// class _CameraState extends State<Camera> {
//   File? imageFile;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select & Crop Image'),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 20.0,
//             ),
//             imageFile == null
//                 ? Image.asset(
//                     'assets/flutter-image.jpg',
//                     height: 300.0,
//                     width: 300.0,
//                   )
//                 : ClipRRect(
//                     borderRadius: BorderRadius.circular(150.0),
//                     child: Image.file(
//                       imageFile!,
//                       height: 300.0,
//                       width: 300.0,
//                       fit: BoxFit.fill,
//                     )),
//             const SizedBox(
//               height: 20.0,
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 Map<Permission, PermissionStatus> statuses = await [
//                   Permission.storage,
//                   Permission.camera,
//                 ].request();
//                 if (statuses[Permission.storage]!.isGranted &&
//                     statuses[Permission.camera]!.isGranted) {
//                   showImagePicker(context);
//                 } else {
//                   print('no permission provided');
//                 }
//               },
//               child: Text('Select Image'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   final picker = ImagePicker();

//   void showImagePicker(BuildContext context) {
//     showModalBottomSheet(
//         context: context,
//         builder: (builder) {
//           return Card(
//             child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height / 5.2,
//                 margin: const EdgeInsets.only(top: 8.0),
//                 padding: const EdgeInsets.all(12),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Expanded(
//                         child: InkWell(
//                       child: Column(
//                         children: const [
//                           Icon(
//                             Icons.image,
//                             size: 60.0,
//                           ),
//                           SizedBox(height: 12.0),
//                           Text(
//                             "Gallery",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(fontSize: 16, color: Colors.black),
//                           )
//                         ],
//                       ),
//                       onTap: () {
//                         _imgFromGallery();
//                         Navigator.pop(context);
//                       },
//                     )),
//                     Expanded(
//                         child: InkWell(
//                       child: SizedBox(
//                         child: Column(
//                           children: const [
//                             Icon(
//                               Icons.camera_alt,
//                               size: 60.0,
//                             ),
//                             SizedBox(height: 12.0),
//                             Text(
//                               "Camera",
//                               textAlign: TextAlign.center,
//                               style:
//                                   TextStyle(fontSize: 16, color: Colors.black),
//                             )
//                           ],
//                         ),
//                       ),
//                       onTap: () {
//                         _imgFromCamera();
//                         Navigator.pop(context);
//                       },
//                     ))
//                   ],
//                 )),
//           );
//         });
//   }

//   _imgFromGallery() async {
//     await picker
//         .pickImage(source: ImageSource.gallery, imageQuality: 50)
//         .then((value) {
//       if (value != null) {
//         _cropImage(File(value.path));
//       }
//     });
//   }

//   _imgFromCamera() async {
//     await picker
//         .pickImage(source: ImageSource.camera, imageQuality: 50)
//         .then((value) {
//       if (value != null) {
//         _cropImage(File(value.path));
//       }
//     });
//   }

//   _cropImage(File imgFile) async {
//     final croppedFile = await ImageCropper().cropImage(
//         sourcePath: imgFile.path,
//         aspectRatioPresets: Platform.isAndroid
//             ? [
//                 CropAspectRatioPreset.square,
//                 CropAspectRatioPreset.ratio3x2,
//                 CropAspectRatioPreset.original,
//                 CropAspectRatioPreset.ratio4x3,
//                 CropAspectRatioPreset.ratio16x9
//               ]
//             : [
//                 CropAspectRatioPreset.original,
//                 CropAspectRatioPreset.square,
//                 CropAspectRatioPreset.ratio3x2,
//                 CropAspectRatioPreset.ratio4x3,
//                 CropAspectRatioPreset.ratio5x3,
//                 CropAspectRatioPreset.ratio5x4,
//                 CropAspectRatioPreset.ratio7x5,
//                 CropAspectRatioPreset.ratio16x9
//               ],
//         uiSettings: [
//           AndroidUiSettings(
//               toolbarTitle: "Image Cropper",
//               toolbarColor: Colors.deepOrange,
//               toolbarWidgetColor: Colors.white,
//               initAspectRatio: CropAspectRatioPreset.original,
//               lockAspectRatio: false),
//           IOSUiSettings(
//             title: "Image Cropper",
//           )
//         ]);
//     if (croppedFile != null) {
//       imageCache.clear();
//       setState(() {
//         imageFile = File(croppedFile.path);
//       });
//       // reload();
//     }
//   }
// }
