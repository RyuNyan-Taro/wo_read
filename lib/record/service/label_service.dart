import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class LabelService {
  var apiKey = dotenv.get('GOOGLE_AI_API_KEY');
  late final GenerativeModel _gemini = GenerativeModel(
    model: 'gemini-2.5-flash-lite',
    apiKey: apiKey,
  );

  Future<String?> getLabels(String text) async {
    // final prompt =
    //     "以下のテキストについて以下を返して"
    //     "\n1. 喜怒哀楽のうちにどれに一番近いか、喜怒哀楽のどれか一つだけを結果として返して"
    //     "\n2. テンバー式発達スクリーニングテストの以下の分類のどれに一番近いか端的に示して"
    //     "\n\n運動発達、言語発達、精神発達、社会性\n\n"
    //     "*returnの形式は必ず以下とする"
    //     "喜怒哀楽のいずれか, 運動発達,言語発達,精神発達,社会性のいずれか"
    //     "\n\n"
    //     "「$text」";
    //
    // final content = [Content.text(prompt)];
    // final response = await _gemini.generateContent(content);
    //
    // return response.text;

    const String responseText = "怒, 精神発達";
    final labels = responseText.split(", ");
    final String denverLabel = labels[0];
    final String feelingLabel = labels[1];

    return responseText;
  }
}
