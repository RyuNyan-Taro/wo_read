import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wo_read/record/models/record_item.dart';

const String _tableName = 'glow_record';

class RecordService {
  final _supabase = Supabase.instance.client;

  Future<List<RecordItem>> getRecords() async {
    final List<Map<String, dynamic>> response = await _supabase
        .from(_tableName)
        .select();

    return response
        .map(
          (data) => RecordItem(
            date: DateTime.parse(data['timestamp']),
            content: data['content'],
          ),
        )
        .toList();
  }

  Future<void> addRecord({
    required DateTime date,
    required String content,
  }) async {
    await _supabase.from(_tableName).insert({
      'timestamp': date.toString(),
      'content': content,
    });
  }
}
