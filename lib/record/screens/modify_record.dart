import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wo_read/common/success_dialog.dart';
import 'package:wo_read/record/models/record_item.dart';
import 'package:wo_read/record/use_cases/convert_enum_use_case.dart';

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
  late FeelingType feeling;
  late DenverType denver;
  late var descriptionController = TextEditingController();
  final RecordService recordService = RecordService();

  @override
  void initState() {
    super.initState();
    recordItem = widget.recordItem;
    feeling = recordItem.feeling;
    denver = recordItem.denver;
    descriptionController.text = recordItem.content;
    date = recordItem.date;
  }

  Future<void> _updateRecord() async {
    recordService.updateRecord(
      id: recordItem.id,
      date: date,
      content: descriptionController.text,
      feeling: feeling,
      denver: denver,
    );

    if (!mounted) return;

    await showSuccessDialog(context: context, content: '記録が変更されたよ');
  }

  Future<void> _deleteRecord() async {
    recordService.deleteRecord(id: recordItem.id);

    if (!mounted) return;

    await showSuccessDialog(context: context, content: '記録が削除されたよ');
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MM/dd');

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
            child: Text(formatter.format(date)),
          ),
          Row(
            children: [
              DropdownButton(
                value: feeling.name,
                items: FeelingType.values
                    .map(
                      (feeling) => DropdownMenuItem(
                        value: feeling.name,
                        child: Text(feelingToJp[feeling]!),
                      ),
                    )
                    .toList(),
                onChanged: (String? newValue) {
                  // Handle the change
                  if (newValue != null) {
                    setState(() {
                      feeling = convertToFeelingType(label: newValue);
                    });
                  }
                },
              ),
              // TODO: add denver and feeling to update contents
              DropdownButton(
                value: denver.name,
                items: DenverType.values
                    .map(
                      (denver) => DropdownMenuItem(
                        value: denver.name,
                        child: Text(denverToJp[denver]!),
                      ),
                    )
                    .toList(),
                onChanged: (String? newValue) {
                  // Handle the change
                  if (newValue != null) {
                    setState(() {
                      denver = convertToDenverType(label: newValue);
                    });
                  }
                },
              ),
            ],
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
              ElevatedButton(onPressed: _updateRecord, child: const Text('変更')),
              ElevatedButton(
                onPressed: _deleteRecord,
                child: const Text('削除', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
