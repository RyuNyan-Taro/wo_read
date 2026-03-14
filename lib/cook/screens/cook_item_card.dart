import 'package:flutter/material.dart';
import '../models/cook_item.dart';

class CookItemCard extends StatelessWidget {
  final CookItem cook;

  const CookItemCard({super.key, required this.cook});

  @override
  Widget build(BuildContext context) {

    return Card(

      // card design parameters
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      color: Colors.grey[50],
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

      // card contents
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              _cookImage(cook.url),
              _cookLabels(cook)
            ],
          ),
        ],
      ),
    );
  }
}

Widget _cookImage(String url) {

  return AspectRatio(
    aspectRatio: 16 / 9,
    child: Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey[200],
        child: const Icon(Icons.restaurant, color: Colors.white, size: 40),
      ),
    ),
  );
}

Widget _cookLabels(CookItem cook) {

  Widget buildCategoryBadge(CookCategory category) {
    final (Color color, String label) = switch (category) {
      CookCategory.breakfast => (Colors.orange, '朝食'),
      CookCategory.lunch => (Colors.blue, 'ランチ'),
      CookCategory.box => (Colors.green, 'お弁当'),
      CookCategory.dinner => (Colors.indigo, '夕食'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildDateBadge(DateTime date) {
    final String dateString =
        "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.calendar_today, size: 10, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            dateString,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  return Positioned(
    top: 12,
    left: 12,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildCategoryBadge(cook.category),
        const SizedBox(height: 8),
        buildDateBadge(cook.createdAt),
      ],
    ),
  );
}
