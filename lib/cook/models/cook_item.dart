class CookItem {
  final int id;
  final CookCategory category;
  final String url;

  const CookItem({required this.id, required this.category, required this.url});
}

enum CookCategory { breakfast, lunch, box, dinner }
