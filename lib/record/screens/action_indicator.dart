// ref:https://hiyoko-programming.com/2894/
import 'package:flutter/material.dart';

void showActionIndicator(BuildContext context, Future operation) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return const Center(
        child: SizedBox(
          width: 64,
          height: 64,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.lightBlue),
            strokeWidth: 8,
          ),
        ),
      );
    },
  );
  operation.whenComplete(() {
    if (!context.mounted) return;
    Navigator.of(context).pop();
  });
}
