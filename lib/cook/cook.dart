import 'package:flutter/material.dart';
import 'package:wo_read/cook/models/cook_item.dart';
import 'package:wo_read/cook/screens/add_cook_button.dart';
import 'package:wo_read/cook/screens/cook_item_card.dart';
import 'package:wo_read/cook/service/cook_service.dart';

class CookPage extends StatefulWidget {
  const CookPage({super.key});

  @override
  State<CookPage> createState() => _CookPageState();
}

class _CookPageState extends State<CookPage> {
  List<CookItem>? cooks;

  @override
  void initState() {
    super.initState();

    if (cooks == null) {
      _getCooks();
    }
  }

  Future<void> _getCooks() async {
    final CookService cookService = CookService();
    final List<CookItem> items = await cookService.getCookUrls();

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
          : SingleChildScrollView(child: Column(children: _cooksList(cooks!))),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [addCookButton(context: context)],
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
            child: CookItemCard(cook: cook),
          ),
        )
        .toList();
  }
}
