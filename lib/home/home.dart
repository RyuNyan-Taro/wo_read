import 'package:flutter/material.dart';
import 'package:wo_read/common/add_record_button.dart';
import 'package:wo_read/cook/screens/add_cook_button.dart';
import 'package:wo_read/hair/hair.dart';
import 'package:wo_read/hiragana/hiragana.dart';
import 'package:wo_read/shape_move/shape_move.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    const List<(String, Widget)> pages = [
      ('かるた', HiraganaPage()),
      ('ヘアカタログ', HairPage()),
      ('ジェスチャー', ShapeMovePage()),
    ];

    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: pages
                .map(
                  (page) => ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => page.$2),
                    ),
                    child: Text(page.$1),
                  ),
                )
                .toList(),
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              addCookButton(context: context),
              const SizedBox(width: 8),
              addRecordButton(context: context),
            ],
          ),
        ),
      ],
    );
  }
}
