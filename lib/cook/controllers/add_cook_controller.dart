import 'package:image_picker/image_picker.dart';
import 'package:wo_read/cook/models/cook_item.dart';

import '../service/cook_service.dart';

class AddCookController {
  XFile? image;
  final ImagePicker _imagePicker = ImagePicker();
  final CookService _cookService = CookService();

  late DateTime date;
  late CookCategory category;

  AddCookController() {
    date = DateTime.now();
    category = CookCategory.box;
  }

  Future<void> pickImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;
    image = XFile(pickedFile.path);
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
}
