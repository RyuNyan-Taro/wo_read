import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:wo_read/hiragana/models/example.dart';
import 'package:wo_read/hiragana/models/hiragana_data.dart';
import 'package:wo_read/hiragana/text_to_speech.dart';

class HiraganaPage extends StatefulWidget {
  const HiraganaPage({super.key});

  @override
  State<HiraganaPage> createState() => _HiraganaPageState();
}

class _HiraganaPageState extends State<HiraganaPage> {
  final TextToSpeechService _ttsService = TextToSpeechService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final random = Random();

  bool _isProcessing = false;
  int _hiraganaId = 0;
  String _hiragana = "あ";
  Example _example = Example(
    reading: "あめ",
    imagePath: "assets/images/hiragana/rain.png",
  );

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _upDateText() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _hiraganaId = random.nextInt(45);
      // _hiraganaId = 0;
      _hiragana = JapaneseData.hiraganaList[_hiraganaId];
      _example = JapaneseData.examples[_hiraganaId]!;
    });

    try {
      _ttsService.speak(_hiragana);
      // await _audioPlayer.play(AssetSource('audio/a.m4a'));
      int speakTimeMillisecond = 250 * _example.reading.length;

      await Future.delayed(Duration(milliseconds: 1000));
      _ttsService.speak(_example.reading);
      await Future.delayed(Duration(milliseconds: speakTimeMillisecond));
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
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
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Image.asset(
                  _example.imagePath,
                  height: 400,
                  fit: BoxFit.contain,
                ),
              ),
              Text(_hiragana, style: TextStyle(fontSize: 200)),
            ],
          ),
        ),
      ),
    );
  }
}
