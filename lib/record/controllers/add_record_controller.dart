import 'package:flutter/cupertino.dart';
import 'package:wo_read/record/models/record_item.dart';
import 'package:wo_read/record/service/label_service.dart';
import 'package:wo_read/record/service/record_service.dart';

class AddRecordController {
  final _descriptionController = TextEditingController();
  final RecordService _recordService = RecordService();
  final LabelService _labelService = LabelService();

  late DateTime date;

  AddRecordController() {
    date = DateTime.now();
  }

  void dispose() {
    _descriptionController.dispose();
  }

  Future<bool> saveRecord() async {
    late LabelResult labels;
    try {
      labels = await _labelService.getLabels(_descriptionController.text);
    } catch (e) {
      labels = LabelResult(
        status: ResponseStatus.unknown,
        feeling: FeelingType.none,
        denver: DenverType.none,
      );
    }

    try {
      await _recordService.addRecord(
        date: date,
        content: _descriptionController.text,
        labels: labels,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
