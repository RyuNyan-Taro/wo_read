import 'package:equatable/equatable.dart';

class LunarAge extends Equatable {
  final int year;
  final int month;

  const LunarAge({required this.year, required this.month});

  @override
  List<Object?> get props => [year, month];
}
