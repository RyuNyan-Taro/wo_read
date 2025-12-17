import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class LabelService {
  var apiKey = dotenv.get('GOOGLE_AI_API_KEY');
  late final GenerativeModel _gemini = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: apiKey,
  );

  Future<String?> getDenverLabel(String text) async {
    final prompt =
        "以下のテキストが、テンバー式発達スクリーニングテストの以下の分類のどれに一番近いか端的に示して"
        "\n\n運動発達、言語発達、精神発達、社会性\n\n"
        "「$text」";
    final content = [Content.text(prompt)];
    final response = await _gemini.generateContent(content);

    return response.text;
  }
}
