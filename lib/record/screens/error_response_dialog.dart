import 'package:flutter/material.dart';
import 'package:wo_read/record/models/record_item.dart';

Future<void> errorResponseDialog({
  required BuildContext context,
  required ResponseStatus status,
}) {
  if (_errorTextJp[status] == null) {
    throw ('unknown status');
  }

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('error'),
        content: Text(_errorTextJp[status]!),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

const Map<ResponseStatus, String> _errorTextJp = {
  ResponseStatus.exceededQuota: "利用上限に達しましたので、時間を置いて再度お試し下さい。",
  ResponseStatus.unknown: "不明なエラーが発生しました",
};
