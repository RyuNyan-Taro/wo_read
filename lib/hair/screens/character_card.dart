import 'package:flutter/material.dart';

class CharacterCard extends StatelessWidget {
  final String name;

  const CharacterCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/hair/anna.jpeg'),
          ),
        ),
        child: Text('test'),
      ),
    );
  }
}
