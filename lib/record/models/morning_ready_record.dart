class MorningReadyRecord {
  final int id;
  final DateTime recordDate;
  final DateTime readyAt;
  final int readyMinutes;

  const MorningReadyRecord({
    required this.id,
    required this.recordDate,
    required this.readyAt,
    required this.readyMinutes,
  });
}
