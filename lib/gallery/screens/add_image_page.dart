// ref: https://qiita.com/free-coder/items/b3338b5eff1d3f869360

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wo_read/common/action_indicator.dart';
import 'package:wo_read/common/app_theme.dart';
import 'package:wo_read/common/success_dialog.dart';
import 'package:wo_read/gallery/controllers/add_image_controller.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _handlePickImage());
  }

  Future<void> _handlePickImage() async {
    await _controller.pickImage();
    if (mounted) setState(() {});
  }

  Future<void> _handleSave() async {
    final success = await _controller.saveImage();
    if (success && mounted) {
      await showSuccessDialog(context: context, content: '画像が追加されたよ');
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('画像を追加')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ギャラリーに残したい写真を選んで保存します。',
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: AppColors.outline),
            ),
            const SizedBox(height: 20),
            _ImagePreviewCard(imagePath: _controller.image?.path),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: _handlePickImage,
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('画像を選択'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                onPressed: _controller.image == null
                    ? null
                    : () => showActionIndicator(context, _handleSave()),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('画像を保存'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePreviewCard extends StatelessWidget {
  final String? imagePath;

  const _ImagePreviewCard({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: imagePath == null
            ? const _EmptyImagePreview()
            : Image.file(File(imagePath!), fit: BoxFit.cover),
      ),
    );
  }
}

class _EmptyImagePreview extends StatelessWidget {
  const _EmptyImagePreview();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate_outlined,
          size: 48,
          color: AppColors.outlineVariant,
        ),
        SizedBox(height: 8),
        Text(
          '画像を選択',
          style: TextStyle(
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
