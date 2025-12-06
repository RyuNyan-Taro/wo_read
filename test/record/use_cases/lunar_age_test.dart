import 'package:flutter_test/flutter_test.dart';
import 'package:parameterized_test/parameterized_test.dart';

void main() {
  parameterizedTest(
    'input DateTime is converted to lunar age',
    [
      [DateTime(2021, 6, 1), LunarAge(0, 0)],
      [DateTime(2022, 5, 31), LunarAge(1, 0)],
      [DateTime(2022, 2, 28), LunarAge(0, 9)],
      [DateTime(2021, 5, 31), LunarAge(0, 0)],
    ],
    (DateTime datetime, LunarAge expect) {
      final DateTime birthDay = DateTime(2021, 6, 1);
      final result = convertToLunarAge(dateTime: datetime, birthDay: birthDay);
      expect(result, expect);
    },
  );
}
