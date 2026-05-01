import 'package:flutter/material.dart';
import 'package:wo_read/record/screens/add_record.dart';

import 'app_theme.dart';

Widget addRecordButton({
  required BuildContext context,
  Function? returnAction,
}) {
  return SizedBox(
    width: 48,
    height: 48,
    child: FloatingActionButton(
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
      child: Icon(Icons.add, color: AppTheme.themeData.colorScheme.onPrimary),
    ),
  );
}
