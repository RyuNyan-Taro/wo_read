import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wo_read/common/app_theme.dart';
import 'package:wo_read/common/success_dialog.dart';
import 'package:wo_read/record/controllers/add_record_controller.dart';
import 'package:wo_read/common/action_indicator.dart';

class AddRecordPage extends StatefulWidget {
  const AddRecordPage({super.key});

  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  final formKey = GlobalKey<FormState>();
  final AddRecordController _controller = AddRecordController();

  @override
  void initState() {
    super.initState();
    _controller.descriptionController.addListener(_onTextChanged);
  }

  void _onTextChanged() => setState(() {});

  @override
  dispose() {
    _controller.descriptionController.removeListener(_onTextChanged);
    super.dispose();
    _controller.dispose();
  }

  Future<void> _saveRecord() async {
    final bool success = await _controller.saveRecord();

    if (success && mounted) {
      await showSuccessDialog(context: context, content: '記録が追加されたよ');
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyyy/MM/dd');
    return Scaffold(
      appBar: AppBar(
        title: const Text('記録を追加'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () async {
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
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today, size: 18, color: AppColors.outline),
                      const SizedBox(width: 10),
                      Text(
                        formatter.format(_controller.date),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(Icons.edit_note, color: AppColors.outlineVariant, size: 22),
                  SizedBox(width: 6),
                  Text(
                    '活動内容',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: formKey,
                autofocus: true,
                controller: _controller.descriptionController,
                decoration: const InputDecoration(
                  hintText: 'メモ',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _controller.descriptionController.text.trim().isEmpty
                      ? null
                      : () {
                          showActionIndicator(context, _saveRecord());
                        },
                  child: const Text('追加'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
