import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wo_read/common/success_dialog.dart';
import 'package:wo_read/record/service/record_service.dart';

class AddRecordPage extends StatefulWidget {
  const AddRecordPage({super.key});

  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  DateTime date = DateTime.now();
  final formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final RecordService recordService = RecordService();

  Future<void> _saveRecord() async {
    recordService.addRecord(date: date, content: descriptionController.text);

    if (!mounted) return;

    await showSuccessDialog(context: context, content: '記録が追加されたよ');
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MM/dd');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add record'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (selectedDate != null) {
                setState(() {
                  date = selectedDate;
                });
              }
            },
            child: Text(formatter.format(date)),
          ),
          TextFormField(
            key: formKey,
            autofocus: true,
            controller: descriptionController,
            decoration: const InputDecoration(
              // icon: Icon(Icons.email),
              border: OutlineInputBorder(), // 外枠付きデザイン
              labelText: "content",
            ),
          ),
          ElevatedButton(onPressed: _saveRecord, child: const Text('追加')),
        ],
      ),
    );
  }
}
