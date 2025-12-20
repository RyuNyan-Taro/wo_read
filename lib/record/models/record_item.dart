class RecordItem {
  final int id;
  final DateTime date;
  final String content;
  final FeelingType feeling;
  final DenverType denver;

  const RecordItem({
    required this.id,
    required this.date,
    required this.content,
    required this.feeling,
    required this.denver,
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

const Map<FeelingType, String> feelingToJp = {
  FeelingType.none: '無し',
  FeelingType.happiness: '嬉しい',
  FeelingType.anger: '怒り',
  FeelingType.sorrow: '悲しい',
  FeelingType.pleasure: '楽しい',
};
