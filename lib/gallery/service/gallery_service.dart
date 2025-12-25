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
}
