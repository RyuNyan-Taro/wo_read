import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wo_read/common/app_theme.dart';
import 'package:wo_read/record/models/morning_ready_record.dart';
import 'package:wo_read/record/use_cases/morning_ready_analysis_use_case.dart';

class MorningReadySection extends StatelessWidget {
  final List<MorningReadyRecord> records;
  final bool isSaving;
  final Future<void> Function() onRecord;

  const MorningReadySection({
    super.key,
    required this.records,
    required this.isSaving,
    required this.onRecord,
  });

  @override
  Widget build(BuildContext context) {
    final todayRecord = _todayRecord(records);
    final hasTodayRecord = todayRecord != null;
    final comparison = todayRecord == null
        ? null
        : compareWithPastAverage(target: todayRecord, records: records);
    final averageMinutes = comparison?.averageMinutes ??
        calculateRecentAverageMinutes(records);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(),
          const SizedBox(height: 16),
          _TodayPanel(
            todayRecord: todayRecord,
            comparison: comparison,
            averageMinutes: averageMinutes,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: hasTodayRecord || isSaving ? null : onRecord,
              icon: isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(hasTodayRecord ? Icons.check : Icons.touch_app),
              label: Text(hasTodayRecord ? '今日は記録済み' : '今の時刻で記録'),
            ),
          ),
          if (records.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              '履歴',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 16,
                  ),
            ),
            const SizedBox(height: 8),
            ...records.take(10).map(
                  (record) => _HistoryRow(
                    record: record,
                    comparison: compareWithPastAverage(
                      target: record,
                      records: records,
                    ),
                  ),
                ),
          ],
        ],
      ),
    );
  }

  MorningReadyRecord? _todayRecord(List<MorningReadyRecord> records) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final record in records) {
      if (_isSameDate(record.recordDate, today)) {
        return record;
      }
    }
    return null;
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.alarm_on,
          color: AppColors.secondary,
          size: 22,
        ),
        const SizedBox(width: 6),
        Text(
          '朝の準備',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }
}

class _TodayPanel extends StatelessWidget {
  final MorningReadyRecord? todayRecord;
  final MorningReadyComparison? comparison;
  final int? averageMinutes;

  const _TodayPanel({
    required this.todayRecord,
    required this.comparison,
    required this.averageMinutes,
  });

  @override
  Widget build(BuildContext context) {
    final record = todayRecord;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: record == null
          ? _UnrecordedSummary(averageMinutes: averageMinutes)
          : _RecordedSummary(record: record, comparison: comparison),
    );
  }
}

class _UnrecordedSummary extends StatelessWidget {
  final int? averageMinutes;

  const _UnrecordedSummary({required this.averageMinutes});

  @override
  Widget build(BuildContext context) {
    final average = averageMinutes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '今日の準備完了はまだ未記録です',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          average == null
              ? '記録すると、次回から過去7件平均との差を表示します。'
              : '過去7件平均は ${formatMinutes(average)} です。',
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}

class _RecordedSummary extends StatelessWidget {
  final MorningReadyRecord record;
  final MorningReadyComparison? comparison;

  const _RecordedSummary({
    required this.record,
    required this.comparison,
  });

  @override
  Widget build(BuildContext context) {
    final comparison = this.comparison;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formatMinutes(record.readyMinutes),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 36,
                color: AppColors.secondary,
              ),
        ),
        const SizedBox(height: 8),
        if (comparison == null ||
            comparison.status == MorningReadyComparisonStatus.noData)
          Text(
            '比較データなし',
            style: Theme.of(context).textTheme.labelMedium,
          )
        else
          _ComparisonText(comparison: comparison),
      ],
    );
  }
}

class _ComparisonText extends StatelessWidget {
  final MorningReadyComparison comparison;

  const _ComparisonText({required this.comparison});

  @override
  Widget build(BuildContext context) {
    final average = comparison.averageMinutes;
    final diff = comparison.diffMinutes;
    if (average == null || diff == null) {
      return Text(
        '比較データなし',
        style: Theme.of(context).textTheme.labelMedium,
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _Pill(label: formatDiffMinutes(diff), color: _comparisonColor(diff)),
        Text(
          '過去${comparison.sampleCount}件平均 ${formatMinutes(average)}',
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }

  Color _comparisonColor(int diff) {
    if (diff < 0) {
      return AppColors.secondary;
    }
    if (diff > 0) {
      return AppColors.tertiary;
    }
    return AppColors.outline;
  }
}

class _HistoryRow extends StatelessWidget {
  final MorningReadyRecord record;
  final MorningReadyComparison comparison;

  const _HistoryRow({
    required this.record,
    required this.comparison,
  });

  @override
  Widget build(BuildContext context) {
    final diff = comparison.diffMinutes;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.wb_sunny_outlined,
              size: 18,
              color: AppColors.tertiary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('yyyy/MM/dd').format(record.recordDate),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Text(
                  diff == null ? '比較データなし' : formatDiffMinutes(diff),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.outline,
                        fontSize: 12,
                      ),
                ),
              ],
            ),
          ),
          Text(
            formatMinutes(record.readyMinutes),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color color;

  const _Pill({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

bool _isSameDate(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
