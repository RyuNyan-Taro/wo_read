import 'package:flutter/material.dart';
import '../models/cook_item.dart';


class CookItemCard extends StatelessWidget {
  final CookItem cook;

  const CookItemCard({super.key, required this.cook});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(
                cook.url,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                // 画像読み込みエラー時のフォールバック
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 50),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: _buildCategoryBadge(cook.category),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recipe ID: ${cook.id}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge(CookCategory category) {
    Color color;
    String label;

    switch (category) {
      case CookCategory.breakfast:
        color = Colors.orange;
        label = '朝食';
        break;
      case CookCategory.lunch:
        color = Colors.blue;
        label = 'ランチ';
        break;
      case CookCategory.box:
        color = Colors.green;
        label = 'お弁当';
        break;
      case CookCategory.dinner:
        color = Colors.indigo;
        label = '夕食';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}