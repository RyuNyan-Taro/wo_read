import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wo_read/record/models/record_item.dart';
import 'package:wo_read/record/service/record_service.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  List<RecordItem> _records = [];

  @override
  void initState() {
    super.initState();
    _getRecords();
  }

  Future<void> _getRecords() async {
    final RecordService recordService = RecordService();
    _records = await recordService.getRecords();
  }

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
  final RecordItem record;

  const _RecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MM/dd HH:mm');

    return Card(
      child: Row(
        children: [
          Text(formatter.format(record.date)),
          Text(' '),
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
