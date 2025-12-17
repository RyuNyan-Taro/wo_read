class RecordItem {
  final int id;
  final DateTime date;
  final String content;

  const RecordItem({
    required this.id,
    required this.date,
    required this.content,
  });
}

enum DenverType {
  none,
  personalSocial,
  fineMotorAdaptive,
  language,
  grossMotor,
}

enum FeelingType { none, happiness, anger, sorrow, pleasure }

class LabelResult {
  final FeelingType feeling;
  final DenverType denver;

  LabelResult({required this.feeling, required this.denver});
}
