import 'package:flutter/material.dart';
import 'package:wo_read/common/success_dialog.dart';
import 'package:wo_read/gallery/models/gallery_item.dart';
import 'package:wo_read/gallery/service/gallery_service.dart';

import '../../common/action_indicator.dart';

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
    final Map<String, bool> selectedCategoriesResponse = await galleryService
        .getSelectedCategories(widget.gallery.id);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('modify_category'),
      ),
      body: selectedCategories == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _imageSample(widget.gallery.url),
                _categoryCheckBoxes(selectedCategories!),
                _updateCategoryButton(),
              ],
            ),
    );
  }

  Widget _imageSample(String galleryUrl) {
    return Column(
      children: [
        Image.network(galleryUrl, width: 100, height: 100),
        Text('Name: ${galleryUrl.split('/')[8]}'),
      ],
    );
  }

  Widget _categoryCheckBoxes(Map<String, bool> selectedCategories) {
    return Column(
      children: selectedCategories.entries
          .map(
            (entry) => Row(
              children: [
                Checkbox(
                  value: entry.value, // Get the boolean value
                  onChanged: (bool? check) {
                    setState(() {
                      selectedCategories[entry.key] = check ?? false;
                    });
                  },
                ),
                Text(entry.key), // Get the category name
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _updateCategoryButton() {
    return ElevatedButton(
      onPressed: () {
        showActionIndicator(context, _updateCategories());
      },
      child: const Text('変更'),
    );
  }
}
