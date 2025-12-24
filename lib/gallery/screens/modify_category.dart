import 'package:flutter/material.dart';
import 'package:wo_read/gallery/models/gallery_item.dart';

class ModifyCategoryPage extends StatefulWidget {
  final GalleryItem gallery;
  const ModifyCategoryPage({super.key, required this.gallery});

  @override
  State<ModifyCategoryPage> createState() => _ModifyCategoryPageState();
}

class _ModifyCategoryPageState extends State<ModifyCategoryPage> {
  @override
  // TODO: add category modify page when tap the image
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('modify_category'),
      ),
      body: Column(
        children: [Image.network(widget.gallery.url, width: 100, height: 100)],
      ),
    );
  }
}
