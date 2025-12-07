import 'package:wo_read/record/models/lunar_age.dart';
import 'package:wo_read/record/models/record_item.dart';

LunarAge convertToLunarAge({
  required DateTime datetime,
  required DateTime birthday,
}) {
  // From the Japan low, the base date is one day before of the birthday
  // ref: https://sayumi-aug.hateblo.jp/entry/2022/03/01/160427
  final DateTime actualBirthday = birthday.add(Duration(days: -1));
  final Duration duration = datetime.difference(actualBirthday);
  final int year = duration.inDays ~/ 365;
  int month = 0;

  if (_isFasterThanBirth(datetime, actualBirthday)) {
    return LunarAge(year: year, month: month);
  }

  if (actualBirthday.month > datetime.month) {
    month = datetime.month + 12 - actualBirthday.month;
  } else {
    month = datetime.month - actualBirthday.month;
  }

  if (actualBirthday.day < datetime.day) {
    month += 1;
  }

  if (_isSpanningMonthLessThanOneMonth(datetime, actualBirthday)) {
    month -= 1;
  }

  return LunarAge(year: year, month: month);
}

LunarAgeGroup groupByLunarAge(List<RecordItem> records, DateTime birthday) {
  final LunarAgeGroup lunarAgeGroup = {};

  for (RecordItem record in records) {
    final LunarAge lunarAge = convertToLunarAge(
      datetime: record.date,
      birthday: birthday,
    );
    if (lunarAgeGroup[lunarAge] == null) {
      lunarAgeGroup[lunarAge] = [];
    }
    lunarAgeGroup[lunarAge]!.add(record);
  }

  return lunarAgeGroup;
}

bool _isFasterThanBirth(DateTime datetime, DateTime birthday) {
  return birthday.year >= datetime.year && birthday.month > datetime.month;
}

bool _isSpanningMonthLessThanOneMonth(DateTime datetime, DateTime birthday) {
  return birthday.month + 1 == datetime.month && birthday.day > datetime.month;
}
