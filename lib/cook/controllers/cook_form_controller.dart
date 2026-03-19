import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import 'package:wo_read/cook/models/cook_item.dart';
import '../service/cook_service.dart';
import '../service/ai_service.dart';

class CookFormController {
  final CookItem? initialItem;
  XFile? image;
  bool isProcessing = false;
  String? aiComment;

  late DateTime date;
  late CookCategory category;
  String? initialImageUrl;

  final ImagePicker _imagePicker = ImagePicker();
  final CookService _cookService = CookService();
  final AiService _aiService = AiService();

  CookFormController({this.initialItem}) {
    date = initialItem?.date ?? DateTime.now();
    category = initialItem?.category ?? CookCategory.box;
    initialImageUrl = initialItem?.imageUrl;
    aiComment = initialItem?.aiComment;
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

  Future<void> rotateImage({bool isRight = true}) async {
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

      final int angle = isRight ? 90 : -90;
      img.Image rotatedImage = img.copyRotate(originalImage, angle: angle);

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
          aiComment,
        );
      } else {
        aiComment = await _aiService.getAiCommentFromImage(
          imageBytes: await File(image!.path).readAsBytes(),
        );
        await _cookService.addCook(image!.path, category, date, aiComment);
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

  Future<void> generateAiComment() async {
    if (image == null && initialImageUrl == null) {
      debugPrint('画像ソースがありません');
      return;
    }

    isProcessing = true;

    try {
      Uint8List imageBytes;
      if (image != null) {
        imageBytes = await File(image!.path).readAsBytes();
      } else {
        final response = await http.get(Uri.parse(initialImageUrl!));
        if (response.statusCode == 200) {
          imageBytes = response.bodyBytes;
        } else {
          throw Exception('画像のダウンロードに失敗しました');
        }
      }

      final result = await _aiService.getAiCommentFromImage(
        imageBytes: imageBytes,
      );

      if (result != null) {
        aiComment = result;
      }
    } catch (e) {
      debugPrint('AIコメント生成中にエラーが発生しました: $e');
    } finally {
      isProcessing = false;
    }
  }
}
