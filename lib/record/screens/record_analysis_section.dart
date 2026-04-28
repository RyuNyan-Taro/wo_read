import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wo_read/record/models/record_item.dart';
import 'package:wo_read/record/use_cases/record_analysis_use_case.dart';

class RecordAnalysisSection extends StatelessWidget {
  final List<RecordItem> records;

  const RecordAnalysisSection({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: Text('データなし')),
        ),
      );
    }

    return Column(
      children: [
        _FeelingPieChart(records: records),
        _DenverBarChart(records: records),
      ],
    );
  }
}

class _FeelingPieChart extends StatelessWidget {
  final List<RecordItem> records;

  const _FeelingPieChart({required this.records});

  static const Map<FeelingType, Color> _colors = {
    FeelingType.none: Colors.grey,
    FeelingType.happiness: Colors.amber,
    FeelingType.anger: Colors.red,
    FeelingType.sorrow: Colors.blue,
    FeelingType.pleasure: Colors.green,
  };

  @override
  Widget build(BuildContext context) {
    final counts = countByFeelingType(records);

    final sections = FeelingType.values
        .where((t) => (counts[t] ?? 0) > 0)
        .map((t) {
          final count = counts[t]!;
          return PieChartSectionData(
            color: _colors[t] ?? Colors.grey,
            value: count.toDouble(),
            title: '${feelingToJp[t]}\n$count',
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
        })
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('気持ち分布', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: PieChart(PieChartData(sections: sections)),
            ),
          ],
        ),
      ),
    );
  }
}

class _DenverBarChart extends StatelessWidget {
  final List<RecordItem> records;

  const _DenverBarChart({required this.records});

  static const Map<DenverType, Color> _colors = {
    DenverType.none: Colors.grey,
    DenverType.personalSocial: Colors.purple,
    DenverType.fineMotorAdaptive: Colors.orange,
    DenverType.language: Colors.teal,
    DenverType.grossMotor: Colors.indigo,
  };

  @override
  Widget build(BuildContext context) {
    final counts = countByDenverType(records);
    final types = DenverType.values;
    final maxCount =
        types.map((t) => counts[t] ?? 0).reduce((a, b) => a > b ? a : b);
    const _niceSteps = [1, 2, 5, 10, 20, 50, 100, 200, 500, 1000];
    final leftInterval = _niceSteps
        .firstWhere((s) => s >= maxCount / 5, orElse: () => _niceSteps.last)
        .toDouble();

    final barGroups = types.asMap().entries
        .map((entry) => BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: (counts[entry.value] ?? 0).toDouble(),
                  color: _colors[entry.value] ?? Colors.grey,
                ),
              ],
            ))
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('発達分布', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  maxY: (maxCount > 0 ? maxCount + 1 : 5).toDouble(),
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= types.length) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              denverToJp[types[index]] ?? '',
                              style: const TextStyle(fontSize: 9),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: leftInterval,
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
