import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GalleryService {
  final _supabase = SupabaseClient(
    dotenv.env['SECONDARY_SUPABASE_URL'] ?? '',
    dotenv.env['SECONDARY_SUPABASE_ANON_KEY'] ?? '',
  );

  Future<List<String>> getGalleryUrls() async {
    final PostgrestList response = await _supabase
        .from('photo_name')
        .select()
        .limit(100);

    return response.map((data) => data['name'] as String).toList();
  }
}
