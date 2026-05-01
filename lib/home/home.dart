import 'package:flutter/material.dart';
import 'package:wo_read/common/add_record_button.dart';
import 'package:wo_read/cook/screens/add_cook_button.dart';
import 'package:wo_read/hair/hair.dart';
import 'package:wo_read/hiragana/hiragana.dart';
import 'package:wo_read/shape_move/shape_move.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onSelectTab});

  final ValueChanged<int> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HeroCard(
              title: '成長記録',
              subtitle: '今日のお子様の様子や活動を記録しましょう',
              icon: Icons.child_care,
              onTap: () => onSelectTab(1),
            ),
            const SizedBox(height: 12),
            _HeroCard(
              title: '料理・献立',
              subtitle: '作った料理を記録しましょう',
              icon: Icons.restaurant,
              onTap: () => onSelectTab(2),
            ),
            const SizedBox(height: 20),
            _FeatureGrid(
              items: [
                _FeatureItem(
                  label: 'ギャラリー',
                  icon: Icons.photo_library,
                  onTap: () => onSelectTab(3),
                ),
                _FeatureItem(
                  label: 'ヘアカタログ',
                  icon: Icons.content_cut,
                  page: const HairPage(),
                ),
                _FeatureItem(
                  label: 'かるた',
                  icon: Icons.style,
                  page: const HiraganaPage(),
                ),
                _FeatureItem(
                  label: 'ジェスチャー',
                  icon: Icons.waving_hand,
                  page: const ShapeMovePage(),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          addCookButton(context: context),
          const SizedBox(width: 8),
          addRecordButton(context: context),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cs.primaryContainer.withOpacity(0.15),
          border: Border.all(color: cs.primaryContainer.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: cs.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: cs.primary, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem {
  const _FeatureItem({
    required this.label,
    required this.icon,
    this.page,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final Widget? page;
  final VoidCallback? onTap;
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid({required this.items});

  final List<_FeatureItem> items;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: items.map((item) => _FeatureCell(item: item)).toList(),
    );
  }
}

class _FeatureCell extends StatelessWidget {
  const _FeatureCell({required this.item});

  final _FeatureItem item;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap:
          item.onTap ??
          () {
            final page = item.page;
            if (page == null) {
              return;
            }

            Navigator.push(context, MaterialPageRoute(builder: (_) => page));
          },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          border: Border.all(color: cs.outlineVariant.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: cs.surfaceContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Text(item.label, style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}
