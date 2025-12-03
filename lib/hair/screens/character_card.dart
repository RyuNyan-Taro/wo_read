import 'package:flutter/material.dart';
import 'package:wo_read/hair/models/image_data.dart';

class CharacterCard extends StatelessWidget {
  final CharacterImage image;

  const CharacterCard({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {print('test')},
      child: Card(
        child: Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image.path),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 8),
              child: Text(
                image.name,
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
