import 'package:flutter/material.dart';
import 'package:wo_read/common/add_record_button.dart';
import 'package:wo_read/gallery/gallery.dart';
import 'package:wo_read/hair/hair.dart';
import 'package:wo_read/hiragana/hiragana.dart';
import 'package:wo_read/record/record.dart';
import 'package:wo_read/shape_move/shape_move.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const List<(String, Widget)> pages = [
      ('カルタ', HiraganaPage()),
      ('成長記録', RecordPage()),
      ('ヘアカタログ', HairPage()),
      ('ジェスチャー', ShapeMovePage()),
      ('ギャラリー', GalleryPage()),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: pages
              .map(
                (page) => ElevatedButton(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => page.$2),
                    ),
                  },
                  child: Text(page.$1),
                ),
              )
              .toList(),
        ),
      ),
      floatingActionButton: addRecordButton(context: context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
