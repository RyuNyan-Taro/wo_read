import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wo_read/cook/models/cook_item.dart';
import 'package:wo_read/cook/screens/add_cook_button.dart';
import 'package:wo_read/cook/screens/cook_item_card.dart';

class CookPage extends StatefulWidget {
  const CookPage({super.key});

  @override
  State<CookPage> createState() => _CookPageState();
}

class _CookPageState extends State<CookPage> {
  List<CookItem>? cooks = [
    CookItem(id: 1, category: CookCategory.box, url: dotenv.env['TEST_IMAGE_URL'] ?? '', createdAt: DateTime.now()),
    CookItem(id: 2, category: CookCategory.box, url: dotenv.env['TEST_IMAGE_URL'] ?? '', createdAt: DateTime.now()),
    CookItem(id: 3, category: CookCategory.box, url: dotenv.env['TEST_IMAGE_URL'] ?? '', createdAt: DateTime.now()),
    CookItem(id: 4, category: CookCategory.breakfast, url: dotenv.env['TEST_IMAGE_URL'] ?? '', createdAt: DateTime.now()),
    CookItem(id: 5, category: CookCategory.lunch, url: dotenv.env['TEST_IMAGE_URL'] ?? '', createdAt: DateTime.now()),
    CookItem(id: 6, category: CookCategory.dinner, url: dotenv.env['TEST_IMAGE_URL'] ?? '', createdAt: DateTime.now()),
  ];

  @override
  void initState() {
    super.initState();

    if (cooks == null) {
      _getGalleries();
    }
  }

  Future<void> _getGalleries() async {
    // final CookService cookService = CookService();
    // final List<CookItem> items = await cookService.getCookUrls();

    final List<CookItem> items = [];

    setState(() {
      cooks = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('cook'),
      ),
      body: cooks == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(children: _cooksList(cooks!)),
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          addCookButton(context: context),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  List<Widget> _cooksList(List<CookItem> cooks) {
    return cooks
        .map(
          (cook) => InkWell(
            // onTap: () async {
            //   await Navigator.of(context).push(
            //     MaterialPageRoute(
            //       builder: (context) {
            //         return ModifyCategoryPage(cook: cook);
            //       },
            //     ),
            //   );
            // },
            // child: Image.network(cook.url),
            child: CookItemCard(cook: cook,),
          ),
        )
        .toList();
  }
}
