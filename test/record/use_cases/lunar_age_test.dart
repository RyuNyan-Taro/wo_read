import 'package:flutter_test/flutter_test.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:wo_read/record/models/lunar_age.dart';

void main() {
  parameterizedTest(
    'input DateTime is converted to lunar age',
    [
      [DateTime(2021, 6, 1), LunarAge(year: 0, month: 0)],
      [DateTime(2022, 5, 31), LunarAge(year: 1, month: 0)],
      [DateTime(2022, 2, 28), LunarAge(year: 0, month: 9)],
      [DateTime(2021, 5, 31), LunarAge(year: 0, month: 0)],
    ],
    (DateTime datetime, LunarAge expect) {
      final DateTime birthDay = DateTime(2021, 6, 1);
      final LunarAge result = convertToLunarAge(
        dateTime: datetime,
        birthDay: birthDay,
      );

      expect(result.year, expect.year);
      expect(result.month, expect.month);
    },
  );
}
