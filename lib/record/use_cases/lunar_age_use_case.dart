import 'package:wo_read/record/models/lunar_age.dart';
import 'package:wo_read/record/models/record_item.dart';

LunarAge convertToLunarAge({
  required DateTime datetime,
  required DateTime birthday,
}) {
  // From the Japan low, the base date is one day before of the birthday
  // ref: https://sayumi-aug.hateblo.jp/entry/2022/03/01/160427
  final Duration duration = datetime.difference(birthday);
  final int year = duration.inDays ~/ 365;
  int month = 0;

  if (_isFasterThanBirth(datetime, birthday)) {
    return LunarAge(year: year, month: month);
  }

  if (birthday.month > datetime.month) {
    month = datetime.month + 12 - birthday.month;
  } else {
    month = datetime.month - birthday.month;
  }

  if (datetime.day < birthday.day) {
    month -= 1;
  }

  if (datetime.month != birthday.month &&
      _isComparisonBetweenMonthEnds(datetime, birthday)) {
    month += 1;
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

bool _isComparisonBetweenMonthEnds(DateTime datetime, DateTime birthday) {
  return _isMonthEnd(datetime) && _isMonthEnd(birthday);
}

bool _isMonthEnd(DateTime datetime) {
  const Map<int, int> endDay = {
    1: 31,
    2: 28,
    3: 31,
    4: 30,
    5: 31,
    6: 30,
    7: 31,
    8: 31,
    9: 30,
    10: 31,
    11: 30,
    12: 31,
  };

  return datetime.day >= endDay[datetime.month]!;
}
