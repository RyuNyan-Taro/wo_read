import 'package:wo_read/record/models/record_item.dart';

FeelingType convertToFeelingType({required String label}) {
  final FeelingType feeling = FeelingType.values.firstWhere(
    (e) => e.name == label,
    orElse: () => FeelingType.none,
  );

  return feeling;
}

DenverType convertToDenverType({required String label}) {
  final DenverType denver = DenverType.values.firstWhere(
    (e) => e.name == label,
    orElse: () => DenverType.none,
  );

  return denver;
}
