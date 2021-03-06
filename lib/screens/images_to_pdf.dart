import 'dart:io';

import 'package:EasyScan/Utils/methods.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageToPdf extends StatefulWidget {
  @override
  _ImageToPdfState createState() => _ImageToPdfState();
}

class _ImageToPdfState extends State<ImageToPdf> {
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  Future getImageFromGallery() async {
    final PickedFile pickedFile =
        await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null && pickedFile.path != "") {
      if (_cropImage) {
        cropImage(pickedFile.path, (path) {
          addImage(path);
        });
      } else {
        addImage(pickedFile.path);
      }
    }
  }

  void addImage(String path) => setState(() {
        _images.add(File(path));
      });
  bool _cropImage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: getImageFromGallery,
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Add image'),
      ),
      appBar: AppBar(
        title: const Text('Choose Image'),
      ),
      body: Column(
        children: [
          CheckboxListTile(
              title: const Text('Crop Image'),
              value: _cropImage,
              onChanged: (crop) {
                setState(() {
                  _cropImage = crop;
                });
              }),
          Expanded(child: _buildImageList(context)),
        ],
      ),
    );
  }

  Widget _buildImageList(BuildContext context) {
    if (_images.isEmpty) {
      return const Center(
        child: Text('Insert a Image'),
      );
    }
    return GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: _images.length,
        itemBuilder: (context, index) {
          return Card(
            child: Image.file(
              _images[index],
              fit: BoxFit.cover,
            ),
          );
        });
  }
}
