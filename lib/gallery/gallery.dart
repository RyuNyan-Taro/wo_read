import 'package:flutter/material.dart';
import 'package:wo_read/gallery/service/gallery_service.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<String>? galleries;

  @override
  void initState() {
    super.initState();

    if (galleries == null) {
      _getGalleries();
    }
  }

  Future<void> _getGalleries() async {
    final GalleryService galleryService = GalleryService();
    final List<String> items = await galleryService.getGalleryUrls();

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
          : Column(
              // TODO: show image from url
              // TODO: add category modify page when tap the image
              children: galleries!.map((gallery) => Text(gallery)).toList(),
            ),
    );
  }
}
