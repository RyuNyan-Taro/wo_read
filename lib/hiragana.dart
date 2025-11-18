import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wo_read/text_to_speech.dart';

class HiraganaPage extends StatefulWidget {
  const HiraganaPage({super.key});

  @override
  State<HiraganaPage> createState() => _HiraganaPageState();
}

class _HiraganaPageState extends State<HiraganaPage> {
  int _hiraganaId = 0;
  String _hiragana = "あ";
  final Map<int, String> _hiraganaExamples = {
    0: "あめ",
    1: "いぬ",
    2: "うさぎ",
    3: "えんぴつ",
    4: "おかし",
    5: "かさ",
    6: "きつね",
    7: "くま",
    8: "けーき",
    9: "こおり",
    10: "さかな",
    11: "しか",
    12: "すし",
    13: "せんせい",
    14: "そら",
    15: "たこ",
    16: "ちず",
    17: "つき",
    18: "てぶくろ",
    19: "とり",
    20: "なす",
    21: "にわとり",
    22: "ぬいぐるみ",
    23: "ねこ",
    24: "のり",
    25: "はな",
    26: "ひこうき",
    27: "ふね",
    28: "へび",
    29: "ほし",
    30: "まめ",
    31: "みかん",
    32: "むし",
    33: "めがね",
    34: "もも",
    35: "やま",
    36: "ゆき",
    37: "よる",
    38: "らいおん",
    39: "りんご",
    40: "るびー",
    41: "れもん",
    42: "ろうそく",
    43: "わに",
    44: "をとこ",
    45: "えんぴつ",
    46: "がっこう",
    47: "ぎんこう",
    48: "ぐんて",
    49: "げーむ",
    50: "ごはん",
    51: "ざっそう",
    52: "じてんしゃ",
    53: "ずぼん",
    54: "ぜんぶ",
    55: "ぞう",
    56: "だいこん",
    57: "ぢしん",
    58: "づくえ",
    59: "でんき",
    60: "どあ",
    61: "ばす",
    62: "びーる",
    63: "ぶた",
    64: "べんとう",
    65: "ぼうし",
    66: "ぱん",
    67: "ぴざ",
    68: "ぷーる",
    69: "ぺん",
    70: "ぽすと",
  };
  String _example = "";

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
    _ttsService.speak(_example);
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
