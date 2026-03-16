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
    _handlePickImage();
  }

  Future<void> _handlePickImage() async {
    setState(() {});
    await _controller.pickImage();
    if (mounted) setState(() {});
  }

  Future<void> _handleSave() async {
    final success = await _controller.saveCook();
    if (success && mounted) {
      await showSuccessDialog(context: context, content: '記録が追加されたよ');

      if (!mounted) return;

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add cook'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: AbsorbPointer(
        absorbing: _controller.isProcessing,
        child: SingleChildScrollView(
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
                onDateSelected: (date) =>
                    setState(() => _controller.date = date),
              ),
              const SizedBox(height: 16),
              CookImagePreview(
                imageFile: _controller.image,
                isProcessing: _controller.isProcessing,
                onRotate: () async {
                  setState(() {});
                  await _controller.rotateImage();
                  if (mounted) setState(() {});
                },
                onTap: _handlePickImage,
              ),
              const SizedBox(height: 32),
              SaveButton(
                onPressed: _controller.canSave
                    ? () => showActionIndicator(context, _handleSave())
                    : null,
              ),
            ],
          ),
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
    final colorScheme = Theme.of(context).colorScheme;

    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      onPressed: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (date != null) onDateSelected(date);
      },
      icon: const Icon(Icons.calendar_today, size: 18),
      label: Text(
        formatter.format(selectedDate),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const SaveButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orangeAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const StadiumBorder(),
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey.shade500,
        ),
        onPressed: onPressed,
        child: const Text(
          '記録を保存する',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentCategory.name,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.orange),
          items: CookCategory.values.map((category) {
            return DropdownMenuItem(
              value: category.name,
              child: Text(
                categoryToJp[category]!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class CookImagePreview extends StatelessWidget {
  final XFile? imageFile;
  final bool isProcessing;
  final VoidCallback onTap;
  final VoidCallback onRotate;

  const CookImagePreview({
    super.key,
    this.imageFile,
    required this.isProcessing,
    required this.onTap,
    required this.onRotate,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: isProcessing ? null : onTap,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: imageFile == null
                  ? Border.all(
                      color: Colors.grey.withValues(alpha: 0.3),
                      width: 2,
                    )
                  : null,
            ),
            clipBehavior: Clip.antiAlias,
            child: imageFile != null
                ? Image.file(File(imageFile!.path), fit: BoxFit.fitWidth)
                : Container(
                    padding: const EdgeInsets.all(48.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 64,
                          color: Colors.orange.withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '料理の写真をのせる',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),

        if (isProcessing && imageFile != null)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),

        if (imageFile != null && !isProcessing)
          Positioned(
            top: 8,
            right: 8,
            child: IconButton.filled(
              onPressed: onRotate,
              icon: const Icon(Icons.rotate_right),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withValues(alpha: 0.5),
                foregroundColor: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
