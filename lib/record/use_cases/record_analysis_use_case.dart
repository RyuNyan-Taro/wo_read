import 'package:wo_read/record/models/record_item.dart';

Map<FeelingType, int> countByFeelingType(List<RecordItem> records) {
  final counts = {for (final t in FeelingType.values) t: 0};
  for (final r in records) {
    counts[r.feeling] = counts[r.feeling]! + 1;
  }
  return counts;
}

Map<DenverType, int> countByDenverType(List<RecordItem> records) {
  final counts = {for (final t in DenverType.values) t: 0};
  for (final r in records) {
    counts[r.denver] = counts[r.denver]! + 1;
  }
  return counts;
}
