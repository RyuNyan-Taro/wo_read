import 'package:flutter/material.dart';
import 'package:wo_read/common/action_indicator.dart';
import 'package:wo_read/common/app_theme.dart';
import 'package:wo_read/common/success_dialog.dart';
import 'package:wo_read/gallery/service/gallery_service.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final GalleryService _galleryService = GalleryService();
  List<String>? _categories;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();

    if (_categories == null) {
      _getCategories();
    }

    descriptionController.addListener(_validateForm);
  }

  void _validateForm() {
    if (!mounted) return;

    setState(() {
      _isFormValid = formKey.currentState?.validate() ?? false;
    });
  }

  Future<void> _getCategories() async {
    final List<String> items = await _galleryService.getCategories();

    if (!mounted) return;

    setState(() {
      _categories = items;
    });
  }

  Future<void> _saveCategory(String newCategory) async {
    await _galleryService.addCategory(newCategory.trim());

    if (!mounted) {
      return;
    }

    await showSuccessDialog(context: context, content: 'カテゴリーが追加されたよ');
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    descriptionController.removeListener(_validateForm);
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesLoaded = _categories != null;

    return Scaffold(
      appBar: AppBar(title: const Text('カテゴリーを追加')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '写真を整理するためのカテゴリーを作成します。',
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: AppColors.outline),
            ),
            const SizedBox(height: 20),
            _CategoryFormCard(
              formKey: formKey,
              controller: descriptionController,
              categories: _categories,
            ),
            if (!categoriesLoaded) ...[
              const SizedBox(height: 12),
              const _LoadingCategoriesHint(),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                onPressed: _isFormValid && categoriesLoaded
                    ? () {
                        showActionIndicator(
                          context,
                          _saveCategory(descriptionController.text.trim()),
                        );
                      }
                    : null,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('カテゴリーを追加'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryFormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final List<String>? categories;

  const _CategoryFormCard({
    required this.formKey,
    required this.controller,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formKey,
        child: TextFormField(
          autofocus: true,
          enabled: categories != null,
          controller: controller,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.sell_outlined),
            labelText: 'カテゴリー名',
            hintText: '例: おでかけ',
          ),
          validator: (value) {
            final text = value?.trim() ?? '';
            if (text.isEmpty) {
              return 'カテゴリー名を入力してください';
            }
            if ((categories ?? const <String>[]).contains(text)) {
              return '既に存在するカテゴリーです';
            }
            return null;
          },
        ),
      ),
    );
  }
}

class _LoadingCategoriesHint extends StatelessWidget {
  const _LoadingCategoriesHint();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(width: 8),
        Text(
          'カテゴリーを読み込み中',
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: AppColors.outline),
        ),
      ],
    );
  }
}
