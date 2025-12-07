import 'package:equatable/equatable.dart';
import 'package:wo_read/record/models/record_item.dart';

class LunarAge extends Equatable {
  final int year;
  final int month;

  const LunarAge({required this.year, required this.month});

  @override
  List<Object?> get props => [year, month];
}

typedef LunarAgeGroup = Map<LunarAge, List<RecordItem>>;
