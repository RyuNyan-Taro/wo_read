import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:wo_read/common/success_dialog.dart';
import 'package:wo_read/record/controllers/modify_record_controller.dart';
import 'package:wo_read/record/models/record_item.dart';
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
    }
  }

  Future<void> _deleteRecord() async {
    final bool success = await _controller.deleteRecord();

    if (success && mounted) {
      await showSuccessDialog(context: context, content: '記録が削除されたよ');
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
      if (_controller.feeling == FeelingType.none)
        _controller.feeling = labels.feeling;
      if (_controller.denver == DenverType.none)
        _controller.denver = labels.denver;
    });
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
          _buildDatePicker(context),
          _buildTypeSelectors(context),
          _buildContentField(context),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    final formatter = DateFormat('MM/dd');

    return ElevatedButton(
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
    );
  }

  Widget _buildTypeSelectors(BuildContext context) {
    return Row(
      children: [
        DropdownButton(
          value: _controller.feeling.name,
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
                _controller.feeling = convertToFeelingType(label: newValue);
              });
            }
          },
        ),
        DropdownButton(
          value: _controller.denver.name,
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
                _controller.denver = convertToDenverType(label: newValue);
              });
            }
          },
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
        // icon: Icon(Icons.email),
        border: OutlineInputBorder(), // 外枠付きデザイン
        labelText: "content",
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: _updateRecord, child: const Text('変更')),
        ElevatedButton(
          onPressed: _deleteRecord,
          child: const Text('削除', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
