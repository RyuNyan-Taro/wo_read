import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wo_read/record/models/morning_ready_record.dart';

const String _tableName = 'morning_ready_records';

class MorningReadyService {
  final _supabase = Supabase.instance.client;

  Future<List<MorningReadyRecord>> getRecords({int limit = 60}) async {
    final List<Map<String, dynamic>> response = await _supabase
        .from(_tableName)
        .select()
        .order('record_date', ascending: false)
        .limit(limit);

    return response.map(_fromJson).toList();
  }

  Future<void> addTodayReady(DateTime now) async {
    final recordDate = _dateOnly(now);

    await _supabase.from(_tableName).insert({
      'record_date': _formatDate(recordDate),
      'ready_at': now.toIso8601String(),
      'ready_minutes': now.hour * 60 + now.minute,
    });
  }

  bool hasTodayRecord(List<MorningReadyRecord> records, DateTime now) {
    final today = _dateOnly(now);
    return records.any((record) => _isSameDate(record.recordDate, today));
  }

  MorningReadyRecord _fromJson(Map<String, dynamic> data) {
    return MorningReadyRecord(
      id: data['id'],
      recordDate: _dateOnly(DateTime.parse(data['record_date'])),
      readyAt: DateTime.parse(data['ready_at']).toLocal(),
      readyMinutes: data['ready_minutes'],
    );
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
