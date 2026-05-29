import 'package:flutter_test/flutter_test.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:wo_read/record/models/morning_ready_record.dart';
import 'package:wo_read/record/use_cases/morning_ready_analysis_use_case.dart';

void main() {
  parameterizedTest(
    'ready time is compared with past average',
    [
      [420, MorningReadyComparisonStatus.faster, -15],
      [450, MorningReadyComparisonStatus.slower, 15],
      [435, MorningReadyComparisonStatus.same, 0],
    ],
    (
      int todayMinutes,
      MorningReadyComparisonStatus expectedStatus,
      int expectedDiff,
    ) {
      final target = _record(day: 10, readyMinutes: todayMinutes);
      final records = [
        target,
        _record(day: 9, readyMinutes: 420),
        _record(day: 8, readyMinutes: 450),
      ];

      final result = compareWithPastAverage(
        target: target,
        records: records,
      );

      expect(result.status, expectedStatus);
      expect(result.averageMinutes, 435);
      expect(result.diffMinutes, expectedDiff);
      expect(result.sampleCount, 2);
    },
  );

  test('comparison returns noData when target has no past records', () {
    final target = _record(day: 10, readyMinutes: 420);

    final result = compareWithPastAverage(
      target: target,
      records: [target],
    );

    expect(result.status, MorningReadyComparisonStatus.noData);
    expect(result.averageMinutes, isNull);
    expect(result.diffMinutes, isNull);
    expect(result.sampleCount, 0);
  });

  test('comparison uses latest seven past records', () {
    final target = _record(day: 10, readyMinutes: 420);
    final records = [
      target,
      _record(day: 9, readyMinutes: 410),
      _record(day: 8, readyMinutes: 420),
      _record(day: 7, readyMinutes: 430),
      _record(day: 6, readyMinutes: 440),
      _record(day: 5, readyMinutes: 450),
      _record(day: 4, readyMinutes: 460),
      _record(day: 3, readyMinutes: 470),
      _record(day: 2, readyMinutes: 1000),
    ];

    final result = compareWithPastAverage(
      target: target,
      records: records,
    );

    expect(result.averageMinutes, 440);
    expect(result.diffMinutes, -20);
    expect(result.sampleCount, 7);
  });

  parameterizedTest(
    'minutes are formatted as clock time',
    [
      [0, '0:00'],
      [425, '7:05'],
      [1439, '23:59'],
    ],
    (int minutes, String expected) {
      expect(formatMinutes(minutes), expected);
    },
  );
}

MorningReadyRecord _record({
  required int day,
  required int readyMinutes,
}) {
  final date = DateTime(2026, 5, day);
  return MorningReadyRecord(
    id: day,
    recordDate: date,
    readyAt: date.add(Duration(minutes: readyMinutes)),
    readyMinutes: readyMinutes,
  );
}
