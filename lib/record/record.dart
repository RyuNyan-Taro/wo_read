import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:wo_read/common/add_record_button.dart';
import 'package:wo_read/common/app_theme.dart';
import 'package:wo_read/record/models/record_item.dart';
import 'package:wo_read/record/screens/modify_record.dart';
import 'package:wo_read/record/service/record_service.dart';
import 'package:wo_read/record/screens/record_analysis_section.dart';
import 'package:wo_read/record/use_cases/lunar_age_use_case.dart';

class RecordBody extends StatefulWidget {
  const RecordBody({super.key});

  @override
  State<RecordBody> createState() => _RecordBodyState();
}

class _RecordBodyState extends State<RecordBody> {
  List<RecordItem>? records;

  @override
  void initState() {
    super.initState();

    if (records == null) {
      _getRecords();
    }
  }

  Future<void> _getRecords() async {
    final RecordService recordService = RecordService();
    final List<RecordItem> items = await recordService.getRecords();

    setState(() {
      records = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        records == null
            ? const Center(child: CircularProgressIndicator())
            : _recordsSet(records!, _getRecords),
        Positioned(
          right: 16,
          bottom: 20,
          child: addRecordButton(context: context, returnAction: _getRecords),
        ),
      ],
    );
  }
}

Widget _recordsSet(List<RecordItem> records, Function() backAction) {
  final DateTime birthday = DateTime.parse(
    dotenv.env['CHILD_BIRTHDAY'] ?? '1970-01-01 00:00:00',
  );

  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RecordAnalysisSection(records: records),
          const SizedBox(height: 48),
          _buildSectionHeader(Icons.history_edu, '日々の活動', AppColors.outlineVariant),
          const SizedBox(height: 12),
          _RecordTimeline(
            records: records,
            backAction: backAction,
            birthday: birthday,
          ),
        ],
      ),
    ),
  );
}

Widget _buildSectionHeader(IconData icon, String title, Color iconColor) {
  return Row(
    children: [
      Icon(icon, color: iconColor, size: 22),
      const SizedBox(width: 6),
      Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
      ),
    ],
  );
}

class _RecordTimeline extends StatelessWidget {
  final List<RecordItem> records;
  final Function() backAction;
  final DateTime birthday;

  const _RecordTimeline({
    required this.records,
    required this.backAction,
    required this.birthday,
  });

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const Center(child: Text('記録がありません'));
    }

    return Column(
      children: List.generate(records.length, (index) {
        final record = records[index];
        final isLast = index == records.length - 1;
        final dotColor = _feelingDotColor(record.feeling);

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
                child: Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: dotColor.withValues(alpha: 0.4),
                            blurRadius: 0,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Center(
                          child: Container(
                            width: 1,
                            color: AppColors.outlineVariant.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 32),
                  child: _TimelineItem(
                    record: record,
                    backAction: backAction,
                    birthday: birthday,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final RecordItem record;
  final Function() backAction;
  final DateTime birthday;

  const _TimelineItem({
    required this.record,
    required this.backAction,
    required this.birthday,
  });

  @override
  Widget build(BuildContext context) {
    final lunarAge = convertToLunarAge(
      datetime: record.date,
      birthday: birthday,
    );
    final relativeDate = _formatRelativeDate(record.date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${lunarAge.year}歳 ${lunarAge.month}ヶ月 • $relativeDate',
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: AppColors.outline),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ModifyRecordPage(recordItem: record),
              ),
            );
            backAction();
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.content,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                if (record.denver != DenverType.none ||
                    record.feeling != FeelingType.none) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      if (record.feeling != FeelingType.none)
                        _TagChip(
                          label: '#${feelingToJp[record.feeling] ?? ''}',
                          bgColor: _feelingChipBgColor(record.feeling),
                          fgColor: _feelingChipFgColor(record.feeling),
                        ),
                      if (record.denver != DenverType.none)
                        _TagChip(
                          label: '#${denverToJp[record.denver] ?? ''}',
                          bgColor: _denverChipBgColor(record.denver),
                          fgColor: _denverChipFgColor(record.denver),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color fgColor;

  const _TagChip({
    required this.label,
    required this.bgColor,
    required this.fgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: fgColor,
        ),
      ),
    );
  }
}

String _formatRelativeDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final d = DateTime(date.year, date.month, date.day);
  final timeStr = DateFormat('HH:mm').format(date);
  if (d == today) return '今日 $timeStr';
  if (d == today.subtract(const Duration(days: 1))) return '昨日 $timeStr';
  return DateFormat('MM/dd').format(date);
}

Color _feelingDotColor(FeelingType feeling) {
  switch (feeling) {
    case FeelingType.pleasure:
      return AppColors.primaryContainer;
    case FeelingType.happiness:
      return AppColors.tertiaryContainer;
    case FeelingType.sorrow:
      return AppColors.secondaryContainer;
    case FeelingType.anger:
      return AppColors.errorContainer;
    case FeelingType.none:
      return AppColors.outlineVariant;
  }
}

Color _feelingChipBgColor(FeelingType feeling) {
  switch (feeling) {
    case FeelingType.pleasure:
      return AppColors.primaryContainer.withValues(alpha: 0.1);
    case FeelingType.happiness:
      return AppColors.tertiaryContainer.withValues(alpha: 0.2);
    case FeelingType.sorrow:
      return AppColors.secondaryContainer.withValues(alpha: 0.2);
    case FeelingType.anger:
      return AppColors.errorContainer.withValues(alpha: 0.2);
    case FeelingType.none:
      return AppColors.surfaceContainerHighest;
  }
}

Color _feelingChipFgColor(FeelingType feeling) {
  switch (feeling) {
    case FeelingType.pleasure:
      return AppColors.primary;
    case FeelingType.happiness:
      return AppColors.tertiary;
    case FeelingType.sorrow:
      return AppColors.secondary;
    case FeelingType.anger:
      return AppColors.error;
    case FeelingType.none:
      return AppColors.onSurfaceVariant;
  }
}

Color _denverChipBgColor(DenverType denver) {
  switch (denver) {
    case DenverType.personalSocial:
    case DenverType.grossMotor:
      return AppColors.primaryContainer.withValues(alpha: 0.1);
    case DenverType.fineMotorAdaptive:
      return AppColors.secondaryContainer.withValues(alpha: 0.2);
    case DenverType.language:
      return AppColors.tertiaryContainer.withValues(alpha: 0.2);
    case DenverType.none:
      return AppColors.surfaceContainerHighest;
  }
}

Color _denverChipFgColor(DenverType denver) {
  switch (denver) {
    case DenverType.personalSocial:
    case DenverType.grossMotor:
      return AppColors.primary;
    case DenverType.fineMotorAdaptive:
      return AppColors.secondary;
    case DenverType.language:
      return AppColors.tertiary;
    case DenverType.none:
      return AppColors.onSurfaceVariant;
  }
}
