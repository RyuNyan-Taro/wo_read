class CharacterImage {
  CharacterImage({required this.name, required this.path});

  final String name;
  final String path;
}

enum CharacterKey {
  jasmine,
  anna,
  belle,
  cinderella,
  elsa,
  hans,
  judy,
  rapunzel,
}

final Map<CharacterKey, CharacterImage> imageData = {
  CharacterKey.jasmine: CharacterImage(
    name: 'ジャスミン',
    path: 'assets/images/hair/jasmine.jpeg',
  ),
  CharacterKey.anna: CharacterImage(
    name: 'アナ',
    path: 'assets/images/hair/anna.jpeg',
  ),
  CharacterKey.belle: CharacterImage(
    name: 'ベル',
    path: 'assets/images/hair/belle.jpeg',
  ),
  CharacterKey.cinderella: CharacterImage(
    name: 'シンデレラ',
    path: 'assets/images/hair/cinderella.jpeg',
  ),
  CharacterKey.elsa: CharacterImage(
    name: 'エルサ',
    path: 'assets/images/hair/elsa.jpeg',
  ),
  CharacterKey.hans: CharacterImage(
    name: 'ハンス',
    path: 'assets/images/hair/hans.jpeg',
  ),
  CharacterKey.judy: CharacterImage(
    name: 'ジュディ',
    path: 'assets/images/hair/judy.jpeg',
  ),
  CharacterKey.rapunzel: CharacterImage(
    name: 'ラプンツェル',
    path: 'assets/images/hair/rapunzel.jpeg',
  ),
};
