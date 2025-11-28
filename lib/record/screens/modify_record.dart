import 'package:flutter/material.dart';
import 'package:wo_read/record/models/record_item.dart';

import '../service/record_service.dart';

class ModifyRecordPage extends StatefulWidget {
  final RecordItem recordItem;

  const ModifyRecordPage({super.key, required this.recordItem});

  @override
  State<ModifyRecordPage> createState() => _ModifyRecordPageState();
}

class _ModifyRecordPageState extends State<ModifyRecordPage> {
  final formKey = GlobalKey<FormState>();
  late DateTime date;
  late RecordItem recordItem;
  late var descriptionController = TextEditingController();
  final RecordService recordService = RecordService();

  @override
  void initState() {
    super.initState();
    recordItem = widget.recordItem;
    descriptionController.text = recordItem.content;
    date = recordItem.date;
  }

  Future<void> _updateRecord() async {
    recordService.updateRecord(
      id: recordItem.id,
      date: date,
      content: descriptionController.text,
    );

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('記録が変更されたよ'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteRecord() async {
    recordService.deleteRecord(id: recordItem.id);

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('記録が削除されたよ'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modify record'),
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
            child: Text(date.toString()),
          ),
          TextFormField(
            key: formKey,
            controller: descriptionController,
            decoration: const InputDecoration(
              // icon: Icon(Icons.email),
              border: OutlineInputBorder(), // 外枠付きデザイン
              labelText: "content",
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _updateRecord,
                child: const Text('記録を変更'),
              ),
              ElevatedButton(
                onPressed: _deleteRecord,
                child: const Text('記録を削除', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
