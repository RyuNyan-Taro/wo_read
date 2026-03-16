import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wo_read/cook/models/cook_item.dart';
import 'package:wo_read/cook/use_cases/convert_enum_use_case.dart';

class CookService {
  final _supabase = SupabaseClient(
    dotenv.env['SUPABASE_PROJECT_URL'] ?? '',
    dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  Future<List<CookItem>> getCookUrls() async {
    final PostgrestList response = await _supabase
        .from('cook_record')
        .select()
        .limit(100);
    final String url = dotenv.env['SUPABASE_PROJECT_URL'] ?? '';
    final String directory = dotenv.env['SUPABASE_COOK_DIRECTORY'] ?? '';

    return response
        .map(
          (data) => CookItem(
            id: data['id'],
            imageUrl: '$url/$directory/${data['name']}',
            category: convertToCookCategory(label: data['category']),
            date: DateTime.parse(data['createdAt']),
          ),
        )
        .toList();
  }

  Future<void> addCook(
    String filePath,
    CookCategory category,
    DateTime createdAt,
  ) async {
    final File pickedImage = File(filePath);
    final String savePath = filePath.split('/').last;
    final categoryValue = category.toString().split('.').last;

    await _supabase.storage.from('cooks').upload(savePath, pickedImage);
    await _supabase.from('cook_record').insert({
      'name': savePath,
      'category': categoryValue,
      'createdAt': createdAt.toIso8601String(),
    });
  }

  Future<void> updateCook(
    int id,
    String? filePath,
    CookCategory category,
    DateTime createdAt,
  ) async {
    final Map<String, dynamic> updateData = {
      'category': category.name,
      'createdAt': createdAt.toIso8601String(),
    };

    if (filePath != null) {
      final File pickedImage = File(filePath);
      final String savePath = filePath.split('/').last;

      await _supabase.storage.from('cooks').upload(savePath, pickedImage);
      updateData['name'] = savePath;
    }

    await _supabase.from('cook_record').update(updateData).eq('id', id);
  }
}
