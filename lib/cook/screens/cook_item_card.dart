import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wo_read/common/app_theme.dart';

import '../models/cook_item.dart';

class CookItemCard extends StatelessWidget {
  final CookItem cook;
  final bool isFeatured;

  const CookItemCard({super.key, required this.cook, this.isFeatured = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(isFeatured ? 24 : 16),
        border: Border.all(color: AppColors.surfaceContainerHigh, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [_ImageArea(cook: cook, isFeatured: isFeatured)]),
          _ContentArea(cook: cook, isFeatured: isFeatured),
        ],
      ),
    );
  }
}

class _ImageArea extends StatelessWidget {
  final CookItem cook;
  final bool isFeatured;

  const _ImageArea({required this.cook, required this.isFeatured});

  @override
  Widget build(BuildContext context) {
    final height = isFeatured ? 192.0 : 132.0;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildImage(),
          Positioned(top: isFeatured ? 16 : 8, left: isFeatured ? 16 : 8, child: _DateBadge(cook: cook, isFeatured: isFeatured)),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (cook.imageUrl.isEmpty) {
      return Container(
        color: AppColors.surfaceContainerHigh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.no_photography, size: 32, color: AppColors.outlineVariant),
            const SizedBox(height: 4),
            Text(
              '写真なし',
              style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: cook.imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: AppColors.surfaceContainerHigh,
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColors.surfaceContainerHigh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.no_photography, size: 32, color: AppColors.outlineVariant),
            const SizedBox(height: 4),
            Text(
              '写真なし',
              style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateBadge extends StatelessWidget {
  final CookItem cook;
  final bool isFeatured;

  const _DateBadge({required this.cook, required this.isFeatured});

  @override
  Widget build(BuildContext context) {
    final dateString =
        '${cook.date.month}/${cook.date.day.toString().padLeft(2, '0')} ${cook.category.label}';
    final iconSize = isFeatured ? 16.0 : 14.0;
    final fontSize = isFeatured ? 13.0 : 12.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isFeatured ? 12 : 8,
            vertical: isFeatured ? 4 : 2,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(cook.category.icon, size: iconSize, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                dateString,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContentArea extends StatelessWidget {
  final CookItem cook;
  final bool isFeatured;

  const _ContentArea({required this.cook, required this.isFeatured});

  @override
  Widget build(BuildContext context) {
    final hasComment = cook.aiComment != null && cook.aiComment!.isNotEmpty;

    return Padding(
      padding: EdgeInsets.all(isFeatured ? 16 : 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CategoryBadge(category: cook.category),
          if (hasComment) ...[
            SizedBox(height: isFeatured ? 8 : 6),
            Text(
              cook.aiComment!,
              style: TextStyle(
                fontSize: isFeatured ? 14 : 12,
                height: 1.5,
                color: AppColors.onSurfaceVariant,
              ),
              maxLines: isFeatured ? null : 2,
              overflow: isFeatured ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final CookCategory category;

  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg) = _badgeColors(category);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }

  (Color, Color) _badgeColors(CookCategory category) {
    return switch (category) {
      CookCategory.breakfast => (AppColors.tertiaryContainer.withValues(alpha: 0.3), AppColors.onTertiaryContainer),
      CookCategory.lunch => (AppColors.primaryContainer.withValues(alpha: 0.25), AppColors.onPrimaryContainer),
      CookCategory.box => (AppColors.primaryContainer.withValues(alpha: 0.25), AppColors.onPrimaryContainer),
      CookCategory.dinner => (AppColors.secondaryContainer.withValues(alpha: 0.35), AppColors.onSecondaryContainer),
      CookCategory.none => (AppColors.surfaceContainerHighest, AppColors.onSurfaceVariant),
    };
  }
}
