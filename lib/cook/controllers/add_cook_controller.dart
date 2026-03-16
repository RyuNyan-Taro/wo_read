import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import 'package:wo_read/cook/models/cook_item.dart';
import '../service/cook_service.dart';

class AddCookController {
  XFile? image;
  bool isProcessing = false;
  final ImagePicker _imagePicker = ImagePicker();
  final CookService _cookService = CookService();

  late DateTime date;
  late CookCategory category;

  bool get canSave => image != null && !isProcessing;

  AddCookController() {
    date = DateTime.now();
    category = CookCategory.box;
  }

  Future<void> pickImage() async {
    isProcessing = true;
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        image = XFile(pickedFile.path);
      }
    } finally {
      isProcessing = false;
    }
  }

  Future<bool> saveCook() async {
    if (image == null) return false;

    try {
      await _cookService.addCook(image!.path, category, date);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> rotateImage() async {
    if (image == null || isProcessing) return;

    isProcessing = true;
    try {
      final bytes = await File(image!.path).readAsBytes();
      img.Image? originalImage = img.decodeImage(bytes);
      if (originalImage == null) return;

      img.Image rotatedImage = img.copyRotate(originalImage, angle: 90);

      final tempDir = await getTemporaryDirectory();
      final path =
          '${tempDir.path}/rotated_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final rotatedBytes = img.encodeJpg(rotatedImage);
      final rotatedFile = await File(path).writeAsBytes(rotatedBytes);

      image = XFile(rotatedFile.path);
    } finally {
      isProcessing = false;
    }
  }
}
