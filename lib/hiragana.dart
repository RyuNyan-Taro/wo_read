import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wo_read/text_to_speech.dart';

class HiraganaPage extends StatefulWidget {
  const HiraganaPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<HiraganaPage> createState() => _HiraganaPageState();
}

class _HiraganaPageState extends State<HiraganaPage> {
  String _hiragana = "あ";

  final List<String> _hiraganaList = [
    // Basic Hiragana (あ行 to わ行)
    "あ", "い", "う", "え", "お", // あ行
    "か", "き", "く", "け", "こ", // か行
    "さ", "し", "す", "せ", "そ", // さ行
    "た", "ち", "つ", "て", "と", // た行
    "な", "に", "ぬ", "ね", "の", // な行
    "は", "ひ", "ふ", "へ", "ほ", // は行
    "ま", "み", "む", "め", "も", // ま行
    "や", "ゆ", "よ", // や行
    "ら", "り", "る", "れ", "ろ", // ら行
    "わ", "を", // わ行
    "ん", // ん
    // Dakuon (濁音)
    "が", "ぎ", "ぐ", "げ", "ご", // が行
    "ざ", "じ", "ず", "ぜ", "ぞ", // ざ行
    "だ", "ぢ", "づ", "で", "ど", // だ行
    "ば", "び", "ぶ", "べ", "ぼ", // ば行
    // Handakuon (半濁音)
    "ぱ", "ぴ", "ぷ", "ぺ", "ぽ", // ぱ行
  ];
  final random = Random();

  final TextToSpeechService _ttsService = TextToSpeechService();

  void _upDateText() {
    setState(() {
      _hiragana = _hiraganaList[random.nextInt(71)];
    });
    _ttsService.speak(_hiragana);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Hiragana'),
      ),
      body: InkWell(
        onTap: _upDateText,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_hiragana, style: TextStyle(fontSize: 200)),
            ],
          ),
        ),
      ),
    );
  }
}
