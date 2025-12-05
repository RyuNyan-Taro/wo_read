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

final Map<CharacterKey, List<String>> MovieId = {
  CharacterKey.jasmine: [
    'cuWnyBQQ5cA',
    'GSoi5mtAcxE',
    'pGIL3LyT1zk',
    'qpWe21wYIMM',
  ],
  CharacterKey.anna: [
    'V6lOXWYf5QU',
    'rvcl5o_zlME',
    '3PgNXn-Td08',
    '5Y5t2jpi4YQ',
    'x9e3g6H2wf0',
  ],
  CharacterKey.belle: [
    '6InTkPNEvKg',
    'TjbTgz1uWVk',
    'mPKsfuUDDPs',
    'Loi4uP3l6zw',
    '1s2o_7b08Nw',
  ],
  CharacterKey.cinderella: ['9eC6XMewadw', 'AplhjXDy638', 'xjiHiLXz7jA'],
  CharacterKey.elsa: [
    'jnTBCJo9OeY',
    '_MiOuZcy7T0',
    'ADVjMGwhjfg',
    'RUKi8_7RKa8',
  ],
  CharacterKey.hans: [],
  CharacterKey.judy: [],
  CharacterKey.rapunzel: [],
};
