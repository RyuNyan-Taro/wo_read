import 'dart:io';
import 'package:image_picker/image_picker.dart';
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
    _controller.pickImage().then((_) {
      if (mounted) setState(() {});
    });
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CategorySelector(
              currentCategory: _controller.category,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    _controller.category = convertToCookCategory(
                      label: newValue,
                    );
                  });
                }
              },
            ),
            DatePickButton(
              selectedDate: _controller.date,
              onDateSelected: (date) => setState(() => _controller.date = date),
            ),
            const SizedBox(height: 16),
            CookImagePreview(
              imageFile: _controller.image,
              onTap: () async {
                await _controller.pickImage();
                setState(() {});
              },
            ),
            const SizedBox(height: 32),
            SaveButton(
              onPressed: () => showActionIndicator(context, _handleSave()),
            ),
          ],
        ),
      ),
    );
  }
}

class DatePickButton extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DatePickButton({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MM/dd');
    return ElevatedButton(
      onPressed: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (date != null) onDateSelected(date);
      },
      child: Text(formatter.format(selectedDate)),
    );
  }
}

class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: const Text('保存'));
  }
}

class CategorySelector extends StatelessWidget {
  final CookCategory currentCategory;
  final ValueChanged<String?> onChanged;

  const CategorySelector({
    super.key,
    required this.currentCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: currentCategory.name,
      items: CookCategory.values.map((category) {
        return DropdownMenuItem(
          value: category.name,
          child: Text(categoryToJp[category]!),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

class CookImagePreview extends StatelessWidget {
  final XFile? imageFile;
  final VoidCallback onTap;

  const CookImagePreview({super.key, this.imageFile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: imageFile != null
              ? Image.file(File(imageFile!.path), fit: BoxFit.cover)
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('タップして料理の写真を追加', style: TextStyle(color: Colors.grey)),
                  ],
                ),
        ),
      ),
    );
  }
}
