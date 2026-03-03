import 'package:image_picker/image_picker.dart';

import '../service/gallery_service.dart';

class AddImageController {
  XFile? image;
  final ImagePicker _imagePicker = ImagePicker();
  final GalleryService _galleryService = GalleryService();

  AddImageController();

  Future<void> pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    image = XFile(pickedFile.path);
  }

  Future<bool> saveImage() async {
    if (image == null) return false;

    try {
      await _galleryService.addImage(image!.path);
      return true;
    } catch (e) {
      return false;
    }
  }
}