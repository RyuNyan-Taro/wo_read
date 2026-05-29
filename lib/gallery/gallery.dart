import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wo_read/common/app_theme.dart';
import 'package:wo_read/gallery/models/gallery_item.dart';
import 'package:wo_read/gallery/screens/add_category_button.dart';
import 'package:wo_read/gallery/screens/add_image_button.dart';
import 'package:wo_read/gallery/screens/modify_category.dart';
import 'package:wo_read/gallery/service/gallery_service.dart';

class GalleryBody extends StatefulWidget {
  const GalleryBody({super.key});

  @override
  State<GalleryBody> createState() => _GalleryBodyState();
}

class _GalleryBodyState extends State<GalleryBody> {
  List<GalleryItem>? galleries;

  @override
  void initState() {
    super.initState();

    if (galleries == null) {
      _getGalleries();
    }
  }

  Future<void> _getGalleries() async {
    final GalleryService galleryService = GalleryService();
    final List<GalleryItem> items = await galleryService.getGalleryUrls();

    if (!mounted) return;

    setState(() {
      galleries = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        galleries == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._bentoGrid(galleries!),
                  ],
                ),
              ),
        Positioned(
          right: 16,
          bottom: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              addImageButton(context: context, returnAction: _getGalleries),
              const SizedBox(height: 12),
              addCategoryButton(context: context, returnAction: _getGalleries),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _bentoGrid(List<GalleryItem> galleries) {
    if (galleries.isEmpty) {
      return const [_EmptyGalleryState()];
    }

    final widgets = <Widget>[
      _tappableCard(galleries[0], isFeatured: true),
    ];

    final rest = galleries.skip(1).toList();
    for (var i = 0; i < rest.length; i += 2) {
      final left = rest[i];
      final right = i + 1 < rest.length ? rest[i + 1] : null;

      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _tappableCard(left, isFeatured: false)),
              const SizedBox(width: 12),
              Expanded(
                child: right != null
                    ? _tappableCard(right, isFeatured: false)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
    }

    return widgets;
  }

  Widget _tappableCard(GalleryItem gallery, {required bool isFeatured}) {
    return InkWell(
      borderRadius: BorderRadius.circular(isFeatured ? 24 : 16),
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ModifyCategoryPage(gallery: gallery);
            },
          ),
        );
        _getGalleries();
      },
      child: _GalleryPhotoCard(gallery: gallery, isFeatured: isFeatured),
    );
  }
}

class _GalleryPhotoCard extends StatelessWidget {
  final GalleryItem gallery;
  final bool isFeatured;

  const _GalleryPhotoCard({required this.gallery, required this.isFeatured});

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
      child: SizedBox(
        height: isFeatured ? 192 : 132,
        width: double.infinity,
        child: CachedNetworkImage(
          imageUrl: gallery.url,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.surfaceContainerHigh,
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.surfaceContainerHigh,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.no_photography,
                  size: 32,
                  color: AppColors.outlineVariant,
                ),
                SizedBox(height: 4),
                Text(
                  '写真なし',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyGalleryState extends StatelessWidget {
  const _EmptyGalleryState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 40,
            color: AppColors.outlineVariant,
          ),
          SizedBox(height: 8),
          Text(
            '写真がありません',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
