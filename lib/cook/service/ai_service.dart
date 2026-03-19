import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  var apiKey = dotenv.get('GOOGLE_AI_API_KEY');
  late final GenerativeModel _gemini = GenerativeModel(
    model: 'gemini-2.5-flash-lite',
    apiKey: apiKey,
  );

  Future<String?> getAiCommentFromImage({
    required Uint8List imageBytes,
    String mimeType = 'image/jpeg',
  }) async {
    const prompt =
        "添付した画像を褒める文章を生成して"
        "\n1. 文字数: 100文字以内"
        "\n2. 具材について言及すること"
        "\n3. キャラ弁の場合はその出来栄えにも言及すること"
        "\n4. 褒めた後の、他のアクションの提案は不要";
    try {
      final imagePart = DataPart(mimeType, imageBytes);

      final content = [
        Content.multi([TextPart(prompt), imagePart]),
      ];

      final response = await _gemini.generateContent(content);

      return response.text;
    } catch (e) {
      debugPrint('AI生成エラー: $e');
      return null;
    }
  }
}
