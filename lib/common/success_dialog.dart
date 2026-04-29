import 'package:flutter/material.dart';

Future<void> showSuccessDialog({
  required BuildContext context,
  required String content,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          '完了',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
