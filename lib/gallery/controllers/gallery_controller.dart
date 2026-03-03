import 'package:wo_read/gallery/models/gallery_item.dart';
import 'package:wo_read/gallery/service/gallery_service.dart';

class GalleryController {
  final GalleryService _galleryService = GalleryService();

  GalleryController();

  Future<List<GalleryItem>> getGalleries() async {
    late List<GalleryItem> galleries;

    try {
      galleries = await _galleryService.getGalleryUrls();
    } catch (e) {
      return galleries;
    }
    return galleries;
  }
}