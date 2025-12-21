import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wo_read/common/success_dialog.dart';
import 'package:wo_read/record/controllers/add_record_controller.dart';

class AddRecordPage extends StatefulWidget {
  const AddRecordPage({super.key});

  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  final formKey = GlobalKey<FormState>();
  final AddRecordController _controller = AddRecordController();

  @override
  dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _saveRecord() async {
    final bool success = await _controller.saveRecord();

    if (success && mounted) {
      await showSuccessDialog(context: context, content: '記録が追加されたよ');
    }
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
                initialDate: _controller.date,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (selectedDate != null) {
                setState(() {
                  _controller.date = selectedDate;
                });
              }
            },
            child: Text(formatter.format(_controller.date)),
          ),
          TextFormField(
            key: formKey,
            autofocus: true,
            controller: _controller.descriptionController,
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
