// ref: https://qiita.com/free-coder/items/b3338b5eff1d3f869360

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddImagePage extends StatefulWidget {
  const AddImagePage({super.key});

  @override
  State<AddImagePage> createState() => _AddImagePageState();
}

class _AddImagePageState extends State<AddImagePage> {
  XFile? image;
  final imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemp = XFile(image.path);

    setState(() => this.image = imageTemp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add image'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Center(
            child: image == null
                ? const Text('画像が選択されていません')
                : Image.file(File(image!.path)),
          ),
          ElevatedButton(
            onPressed: () {
              _pickImage();
            },
            child: Text("画像を選択"),
          ),
        ],
      ),
    );
  }
}
