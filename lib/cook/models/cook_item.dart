import 'package:flutter/material.dart';
import 'package:wo_read/common/app_theme.dart';

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
  CookCategory.lunch: 'ランチ',
  CookCategory.box: 'お弁当',
  CookCategory.dinner: '夕食',
};

const Map<CookCategory, IconData> categoryToIcon = {
  CookCategory.none: Icons.calendar_today,
  CookCategory.breakfast: Icons.breakfast_dining,
  CookCategory.lunch: Icons.wb_sunny,
  CookCategory.box: Icons.lunch_dining,
  CookCategory.dinner: Icons.nights_stay,
};

extension CookCategoryX on CookCategory {
  String get label => categoryToJp[this] ?? '不明';

  IconData get icon => categoryToIcon[this] ?? Icons.calendar_today;

  Color get color => switch (this) {
    CookCategory.breakfast => AppColors.tertiaryContainer,
    CookCategory.lunch => AppColors.primaryContainer,
    CookCategory.box => AppColors.primaryContainer,
    CookCategory.dinner => AppColors.secondaryContainer,
    CookCategory.none => AppColors.surfaceContainerHighest,
  };
}
