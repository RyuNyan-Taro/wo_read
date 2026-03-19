import 'package:flutter/material.dart';

class CookItem {
  final int id;
  final CookCategory category;
  final String imageUrl;
  final DateTime date;
  final String? aiComment;

  const CookItem({
    required this.id,
    required this.category,
    required this.imageUrl,
    required this.date,
    this.aiComment,
  });
}

enum CookCategory { none, breakfast, lunch, box, dinner }

const Map<CookCategory, String> categoryToJp = {
  CookCategory.none: '無',
  CookCategory.breakfast: '朝食',
  CookCategory.lunch: '昼食',
  CookCategory.box: '弁当',
  CookCategory.dinner: '夕食',
};

const Map<CookCategory, Color> categoryToColor = {
  CookCategory.none: Colors.black,
  CookCategory.breakfast: Colors.orange,
  CookCategory.lunch: Colors.blue,
  CookCategory.box: Colors.green,
  CookCategory.dinner: Colors.indigo,
};
