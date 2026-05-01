import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wo_read/common/app_theme.dart';
import 'package:wo_read/record/models/record_item.dart';
import 'package:wo_read/record/use_cases/record_analysis_use_case.dart';

class RecordAnalysisSection extends StatelessWidget {
  final List<RecordItem> records;

  const RecordAnalysisSection({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return Card(
        color: AppColors.surfaceContainerLowest,
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: Text('データなし')),
        ),
      );
    }

    return Column(
      children: [
        _FeelingDonutChart(records: records),
        const SizedBox(height: 32),
        _DenverProgressBars(records: records),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 6),
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}

class _FeelingDonutChart extends StatelessWidget {
  final List<RecordItem> records;

  const _FeelingDonutChart({required this.records});

  static const Map<FeelingType, Color> _colors = {
    FeelingType.none: AppColors.outlineVariant,
    FeelingType.happiness: AppColors.tertiaryContainer,
    FeelingType.anger: AppColors.errorContainer,
    FeelingType.sorrow: AppColors.secondaryContainer,
    FeelingType.pleasure: AppColors.primaryContainer,
  };

  @override
  Widget build(BuildContext context) {
    final counts = countByFeelingType(records);
    final total = FeelingType.values
        .where((t) => t != FeelingType.none)
        .fold(0, (sum, t) => sum + (counts[t] ?? 0));

    final sections = FeelingType.values
        .where((t) => t != FeelingType.none && (counts[t] ?? 0) > 0)
        .map((t) => PieChartSectionData(
              color: _colors[t] ?? AppColors.outlineVariant,
              value: (counts[t] ?? 0).toDouble(),
              title: '',
              radius: 32,
            ))
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF9E7A).withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            icon: Icons.mood,
            title: '感情バランス',
            iconColor: AppColors.primaryContainer,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 128,
                height: 128,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        centerSpaceRadius: 32,
                        sections: sections.isEmpty
                            ? [
                                PieChartSectionData(
                                  color: AppColors.outlineVariant,
                                  value: 1,
                                  title: '',
                                  radius: 32,
                                )
                              ]
                            : sections,
                        sectionsSpace: 2,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '記録数',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: AppColors.outline),
                        ),
                        Text(
                          '$total',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: FeelingType.values
                      .where((t) => t != FeelingType.none && (counts[t] ?? 0) > 0)
                      .map((t) {
                    final count = counts[t] ?? 0;
                    final pct = total > 0 ? (count / total * 100).round() : 0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: _colors[t] ?? AppColors.outlineVariant,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                feelingToJp[t] ?? '',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                          Text(
                            '$pct%',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DenverProgressBars extends StatelessWidget {
  final List<RecordItem> records;

  const _DenverProgressBars({required this.records});

  static const Map<DenverType, Color> _barColors = {
    DenverType.personalSocial: AppColors.primaryContainer,
    DenverType.fineMotorAdaptive: AppColors.secondaryContainer,
    DenverType.language: AppColors.tertiaryContainer,
    DenverType.grossMotor: Color(0xFFFFB59B),
  };

  @override
  Widget build(BuildContext context) {
    final counts = countByDenverType(records);
    final types = DenverType.values.where((t) => t != DenverType.none).toList();
    final maxCount =
        types.map((t) => counts[t] ?? 0).reduce((a, b) => a > b ? a : b);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF9E7A).withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            icon: Icons.psychology,
            title: '発達バランス',
            iconColor: AppColors.secondaryContainer,
          ),
          const SizedBox(height: 12),
          ...types.map((t) {
            final count = counts[t] ?? 0;
            final widthFactor =
                maxCount > 0 ? (count / maxCount).clamp(0.0, 1.0) : 0.0;
            final barColor = _barColors[t] ?? AppColors.outlineVariant;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        denverToJp[t] ?? '',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: AppColors.onSurface),
                      ),
                      Text(
                        '$count',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: AppColors.outline, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 12,
                            width: constraints.maxWidth,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          if (widthFactor > 0)
                            FractionallySizedBox(
                              widthFactor: widthFactor,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: barColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  Positioned(
                                    right: 2,
                                    top: 0,
                                    bottom: 0,
                                    child: Center(
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.15),
                                              blurRadius: 4,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
