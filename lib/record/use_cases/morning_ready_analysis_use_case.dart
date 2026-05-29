import 'package:wo_read/record/models/morning_ready_record.dart';

enum MorningReadyComparisonStatus { noData, faster, slower, same }

class MorningReadyComparison {
  final MorningReadyComparisonStatus status;
  final int todayMinutes;
  final int? averageMinutes;
  final int? diffMinutes;
  final int sampleCount;

  const MorningReadyComparison({
    required this.status,
    required this.todayMinutes,
    required this.averageMinutes,
    required this.diffMinutes,
    required this.sampleCount,
  });
}

MorningReadyComparison compareWithPastAverage({
  required MorningReadyRecord target,
  required List<MorningReadyRecord> records,
  int sampleSize = 7,
}) {
  final pastRecords = records
      .where((record) => record.recordDate.isBefore(target.recordDate))
      .toList()
    ..sort((a, b) => b.recordDate.compareTo(a.recordDate));

  final samples = pastRecords.take(sampleSize).toList();
  if (samples.isEmpty) {
    return MorningReadyComparison(
      status: MorningReadyComparisonStatus.noData,
      todayMinutes: target.readyMinutes,
      averageMinutes: null,
      diffMinutes: null,
      sampleCount: 0,
    );
  }

  final average = (samples.fold<int>(
            0,
            (sum, record) => sum + record.readyMinutes,
          ) /
          samples.length)
      .round();
  final diff = target.readyMinutes - average;

  return MorningReadyComparison(
    status: _statusFromDiff(diff),
    todayMinutes: target.readyMinutes,
    averageMinutes: average,
    diffMinutes: diff,
    sampleCount: samples.length,
  );
}

int? calculateRecentAverageMinutes(
  List<MorningReadyRecord> records, {
  int sampleSize = 7,
}) {
  final samples = records.take(sampleSize).toList();
  if (samples.isEmpty) {
    return null;
  }

  return (samples.fold<int>(0, (sum, record) => sum + record.readyMinutes) /
          samples.length)
      .round();
}

String formatMinutes(int minutes) {
  final hour = minutes ~/ 60;
  final minute = (minutes % 60).toString().padLeft(2, '0');
  return '$hour:$minute';
}

String formatDiffMinutes(int diffMinutes) {
  final absDiff = diffMinutes.abs();
  if (absDiff == 0) {
    return '平均どおり';
  }

  return '$absDiff分${diffMinutes < 0 ? '早い' : '遅い'}';
}

MorningReadyComparisonStatus _statusFromDiff(int diffMinutes) {
  if (diffMinutes < 0) {
    return MorningReadyComparisonStatus.faster;
  }
  if (diffMinutes > 0) {
    return MorningReadyComparisonStatus.slower;
  }
  return MorningReadyComparisonStatus.same;
}
