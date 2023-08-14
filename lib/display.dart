import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Display extends StatefulWidget {
  const Display({super.key});

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  File? _image;

  Future _takePicture() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Snapping'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('No image selected.')
                : Image.file(_image!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _takePicture,
              child: Text('Take Picture'),
            ),
          ],
        ),
      ),
    );
  }
}