import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wo_read/common/action_indicator.dart';
import 'package:wo_read/common/app_theme.dart';
import 'package:wo_read/common/success_dialog.dart';
import 'package:wo_read/gallery/models/gallery_item.dart';
import 'package:wo_read/gallery/service/gallery_service.dart';

class ModifyCategoryPage extends StatefulWidget {
  final GalleryItem gallery;

  const ModifyCategoryPage({super.key, required this.gallery});

  @override
  State<ModifyCategoryPage> createState() => _ModifyCategoryPageState();
}

class _ModifyCategoryPageState extends State<ModifyCategoryPage> {
  Map<String, bool>? selectedCategories;
  final GalleryService galleryService = GalleryService();

  @override
  void initState() {
    super.initState();

    if (selectedCategories == null) {
      _getCategories();
    }
  }

  Future<void> _getCategories() async {
    final Map<String, bool> selectedCategoriesResponse =
        await galleryService.getSelectedCategories(widget.gallery.id);
    setState(() {
      selectedCategories = selectedCategoriesResponse;
    });
  }

  Future<void> _updateCategories() async {
    await galleryService.updateCategories(
      selectedCategories!,
      widget.gallery.id,
    );
    if (mounted) {
      await showSuccessDialog(context: context, content: '更新されたよ');
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('カテゴリーを変更')),
      body: selectedCategories == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'この写真に関連するカテゴリーを選択します。',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: AppColors.outline),
                  ),
                  const SizedBox(height: 20),
                  _ImagePreviewCard(url: widget.gallery.url),
                  const SizedBox(height: 20),
                  _CategoryCheckboxCard(
                    selectedCategories: selectedCategories!,
                    onChanged: (key, value) {
                      setState(() {
                        selectedCategories![key] = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton.icon(
                      onPressed: () {
                        showActionIndicator(context, _updateCategories());
                      },
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('変更を保存'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _ImagePreviewCard extends StatelessWidget {
  final String url;

  const _ImagePreviewCard({required this.url});

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
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.surfaceContainerHigh,
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.surfaceContainerHigh,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.no_photography,
                  size: 32,
                  color: AppColors.outlineVariant,
                ),
                SizedBox(height: 4),
                Text(
                  '写真なし',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryCheckboxCard extends StatelessWidget {
  final Map<String, bool> selectedCategories;
  final void Function(String key, bool value) onChanged;

  const _CategoryCheckboxCard({
    required this.selectedCategories,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: selectedCategories.entries.map((entry) {
          return CheckboxListTile(
            title: Text(entry.key),
            value: entry.value,
            onChanged: (bool? value) {
              onChanged(entry.key, value ?? false);
            },
          );
        }).toList(),
      ),
    );
  }
}
