import 'package:flutter_test/flutter_test.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:wo_read/record/models/lunar_age.dart';
import 'package:wo_read/record/use_cases/lunar_age_use_case.dart';

void main() {
  parameterizedTest(
    'input DateTime is converted to lunar age',
    [
      [DateTime(2021, 6, 2), LunarAge(year: 0, month: 0)],
      [DateTime(2022, 6, 1), LunarAge(year: 1, month: 0)],
      [DateTime(2022, 2, 28), LunarAge(year: 0, month: 8)],
      [DateTime(2021, 5, 31), LunarAge(year: 0, month: 0)],
      [DateTime(2022, 5, 31), LunarAge(year: 0, month: 11)],
    ],
    (DateTime datetime, LunarAge expectAge) {
      final DateTime birthDay = DateTime(2021, 6, 1);
      final LunarAge result = convertToLunarAge(
        datetime: datetime,
        birthday: birthDay,
      );

      expect(result.year, expectAge.year, reason: 'The year is failed.');
      expect(result.month, expectAge.month, reason: 'The month is failed.');
    },
  );
}
