import 'package:flutter/cupertino.dart';
import 'package:wo_read/record/models/record_item.dart';
import 'package:wo_read/record/service/label_service.dart';
import 'package:wo_read/record/service/record_service.dart';

class ModifyRecordController {
  final RecordItem originalItem;
  final RecordService _recordService = RecordService();
  final LabelService _labelService = LabelService();

  late DateTime date;
  late FeelingType feeling;
  late DenverType denver;
  final TextEditingController descriptionController = TextEditingController();

  ModifyRecordController({required this.originalItem}) {
    date = originalItem.date;
    feeling = originalItem.feeling;
    denver = originalItem.denver;
    descriptionController.text = originalItem.content;
  }

  void dispose() {
    descriptionController.dispose();
  }

  Future<bool> updateRecord() async {
    try {
      await _recordService.updateRecord(
        id: originalItem.id,
        date: date,
        content: descriptionController.text,
        feeling: feeling,
        denver: denver,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
