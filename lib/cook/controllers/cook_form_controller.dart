import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import 'package:wo_read/cook/models/cook_item.dart';
import '../service/cook_service.dart';

class CookFormController {
  final CookItem? initialItem;
  XFile? image;
  bool isProcessing = false;

  late DateTime date;
  late CookCategory category;
  String? initialImageUrl;

  final ImagePicker _imagePicker = ImagePicker();
  final CookService _cookService = CookService();

  CookFormController({this.initialItem}) {
    date = initialItem?.date ?? DateTime.now();
    category = initialItem?.category ?? CookCategory.box;
    initialImageUrl = initialItem?.imageUrl;
  }

  bool get isEditMode => initialItem != null;

  bool get canSave =>
      (image != null || initialImageUrl != null) && !isProcessing;

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

  Future<void> rotateImage() async {
    if (image == null && initialImageUrl != null) {
      isProcessing = true; // 処理開始
      try {
        final response = await http.get(Uri.parse(initialImageUrl!));
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/temp_image.jpg');
        await file.writeAsBytes(response.bodyBytes);
        image = XFile(file.path);
      } catch (e) {
        return;
      }
    }

    if (image == null) return;

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

  Future<bool> submit() async {
    if (!canSave) return false;
    isProcessing = true;

    try {
      if (isEditMode) {
        await _cookService.updateCook(
          initialItem!.id,
          image?.path,
          category,
          date,
        );
      } else {
        await _cookService.addCook(image!.path, category, date);
      }
      return true;
    } catch (e) {
      return false;
    } finally {
      isProcessing = false;
    }
  }

  Future<bool> delete() async {
    if (!isEditMode) return false;
    isProcessing = true;

    try {
      await _cookService.deleteCook(initialItem!.id);
      return true;
    } catch (e) {
      return false;
    } finally {
      isProcessing = false;
    }
  }
}
