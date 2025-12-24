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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('modify_category'),
      ),
      body: Column(
        children: [
          Image.network(widget.gallery.url, width: 100, height: 100),
          // TODO: add actual category list
          // TODO: add update selected category button
          // TODO: add the above process in the service
          Row(
            children: [
              Checkbox(
                value: true,
                onChanged: (bool? check) {
                  print(check);
                },
              ),
              Text(' ${widget.gallery.url.split('/')[8]}'),
            ],
          ),
        ],
      ),
    );
  }
}
