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

  @override
  void initState() {
    super.initState();

    if (_categories == null) {
      _getCategories();
    }
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
          TextFormField(
            // TODO: add check process whether already existed category or not
            key: formKey,
            autofocus: true,
            controller: descriptionController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(), // 外枠付きデザイン
              labelText: "category",
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showActionIndicator(context, _saveCategory());
            },
            child: const Text('追加'),
          ),
        ],
      ),
    );
  }
}
