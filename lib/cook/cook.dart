import 'package:flutter/material.dart';
import 'package:wo_read/cook/models/cook_item.dart';

class CookPage extends StatefulWidget {
  const CookPage({super.key});

  @override
  State<CookPage> createState() => _CookPageState();
}

class _CookPageState extends State<CookPage> {
  List<CookItem>? cooks = [
    CookItem(id: 1, category: CookCategory.box, url: 'test'),
    CookItem(id: 2, category: CookCategory.box, url: 'test')
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
      // floatingActionButton: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     addImageButton(context: context),
      //     SizedBox(height: 12),
      //     addCategoryButton(context: context),
      //   ],
      // ),
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
            child: Text(cook.id.toString()),
          ),
        )
        .toList();
  }
}
