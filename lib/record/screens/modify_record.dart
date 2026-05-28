import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:wo_read/common/app_theme.dart';
import 'package:wo_read/common/success_dialog.dart';
import 'package:wo_read/record/controllers/modify_record_controller.dart';
import 'package:wo_read/record/models/record_item.dart';
import 'package:wo_read/common/action_indicator.dart';
import 'package:wo_read/record/screens/error_response_dialog.dart';
import 'package:wo_read/record/use_cases/convert_enum_use_case.dart';

class ModifyRecordPage extends StatefulWidget {
  final RecordItem recordItem;

  const ModifyRecordPage({super.key, required this.recordItem});

  @override
  State<ModifyRecordPage> createState() => _ModifyRecordPageState();
}

class _ModifyRecordPageState extends State<ModifyRecordPage> {
  final formKey = GlobalKey<FormState>();
  late final ModifyRecordController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ModifyRecordController(originalItem: widget.recordItem);
  }

  Future<void> _updateRecord() async {
    final bool success = await _controller.updateRecord();

    if (success && mounted) {
      await showSuccessDialog(context: context, content: '記録が変更されたよ');
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _deleteRecord() async {
    final bool success = await _controller.deleteRecord();

    if (success && mounted) {
      await showSuccessDialog(context: context, content: '記録が削除されたよ');
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _autoDecideTypes() async {
    final LabelResult labels = await _controller.getAutoLabels();

    if (!mounted) return;

    if (labels.status != ResponseStatus.success) {
      await errorResponseDialog(context: context, status: labels.status);
      return;
    }

    setState(() {
      if (_controller.feeling == FeelingType.none) {
        _controller.feeling = labels.feeling;
      }
      if (_controller.denver == DenverType.none) {
        _controller.denver = labels.denver;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('記録を編集'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDatePicker(context),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(Icons.label_outline, color: AppColors.outlineVariant, size: 22),
                  SizedBox(width: 6),
                  Text(
                    'タグ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildTypeSelectors(context),
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
              _buildContentField(context),
              const SizedBox(height: 24),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    final formatter = DateFormat('yyyy/MM/dd');

    return InkWell(
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
    );
  }

  Widget _buildTypeSelectors(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _controller.feeling.name,
            decoration: const InputDecoration(labelText: '感情'),
            items: FeelingType.values
                .map(
                  (feeling) => DropdownMenuItem(
                    value: feeling.name,
                    child: Text(feelingToJp[feeling]!),
                  ),
                )
                .toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _controller.feeling = convertToFeelingType(label: newValue);
                });
              }
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _controller.denver.name,
            decoration: const InputDecoration(labelText: '発達'),
            items: DenverType.values
                .map(
                  (denver) => DropdownMenuItem(
                    value: denver.name,
                    child: Text(denverToJp[denver]!),
                  ),
                )
                .toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _controller.denver = convertToDenverType(label: newValue);
                });
              }
            },
          ),
        ),
        Visibility(
          visible:
              _controller.feeling == FeelingType.none ||
              _controller.denver == DenverType.none,
          child: IconButton(
            icon: SvgPicture.asset(
              'assets/images/icon/ai.svg',
              width: 24,
              height: 24,
            ),
            onPressed: _autoDecideTypes,
          ),
        ),
      ],
    );
  }

  Widget _buildContentField(BuildContext context) {
    return TextFormField(
      key: formKey,
      controller: _controller.descriptionController,
      decoration: const InputDecoration(
        hintText: 'メモ',
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              showActionIndicator(context, _updateRecord());
            },
            child: const Text('変更'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              showActionIndicator(context, _deleteRecord());
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
            ),
            child: const Text('削除'),
          ),
        ),
      ],
    );
  }
}
