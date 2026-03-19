import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:wo_read/common/success_dialog.dart';
import 'package:wo_read/cook/controllers/cook_form_controller.dart';
import 'package:wo_read/cook/models/cook_item.dart';
import '../../common/action_indicator.dart';
import '../use_cases/convert_enum_use_case.dart';

class CookFormPage extends StatefulWidget {
  final CookItem? item;

  const CookFormPage({super.key, this.item});

  @override
  State<CookFormPage> createState() => _CookFormPageState();
}

class _CookFormPageState extends State<CookFormPage> {
  late final CookFormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CookFormController(initialItem: widget.item);
    if (widget.item == null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _handleAction(_controller.pickImage),
      );
    }
  }

  Future<void> _handleAction(Future<void> Function() action) async {
    setState(() {});
    await action();
    if (mounted) setState(() {});
  }

  Future<void> _handleSave() async {
    final success = await _controller.submit();
    if (success && mounted) {
      final message = _controller.isEditMode
          ? '記録を更新したよ！'
          : '記録を追加したよ！${_controller.aiComment != null ? '\n\n✨ AIからのコメント ✨\n──────────────────\n「${_controller.aiComment}」' : ''}';

      await showSuccessDialog(context: context, content: message);
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _handleDelete() async {
    showActionIndicator(
      context,
      () async {
            if (await _controller.delete() && mounted) {
              await showSuccessDialog(context: context, content: '記録が削除されたよ');
              if (mounted) Navigator.pop(context);
            }
          }
          as Future<dynamic>,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isProcessing = _controller.isProcessing;

    return Scaffold(
      appBar: AppBar(
        title: Text(_controller.isEditMode ? 'Edit Cook' : 'Add Cook'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_controller.isEditMode)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: isProcessing ? null : () => _handleDelete(),
            ),
        ],
      ),
      body: AbsorbPointer(
        absorbing: isProcessing,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              _buildHeaderSection(),

              const SizedBox(height: 20),
              _buildImageSection(),

              if (_controller.isEditMode) ...[
                const SizedBox(height: 20),
                _AiCommentSection(
                  comment: _controller.aiComment,
                  isProcessing: isProcessing,
                  onGenerate: () =>
                      _handleAction(_controller.generateAiComment),
                ),
              ],

              const SizedBox(height: 40),
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

  Widget _buildHeaderSection() {
    return Row(
      children: [
        Expanded(
          child: CategorySelector(
            currentCategory: _controller.category,
            onChanged: (val) => setState(
              () => _controller.category = convertToCookCategory(label: val!),
            ),
          ),
        ),
        const SizedBox(width: 12),
        DatePickButton(
          selectedDate: _controller.date,
          onDateSelected: (date) => setState(() => _controller.date = date),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return CookImagePreview(
      imageFile: _controller.image,
      imageUrl: _controller.initialImageUrl,
      isProcessing: _controller.isProcessing,
      onRotate: (right) =>
          _handleAction(() => _controller.rotateImage(isRight: right)),
      onTap: () => _handleAction(_controller.pickImage),
    );
  }
}

class CookImagePreview extends StatelessWidget {
  final XFile? imageFile;
  final String? imageUrl;
  final bool isProcessing;
  final VoidCallback onTap;
  final Function(bool isRight) onRotate;

  const CookImagePreview({
    super.key,
    this.imageFile,
    this.imageUrl,
    required this.isProcessing,
    required this.onTap,
    required this.onRotate,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageFile != null || imageUrl != null;

    return AspectRatio(
      // アスペクト比を固定するとレイアウトが安定します
      aspectRatio: 4 / 3,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade200),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildImage(),
            Material(
              color: Colors.transparent,
              child: InkWell(onTap: isProcessing ? null : onTap),
            ),
            if (hasImage && !isProcessing) _buildRotateButtons(),
            if (isProcessing) Container(color: Colors.black12),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imageFile != null) {
      return Image.file(File(imageFile!.path), fit: BoxFit.cover);
    }
    if (imageUrl != null) return Image.network(imageUrl!, fit: BoxFit.cover);
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.restaurant_menu, size: 48, color: Colors.orangeAccent),
        SizedBox(height: 8),
        Text(
          '写真をのせる',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildRotateButtons() {
    return Positioned(
      top: 8,
      left: 8,
      right: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleIconButton(
            icon: Icons.rotate_left,
            onTap: () => onRotate(false),
          ),
          _CircleIconButton(
            icon: Icons.rotate_right,
            onTap: () => onRotate(true),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      style: IconButton.styleFrom(
        backgroundColor: Colors.black.withAlpha(100),
        foregroundColor: Colors.white,
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
        side: BorderSide(color: colorScheme.primary.withAlpha(128)),
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
        color: Colors.orange.withAlpha(25),
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

class _AiCommentSection extends StatelessWidget {
  final String? comment;
  final bool isProcessing;
  final VoidCallback? onGenerate;

  const _AiCommentSection({
    this.comment,
    this.isProcessing = false,
    this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasComment = comment != null && comment!.isNotEmpty;

    if (hasComment) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.purple.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.purple.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, size: 18, color: Colors.purple),
                const SizedBox(width: 8),
                Text(
                  'AIからのコメント',
                  style: TextStyle(
                    color: Colors.purple.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              comment!,
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    } else {
      return OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          foregroundColor: Colors.purple,
          side: const BorderSide(color: Colors.purple, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        // 処理中はボタンを無効化
        onPressed: isProcessing ? null : onGenerate,
        icon: isProcessing
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.purple,
                ),
              )
            : const Icon(Icons.auto_awesome),
        label: Text(isProcessing ? '生成中...' : 'AIコメントを生成する'),
      );
    }
  }
}
