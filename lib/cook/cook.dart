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
  static const _initialPageSize = 11;
  static const _pageSize = 10;

  List<CookItem>? cooks;
  bool _isLoadingMoreCooks = false;
  bool _hasMoreCooks = true;

  @override
  void initState() {
    super.initState();
    _getCooks();
  }

  Future<void> _getCooks() async {
    final CookService cookService = CookService();
    final List<CookItem> items = await cookService.getCookUrls();

    if (!mounted) return;

    setState(() {
      cooks = items;
      _hasMoreCooks = items.length == _initialPageSize;
    });
  }

  Future<void> _loadMoreCooks() async {
    final currentCooks = cooks;
    if (currentCooks == null || _isLoadingMoreCooks || !_hasMoreCooks) {
      return;
    }

    setState(() {
      _isLoadingMoreCooks = true;
    });

    try {
      final items = await CookService().getCookUrls(
        offset: currentCooks.length,
        limit: _pageSize,
      );

      if (!mounted) return;

      setState(() {
        cooks = [...currentCooks, ...items];
        _hasMoreCooks = items.length == _pageSize;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMoreCooks = false;
        });
      }
    }
  }

  Future<void> _openDetail(CookItem cook) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => CookFormPage(item: cook)),
    );
    _getCooks();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        cooks == null
            ? const Center(child: CircularProgressIndicator())
            : NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.extentAfter < 200) {
                    _loadMoreCooks();
                  }
                  return false;
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ..._bentoGrid(cooks!),
                      if (_isLoadingMoreCooks)
                        const Padding(
                          padding: EdgeInsets.only(top: 24),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  ),
                ),
              ),
        Positioned(
          right: 16,
          bottom: 20,
          child: addCookButton(context: context, returnAction: _getCooks),
        ),
      ],
    );
  }

  List<Widget> _bentoGrid(List<CookItem> cooks) {
    if (cooks.isEmpty) return [];

    final widgets = <Widget>[];

    // First item: featured full-width card
    widgets.add(_tappableCard(cooks[0], isFeatured: true));

    // Remaining items: 2-column rows
    final rest = cooks.skip(1).toList();
    for (var i = 0; i < rest.length; i += 2) {
      final left = rest[i];
      final right = i + 1 < rest.length ? rest[i + 1] : null;

      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _tappableCard(left, isFeatured: false)),
              const SizedBox(width: 12),
              Expanded(
                child: right != null
                    ? _tappableCard(right, isFeatured: false)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
    }

    return widgets;
  }

  Widget _tappableCard(CookItem cook, {required bool isFeatured}) {
    return InkWell(
      borderRadius: BorderRadius.circular(isFeatured ? 24 : 16),
      onTap: () => _openDetail(cook),
      child: CookItemCard(cook: cook, isFeatured: isFeatured),
    );
  }
}
