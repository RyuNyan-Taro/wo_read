import 'package:flutter/material.dart';
import 'package:wo_read/gallery/models/gallery_item.dart';
import 'package:wo_read/gallery/screens/modify_category.dart';
import 'package:wo_read/gallery/service/gallery_service.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<GalleryItem>? galleries;

  @override
  void initState() {
    super.initState();

    if (galleries == null) {
      _getGalleries();
    }
  }

  Future<void> _getGalleries() async {
    final GalleryService galleryService = GalleryService();
    final List<GalleryItem> items = await galleryService.getGalleryUrls();

    setState(() {
      galleries = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('gallery'),
      ),
      body: galleries == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: galleries!
                    .map(
                      (gallery) => InkWell(
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return ModifyCategoryPage(gallery: gallery);
                              },
                            ),
                          );
                        },
                        child: Image.network(gallery.url),
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }
}
