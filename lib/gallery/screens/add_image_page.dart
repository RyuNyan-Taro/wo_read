// ref: https://qiita.com/free-coder/items/b3338b5eff1d3f869360

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wo_read/common/action_indicator.dart';
import 'package:wo_read/common/success_dialog.dart';
import 'package:wo_read/gallery/controllers/add_image_controller.dart';
import 'package:wo_read/gallery/service/gallery_service.dart';

class AddImagePage extends StatefulWidget {
  const AddImagePage({super.key});

  @override
  State<AddImagePage> createState() => _AddImagePageState();
}

class _AddImagePageState extends State<AddImagePage> {
  final AddImageController _controller = AddImageController();

  @override
  void initState() {
    super.initState();
    _controller.pickImage();
  }

  Future<void> _handleSave() async {
    final success = await _controller.saveImage();
    if (success && mounted) {
      await showSuccessDialog(context: context, content: '画像が追加されたよ');
    }
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
            child: SizedBox(
              height: 300,
              child: Image.file(
                File(_controller.image!.path),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await _controller.pickImage();
              setState(() {});
            },
            child: const Text('画像を選択'),
          ),
          ElevatedButton(
            onPressed: _handleSave,
            child: const Text('画像を保存'),
          ),
        ],
      ),
    );
  }
}
