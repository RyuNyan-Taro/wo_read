import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wo_read/gallery/models/gallery_item.dart';
import 'package:wo_read/gallery/screens/add_category_button.dart';
import 'package:wo_read/gallery/screens/add_image_button.dart';
import 'package:wo_read/gallery/screens/modify_category.dart';
import 'package:wo_read/gallery/service/gallery_service.dart';

class GalleryBody extends StatefulWidget {
  const GalleryBody({super.key});

  @override
  State<GalleryBody> createState() => _GalleryBodyState();
}

class _GalleryBodyState extends State<GalleryBody> {
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
    return Stack(
      children: [
        galleries == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(children: _galleriesList(galleries!)),
              ),
        Positioned(
          left: 16,
          bottom: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              addImageButton(context: context, returnAction: _getGalleries),
              const SizedBox(height: 12),
              addCategoryButton(context: context, returnAction: _getGalleries),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _galleriesList(List<GalleryItem> galleries) {
    return galleries
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
            child: CachedNetworkImage(
              imageUrl: gallery.url,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
            ),
          ),
        )
        .toList();
  }
}
