import 'package:wo_read/hiragana/models/example.dart';

class JapaneseData {
  static final List<String> hiraganaList = [
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

  static final Map<int, Example> examples = {
    0: Example(reading: "あめ", imagePath: "assets/images/hiragana/rain.png"),
    1: Example(reading: "いぬ", imagePath: "assets/images/hiragana/dog.png"),
    2: Example(reading: "うさぎ", imagePath: "assets/images/hiragana/rabbit.png"),
    3: Example(reading: "えんぴつ", imagePath: "assets/images/hiragana/pen.png"),
    4: Example(reading: "おかし", imagePath: "assets/images/hiragana/foods.png"),
    5: Example(reading: "かさ", imagePath: "assets/images/hiragana/umbrella.png"),
    6: Example(reading: "きつね", imagePath: "assets/images/hiragana/fox.png"),
    7: Example(
      reading: "くまくらいしさく",
      imagePath: "assets/images/hiragana/bear.png",
    ),
    8: Example(reading: "けーき", imagePath: "assets/images/hiragana/cake.png"),
    9: Example(reading: "こおり", imagePath: "assets/images/hiragana/ice.png"),
    10: Example(reading: "さく", imagePath: "assets/images/hiragana/saku.jpeg"),
    11: Example(reading: "しか", imagePath: "assets/images/hiragana/deer.png"),
    12: Example(reading: "すし", imagePath: "assets/images/hiragana/sushi.png"),
    13: Example(
      reading: "せんべい",
      imagePath: "assets/images/hiragana/senbei.png",
    ),
    14: Example(reading: "そら", imagePath: "assets/images/hiragana/sky.jpg"),
    15: Example(
      reading: "たこ",
      imagePath: "assets/images/hiragana/character_takoyaki_tako.png",
    ),
    16: Example(
      reading: "ちず",
      imagePath: "assets/images/hiragana/map_book_chizuchou.png",
    ),
    17: Example(reading: "つき", imagePath: "assets/images/hiragana/moon.jpeg"),
    18: Example(
      reading: "てぶくろ",
      imagePath: "assets/images/hiragana/tebukuro.png",
    ),
    19: Example(
      reading: "とり",
      imagePath: "assets/images/hiragana/bird_aoitori_bluebird.png",
    ),
    20: Example(
      reading: "なす",
      imagePath: "assets/images/hiragana/vegetable_kyouyasai_kamonasu.png",
    ),
    21: Example(
      reading: "にわとり",
      imagePath: "assets/images/hiragana/bird_niwatori_chabo.png",
    ),
    22: Example(
      reading: "ぬいぐるみ",
      imagePath: "assets/images/hiragana/toy_omocha_asobu_girl_oyako.png",
    ),
    23: Example(
      reading: "ねこ",
      imagePath: "assets/images/hiragana/monogatari_alice_cheshire_neko.png",
    ),
    24: Example(
      reading: "のり",
      imagePath: "assets/images/hiragana/food_nori.png",
    ),
    25: Example(
      reading: "はな",
      imagePath: "assets/images/hiragana/valentinesday_rose.png",
    ),
    26: Example(
      reading: "ひこうき",
      imagePath: "assets/images/hiragana/airplane.png",
    ),
    27: Example(
      reading: "ふね",
      imagePath: "assets/images/hiragana/norimono_character2_fune.png",
    ),
    28: Example(
      reading: "へび",
      imagePath: "assets/images/hiragana/hebi_blue.png",
    ),
    29: Example(
      reading: "ほし",
      imagePath: "assets/images/hiragana/christmas_star.png",
    ),
    30: Example(reading: "まめ", imagePath: "assets/images/hiragana/edamame.png"),
    31: Example(
      reading: "みかん",
      imagePath: "assets/images/hiragana/fruit_orange2.png",
    ),
    32: Example(
      reading: "むし",
      imagePath: "assets/images/hiragana/bug_mark07_kanabun.png",
    ),
    33: Example(
      reading: "メロメロパンチ",
      imagePath: "assets/images/hiragana/meromero_panch.jpg",
    ),
    34: Example(
      reading: "もも",
      imagePath: "assets/images/hiragana/fruit_momo.png",
    ),
    35: Example(
      reading: "やま",
      imagePath: "assets/images/hiragana/bg_hatake.jpg",
    ),
    36: Example(
      reading: "ゆき",
      imagePath: "assets/images/hiragana/yuki_title.png",
    ),
    37: Example(
      reading: "よる",
      imagePath: "assets/images/hiragana/time4_yoru.png",
    ),
    38: Example(
      reading: "らいおん",
      imagePath: "assets/images/hiragana/animal_barbary_lion.png",
    ),
    39: Example(
      reading: "りんご",
      imagePath: "assets/images/hiragana/ringo_shin.png",
    ),
    40: Example(
      reading: "るびー",
      imagePath: "assets/images/hiragana/yubiwa_ruby.png",
    ),
    41: Example(
      reading: "れもん",
      imagePath: "assets/images/hiragana/fruit_lemon_tategiri.png",
    ),
    42: Example(
      reading: "ろうそく",
      imagePath: "assets/images/hiragana/rousoku_you.png",
    ),
    43: Example(
      reading: "わに",
      imagePath: "assets/images/hiragana/wani_open.png",
    ),
    44: Example(reading: "をとこ", imagePath: "assets/images/hiragana/man.png"),
    45: Example(
      reading: "えんぴつ",
      imagePath: "assets/images/hiragana/big_pen.png",
    ),
    46: Example(reading: "がっこう", imagePath: ""),
    47: Example(reading: "ぎんこう", imagePath: ""),
    48: Example(reading: "ぐんて", imagePath: ""),
    49: Example(reading: "げーむ", imagePath: ""),
    50: Example(reading: "ごはん", imagePath: ""),
    51: Example(reading: "ざっそう", imagePath: ""),
    52: Example(reading: "じてんしゃ", imagePath: ""),
    53: Example(reading: "ずぼん", imagePath: ""),
    54: Example(reading: "ぜんぶ", imagePath: ""),
    55: Example(reading: "ぞう", imagePath: ""),
    56: Example(reading: "だいこん", imagePath: ""),
    57: Example(reading: "ぢしん", imagePath: ""),
    58: Example(reading: "づくえ", imagePath: ""),
    59: Example(reading: "でんき", imagePath: ""),
    60: Example(reading: "どあ", imagePath: ""),
    61: Example(reading: "ばす", imagePath: ""),
    62: Example(reading: "びーる", imagePath: ""),
    63: Example(reading: "ぶた", imagePath: ""),
    64: Example(reading: "べんとう", imagePath: ""),
    65: Example(reading: "ぼうし", imagePath: ""),
    66: Example(reading: "ぱん", imagePath: ""),
    67: Example(reading: "ぴざ", imagePath: ""),
    68: Example(reading: "ぷーる", imagePath: ""),
    69: Example(reading: "ぺん", imagePath: ""),
    70: Example(reading: "ぽすと", imagePath: ""),
  };
}
