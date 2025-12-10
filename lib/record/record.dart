import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:wo_read/common/add_record_button.dart';
import 'package:wo_read/record/models/lunar_age.dart';
import 'package:wo_read/record/models/record_item.dart';
import 'package:wo_read/record/screens/modify_record.dart';
import 'package:wo_read/record/service/record_service.dart';
import 'package:wo_read/record/use_cases/lunar_age_use_case.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  List<RecordItem>? records;

  @override
  void initState() {
    super.initState();

    if (records == null) {
      _getRecords();
    }
  }

  Future<void> _getRecords() async {
    final RecordService recordService = RecordService();
    final List<RecordItem> items = await recordService.getRecords();

    setState(() {
      records = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Glow record'),
      ),
      body: records == null
          ? const Center(child: CircularProgressIndicator())
          : _recordsSet(records!, _getRecords),
      floatingActionButton: addRecordButton(
        context: context,
        returnAction: _getRecords,
      ),
    );
  }
}

Widget _recordsSet(List<RecordItem> records, Function() backAction) {
  final DateTime birthday = DateTime.parse(
    dotenv.env['CHILD_BIRTHDAY'] ?? '1970-01-01 00:00:00',
  );

  final LunarAgeGroup lunarAgeGroup = groupByLunarAge(records, birthday);

  return SingleChildScrollView(
    child: Column(
      children: lunarAgeGroup.entries
          .map(
            (entry) => _lunarAgeRecords(
              lunarAge: entry.key,
              records: entry.value,
              backAction: backAction,
            ),
          )
          .toList(),
    ),
  );
}

Widget _lunarAgeRecords({
  required LunarAge lunarAge,
  required List<RecordItem> records,
  required Function() backAction,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsetsGeometry.only(top: 8, bottom: 4, left: 4),
        child: Text('${lunarAge.year}年${lunarAge.month}ヶ月'),
      ),
      Column(
        children: records
            .map(
              (record) => _RecordCard(record: record, backAction: backAction),
            )
            .toList(),
      ),
    ],
  );
}

class _RecordCard extends StatelessWidget {
  final RecordItem record;
  final Function() backAction;

  const _RecordCard({required this.record, required this.backAction});

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MM/dd HH:mm');

    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ModifyRecordPage(recordItem: record);
            },
          ),
        );
        backAction();
      },
      child: Card(
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
      ),
    );
  }
}
