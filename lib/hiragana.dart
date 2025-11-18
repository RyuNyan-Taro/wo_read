import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wo_read/example.dart';
import 'package:wo_read/text_to_speech.dart';

class HiraganaPage extends StatefulWidget {
  const HiraganaPage({super.key});

  @override
  State<HiraganaPage> createState() => _HiraganaPageState();
}

class _HiraganaPageState extends State<HiraganaPage> {
  int _hiraganaId = 0;
  String _hiragana = "あ";
  final Map<int, Example> _hiraganaExamples = {
    0: Example(reading: "あめ", imagePath: ""),
    1: Example(reading: "いぬ", imagePath: ""),
    2: Example(reading: "うさぎ", imagePath: ""),
    3: Example(reading: "えんぴつ", imagePath: ""),
    4: Example(reading: "おかし", imagePath: ""),
    5: Example(reading: "かさ", imagePath: ""),
    6: Example(reading: "きつね", imagePath: ""),
    7: Example(reading: "くま", imagePath: ""),
    8: Example(reading: "けーき", imagePath: ""),
    9: Example(reading: "こおり", imagePath: ""),
    10: Example(reading: "さかな", imagePath: ""),
    11: Example(reading: "しか", imagePath: ""),
    12: Example(reading: "すし", imagePath: ""),
    13: Example(reading: "せんせい", imagePath: ""),
    14: Example(reading: "そら", imagePath: ""),
    15: Example(reading: "たこ", imagePath: ""),
    16: Example(reading: "ちず", imagePath: ""),
    17: Example(reading: "つき", imagePath: ""),
    18: Example(reading: "てぶくろ", imagePath: ""),
    19: Example(reading: "とり", imagePath: ""),
    20: Example(reading: "なす", imagePath: ""),
    21: Example(reading: "にわとり", imagePath: ""),
    22: Example(reading: "ぬいぐるみ", imagePath: ""),
    23: Example(reading: "ねこ", imagePath: ""),
    24: Example(reading: "のり", imagePath: ""),
    25: Example(reading: "はな", imagePath: ""),
    26: Example(reading: "ひこうき", imagePath: ""),
    27: Example(reading: "ふね", imagePath: ""),
    28: Example(reading: "へび", imagePath: ""),
    29: Example(reading: "ほし", imagePath: ""),
    30: Example(reading: "まめ", imagePath: ""),
    31: Example(reading: "みかん", imagePath: ""),
    32: Example(reading: "むし", imagePath: ""),
    33: Example(reading: "めがね", imagePath: ""),
    34: Example(reading: "もも", imagePath: ""),
    35: Example(reading: "やま", imagePath: ""),
    36: Example(reading: "ゆき", imagePath: ""),
    37: Example(reading: "よる", imagePath: ""),
    38: Example(reading: "らいおん", imagePath: ""),
    39: Example(reading: "りんご", imagePath: ""),
    40: Example(reading: "るびー", imagePath: ""),
    41: Example(reading: "れもん", imagePath: ""),
    42: Example(reading: "ろうそく", imagePath: ""),
    43: Example(reading: "わに", imagePath: ""),
    44: Example(reading: "をとこ", imagePath: ""),
    45: Example(reading: "えんぴつ", imagePath: ""),
    46: Example(reading: "がっこう", imagePath: ""),
    47: Example(reading: "ぎんこう", imagePath: ""),
    48: Example(reading: "ぐんて", imagePath: ""),
    49: Example(reading: "げーむ", imagePath: ""),
    50: Example(reading: "ごはん", imagePath: ""),
    51: Example(reading: "ざっそう", imagePath: ""),
    52: Example(reading: "じてんしゃ", imagePath: ""),
    53: Example(reading: "ずぼん", imagePath: ""),
    54: Example(reading: "ぜんぶ", imagePath: ""),
    55: Example(reading: "ぞう", imagePath: ""),
    56: Example(reading: "だいこん", imagePath: ""),
    57: Example(reading: "ぢしん", imagePath: ""),
    58: Example(reading: "づくえ", imagePath: ""),
    59: Example(reading: "でんき", imagePath: ""),
    60: Example(reading: "どあ", imagePath: ""),
    61: Example(reading: "ばす", imagePath: ""),
    62: Example(reading: "びーる", imagePath: ""),
    63: Example(reading: "ぶた", imagePath: ""),
    64: Example(reading: "べんとう", imagePath: ""),
    65: Example(reading: "ぼうし", imagePath: ""),
    66: Example(reading: "ぱん", imagePath: ""),
    67: Example(reading: "ぴざ", imagePath: ""),
    68: Example(reading: "ぷーる", imagePath: ""),
    69: Example(reading: "ぺん", imagePath: ""),
    70: Example(reading: "ぽすと", imagePath: ""),
  };
  Example _example = Example(reading: "あめ", imagePath: "");

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

  Future<void> _upDateText() async {
    setState(() {
      _hiraganaId = random.nextInt(71);
      _hiragana = _hiraganaList[_hiraganaId];
      _example = _hiraganaExamples[_hiraganaId]!;
    });
    _ttsService.speak(_hiragana);
    await Future.delayed(Duration(milliseconds: 1000));
    _ttsService.speak(_example.reading);
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
