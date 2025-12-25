import 'package:flutter/material.dart';
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
    final Map<String, bool> selectedCategoriesResponse = await galleryService
        .getSelectedCategories(widget.gallery.id);
    setState(() async {
      selectedCategories = selectedCategoriesResponse;
    });
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
              children:
                  [
                    Image.network(widget.gallery.url, width: 100, height: 100),
                    Text('Name: ${widget.gallery.url.split('/')[8]}'),
                  ] +
                  (selectedCategories?.entries
                          .map(
                            (entry) => Row(
                              children: [
                                Checkbox(
                                  value: entry.value, // Get the boolean value
                                  onChanged: (bool? check) {
                                    setState(() {
                                      selectedCategories![entry.key] =
                                          check ?? false;
                                    });
                                  },
                                ),
                                Text(entry.key), // Get the category name
                              ],
                            ),
                          )
                          .toList() ??
                      []),
            ),
    );
  }
}
