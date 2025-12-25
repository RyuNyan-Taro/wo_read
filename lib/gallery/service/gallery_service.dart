import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wo_read/gallery/models/gallery_item.dart';

class GalleryService {
  final _supabase = SupabaseClient(
    dotenv.env['SECONDARY_SUPABASE_URL'] ?? '',
    dotenv.env['SECONDARY_SUPABASE_ANON_KEY'] ?? '',
  );

  Future<List<GalleryItem>> getGalleryUrls() async {
    final PostgrestList response = await _supabase
        .from('photo_name')
        .select()
        .limit(100);
    final String url = dotenv.env['SECONDARY_SUPABASE_URL'] ?? '';
    final String directory =
        dotenv.env['SECONDARY_SUPABASE_PHOTO_DIRECTORY'] ?? '';

    return response
        .map(
          (data) => GalleryItem(
            id: data['id'],
            url: '$url/$directory/${data['name']}',
          ),
        )
        .toList();
  }

  Future<List<String>> getCategories() async {
    final PostgrestList response = await _supabase
        .from('photo_category')
        .select()
        .limit(100);

    return response.map((data) => data['category'] as String).toList();
  }

  Future<Map<String, bool>> getSelectedCategories(int id) async {
    final List<String> allCategoriesResponse = await getCategories();

    final PostgrestList selectedResponse = await _supabase
        .from('photo_name')
        .select('''
              photo_url_category_relation!inner(
              photo_category(
              category
            ))''')
        .eq('id', id);

    final List<String> selectedCategories = [];

    if (selectedResponse.isNotEmpty) {
      final relations =
          selectedResponse.first['photo_url_category_relation'] ?? [];

      selectedCategories.addAll(
        relations.map((rel) {
          final categoryData = rel['photo_category'];
          return categoryData['category'] as String;
        }).whereType<String>(),
      );
    }

    return {
      for (var category in allCategoriesResponse)
        category: selectedCategories.contains(category),
    };
  }

  Future<void> updateCategories(
    Map<String, bool> selectedCategories,
    int id,
  ) async {
    await _supabase
        .from('photo_url_category_relation')
        .delete()
        .eq('photo_id', id);

    final List<Map<String, dynamic>> newRelations = [];

    for (var category in selectedCategories.entries) {
      if (category.value) {
        final categoryResponse = await _supabase
            .from('photo_category')
            .select('id')
            .eq('category', category.key)
            .single();

        newRelations.add({
          'photo_id': id,
          'category_id': categoryResponse['id'],
        });
      }
    }

    if (newRelations.isNotEmpty) {
      await _supabase.from('photo_url_category_relation').insert(newRelations);
    }
  }
}
