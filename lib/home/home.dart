import 'package:flutter/material.dart';
import 'package:wo_read/hiragana/hiragana.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => const HiraganaPage(),
              child: const Text('カルタ'),
            ),
            ElevatedButton(
              onPressed: () => const HiraganaPage(),
              child: const Text('成長記録'),
            ),
          ],
        ),
      ),
    );
  }
}
