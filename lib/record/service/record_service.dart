import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wo_read/record/models/record_item.dart';
import 'package:wo_read/record/use_cases/convert_enum_use_case.dart';

const String _tableName = 'glow_record';

class RecordService {
  final _supabase = Supabase.instance.client;

  Future<List<RecordItem>> getRecords() async {
    final List<Map<String, dynamic>> response = await _supabase
        .from(_tableName)
        .select()
        .order('timestamp', ascending: false)
        .limit(100);

    return response
        .map(
          (data) => RecordItem(
            id: data['id'],
            date: DateTime.parse(data['timestamp']),
            content: data['content'],
            feeling: convertToFeelingType(label: data['feeling']),
            denver: convertToDenverType(label: data['denver']),
          ),
        )
        .toList();
  }

  Future<void> addRecord({
    required DateTime date,
    required String content,
    required LabelResult labels,
  }) async {
    await _supabase.from(_tableName).insert({
      'timestamp': date.toString(),
      'content': content,
      'feeling': labels.feeling.name,
      'denver': labels.denver.name,
    });
  }

  Future<void> updateRecord({
    required int id,
    required DateTime date,
    required String content,
    required FeelingType feeling,
    required DenverType denver,
  }) async {
    await _supabase
        .from(_tableName)
        .update({
          'timestamp': date.toString(),
          'content': content,
          'feeling': feeling.name,
          'denver': denver.name,
        })
        .eq('id', id);
  }

  Future<void> deleteRecord({required int id}) async {
    await _supabase.from(_tableName).delete().eq('id', id);
  }
}
