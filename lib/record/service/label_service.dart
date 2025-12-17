import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:wo_read/record/models/record_item.dart';

class LabelService {
  var apiKey = dotenv.get('GOOGLE_AI_API_KEY');
  late final GenerativeModel _gemini = GenerativeModel(
    model: 'gemini-2.5-flash-lite',
    apiKey: apiKey,
  );

  Future<LabelResult> getLabels(String text) async {
    final prompt =
        "以下のテキストについて以下を返して"
        "\n1. どの感情に一番近いか、happiness、anger、sorrow、pleasureのどれか一つだけを結果として返して"
        "\n2. テンバー式発達スクリーニングテストの以下の分類のどれに一番近いか端的に示して"
        "\n\npersonalSocial、fineMotorAdaptive、language、grossMotor\n\n"
        "*returnの形式は必ず以下とする"
        "happiness、anger、sorrow、pleasureのいずれか, personalSocial、fineMotorAdaptive、language、grossMotorのいずれか"
        "\n\n"
        "「$text」";

    final content = [Content.text(prompt)];
    final response = await _gemini.generateContent(content);

    final String? responseText = response.text;
    if (responseText == null) {
      return LabelResult(feeling: FeelingType.none, denver: DenverType.none);
    }

    final labels = responseText.split(", ");

    final FeelingType feeling = FeelingType.values.firstWhere(
      (e) => e.name == labels[0],
      orElse: () => FeelingType.none,
    );

    final DenverType denver = DenverType.values.firstWhere(
      (e) => e.name == labels[1],
      orElse: () => DenverType.none,
    );

    return LabelResult(feeling: feeling, denver: denver);
  }
}
