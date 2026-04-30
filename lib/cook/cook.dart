import 'package:flutter/material.dart';
import 'package:wo_read/cook/models/cook_item.dart';
import 'package:wo_read/cook/screens/add_cook_button.dart';
import 'package:wo_read/cook/screens/cook_form_page.dart';
import 'package:wo_read/cook/screens/cook_item_card.dart';
import 'package:wo_read/cook/service/cook_service.dart';

class CookBody extends StatefulWidget {
  const CookBody({super.key});

  @override
  State<CookBody> createState() => _CookBodyState();
}

class _CookBodyState extends State<CookBody> {
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

    if (!mounted) return;

    setState(() {
      cooks = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        cooks == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(child: Column(children: _cooksList(cooks!))),
        Positioned(
          left: 16,
          bottom: 16,
          child: addCookButton(context: context, returnAction: _getCooks),
        ),
      ],
    );
  }

  List<Widget> _cooksList(List<CookItem> cooks) {
    return cooks
        .map(
          (cook) => InkWell(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return CookFormPage(item: cook);
                  },
                ),
              );
              _getCooks();
            },
            child: CookItemCard(cook: cook),
          ),
        )
        .toList();
  }
}
