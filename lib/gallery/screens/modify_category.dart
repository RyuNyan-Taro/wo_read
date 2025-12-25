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
  List<String>? categories;
  final GalleryService galleryService = GalleryService();

  @override
  void initState() {
    super.initState();

    if (categories == null) {
      _getCategories();
    }
  }

  Future<void> _getCategories() async {
    final List<String> setCategories = await galleryService.getCategories();
    setState(() {
      categories = setCategories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('modify_category'),
      ),
      body: categories == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children:
                  [
                    Image.network(widget.gallery.url, width: 100, height: 100),
                    // TODO: add actual category list
                    // TODO: add update selected category button
                    // TODO: add the above process in the service
                    Text('Name: ${widget.gallery.url.split('/')[8]}'),
                  ] +
                  categories!
                      .map(
                        (category) => Row(
                          children: [
                            Checkbox(
                              value: true,
                              onChanged: (bool? check) {
                                print(check);
                              },
                            ),
                            Text(category),
                          ],
                        ),
                      )
                      .toList(),
            ),
    );
  }
}
