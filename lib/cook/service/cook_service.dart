import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wo_read/cook/models/cook_item.dart';

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
            url: '$url/$directory/${data['name']}',
            category: data['category'],
            createdAt: data['createdAt'],
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

    await _supabase.storage.from('cooks').upload(savePath, pickedImage);
    print('fin save image');

    final categoryValue = category.toString().split('.').last;
    print({
      'name': savePath,
      'category': categoryValue,
      'createdAt': createdAt.toIso8601String(),
    });
    await _supabase.from('cook_record').insert({
      'name': savePath,
      'category': categoryValue,
      'createdAt': createdAt.toIso8601String(),
    });
    print('fin save data');
  }
}
