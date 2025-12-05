import 'package:flutter/material.dart';
import 'package:wo_read/hair/models/character_data.dart';
import 'package:wo_read/hair/screens/movie.dart';

class CharacterCard extends StatelessWidget {
  final CharacterKey characterKey;

  const CharacterCard({super.key, required this.characterKey});

  @override
  Widget build(BuildContext context) {
    final CharacterImage? image = imageData[characterKey];

    return InkWell(
      // TODO: add link to the character hair movie list page
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MoviePage(characterKey: characterKey),
          ),
        ),
      },
      child: Card(
        child: Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image!.path),
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
