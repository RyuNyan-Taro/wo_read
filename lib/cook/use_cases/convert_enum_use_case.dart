import 'package:wo_read/cook/models/cook_item.dart';

CookCategory convertToCookCategory({required String label}) {
  final CookCategory feeling = CookCategory.values.firstWhere(
    (e) => e.name == label,
    orElse: () => CookCategory.none,
  );

  return feeling;
}
