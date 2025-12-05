import 'package:flutter/material.dart';
import 'package:wo_read/hair/models/character_data.dart';
import 'package:wo_read/hair/screens/character_card.dart';

class HairPage extends StatelessWidget {
  const HairPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Hair'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: CharacterKey.values
              .map((key) => CharacterCard(characterKey: key))
              .toList(),
        ),
      ),
    );
  }
}
