class CharacterImage {
  CharacterImage({required this.name, required this.path});

  final String name;
  final String path;
}

final List<CharacterImage> imageData = [
  CharacterImage(name: 'ジャスミン', path: 'assets/images/hair/aladdin.jpeg'),
  CharacterImage(name: 'アナ', path: 'assets/images/hair/anna.jpeg'),
  CharacterImage(name: 'ベル', path: 'assets/images/hair/belle.jpeg'),
  CharacterImage(name: 'シンデレラ', path: 'assets/images/hair/cinderella.jpeg'),
  CharacterImage(name: 'エルサ', path: 'assets/images/hair/elsa.jpeg'),
  CharacterImage(name: 'ハンス', path: 'assets/images/hair/hans.jpeg'),
  CharacterImage(name: 'ジュディ', path: 'assets/images/hair/judy.jpeg'),
  CharacterImage(name: 'ラプンツェル', path: 'assets/images/hair/rapunzel.jpeg'),
];
