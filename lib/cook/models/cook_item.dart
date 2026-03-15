class CookItem {
  final int id;
  final CookCategory category;
  final String url;
  final DateTime createdAt;

  const CookItem({
    required this.id,
    required this.category,
    required this.url,
    required this.createdAt,
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
