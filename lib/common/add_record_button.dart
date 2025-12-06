import 'package:flutter/material.dart';
import 'package:wo_read/record/screens/add_record.dart';

Widget addRecordButton({
  required BuildContext context,
  Function? returnAction,
}) {
  return FloatingActionButton(
    onPressed: () async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return AddRecordPage();
          },
        ),
      );
      if (returnAction != null) returnAction();
    },
    child: Icon(Icons.add),
  );
}
