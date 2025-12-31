import 'package:flutter/material.dart';
import 'package:wo_read/common/action_indicator.dart';
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
    setState(() {
      _isFormValid = formKey.currentState?.validate() ?? false;
    });
  }

  Future<void> _getCategories() async {
    final List<String> items = await _galleryService.getCategories();

    setState(() {
      _categories = items;
    });
  }

  Future<void> _saveCategory() async {
    // TODO: add category service process
    print('pushSave');
    print('text${descriptionController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add record'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          SizedBox(height: 12),
          Form(
            autovalidateMode: AutovalidateMode.always,
            child: TextFormField(
              key: formKey,
              autofocus: true,
              controller: descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(), // 外枠付きデザイン
                labelText: "category",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return '';
                }
                if (_categories!.contains(value)) {
                  return '既に存在するカテゴリーです';
                }
                print(_categories);
                return null;
              },
            ),
          ),
          ElevatedButton(
            onPressed: _isFormValid
                ? () {
                    showActionIndicator(context, _saveCategory());
                  }
                : null,
            child: const Text('追加'),
          ),
        ],
      ),
    );
  }
}
