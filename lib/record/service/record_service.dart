import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wo_read/record/models/record_item.dart';

class RecordService {
  final _supabase = Supabase.instance.client;

  Future<List<RecordItem>> getRecords() async {
    final List<Map<String, dynamic>> response = await _supabase
        .from('glow_record')
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
}
