import 'package:flutter/material.dart';

class _RecordItem {
  final DateTime date;
  final String content;

  const _RecordItem({required this.date, required this.content});
}

class RecordPage extends StatelessWidget {
  const RecordPage({super.key});

  static final List<_RecordItem> _records = [
    _RecordItem(
      date: DateTime(2021, 1, 1, 0, 0),
      content: 'ものすごいとっっっっっっっっっっっっっっっっs',
    ),
    _RecordItem(date: DateTime(2021, 1, 2, 0, 0), content: 'test_2'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Glow record'),
      ),
      body: Column(
        children: _records
            .map((record) => _RecordCard(record: record))
            .toList(),
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  final _RecordItem record;

  const _RecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Text(record.date.toString()),
          Text(': '),
          Expanded(
            child: Text(
              record.content,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
