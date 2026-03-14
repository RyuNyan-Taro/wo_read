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

enum CookCategory { breakfast, lunch, box, dinner }