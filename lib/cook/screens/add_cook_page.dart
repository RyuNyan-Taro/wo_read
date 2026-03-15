import 'dart:io';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:wo_read/common/success_dialog.dart';
import 'package:wo_read/cook/controllers/add_cook_controller.dart';
import 'package:wo_read/cook/models/cook_item.dart';

import '../../common/action_indicator.dart';
import '../use_cases/convert_enum_use_case.dart';

class AddCookPage extends StatefulWidget {
  const AddCookPage({super.key});

  @override
  State<AddCookPage> createState() => _AddCookPageState();
}

class _AddCookPageState extends State<AddCookPage> {
  final formatter = DateFormat('MM/dd');
  final AddCookController _controller = AddCookController();

  @override
  void initState() {
    super.initState();
    print('start');
    _controller.pickImage().then((_) {
      if (mounted) setState(() {});
    });
    print('picked');
  }

  Future<void> _handleSave() async {
    final success = await _controller.saveCook();
    if (success && mounted) {
      await showSuccessDialog(context: context, content: '記録が追加されたよ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add cook'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          DropdownButton(
            value: _controller.category.name,
            items: CookCategory.values
                .map(
                  (category) => DropdownMenuItem(
                    value: category.name,
                    child: Text(categoryToJp[category]!),
                  ),
                )
                .toList(),
            onChanged: (String? newValue) {
              // Handle the change
              if (newValue != null) {
                setState(() {
                  _controller.category = convertToCookCategory(label: newValue);
                });
              }
            },
          ),
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
          Center(
            child: SizedBox(
              height: 300,
              child: _controller.image != null
                  ? Image.file(File(_controller.image!.path), fit: BoxFit.cover)
                  : const Center(child: Text('画像が選択されていません')),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await _controller.pickImage();
              setState(() {});
            },
            child: const Text('画像を選択'),
          ),
          ElevatedButton(
            onPressed: () {
              showActionIndicator(context, _handleSave());
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}
