import 'package:flutter/material.dart';

import 'add_cook_page.dart';

Widget addCookButton({required BuildContext context, Function? returnAction}) {
  return FloatingActionButton.extended(
    icon: const Icon(Icons.restaurant),
    label: const Text('記録する'),

    backgroundColor: Colors.orangeAccent,
    foregroundColor: Colors.white,

    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

    onPressed: () async {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const AddCookPage()));
      if (returnAction != null) returnAction();
    },
    heroTag: 'addCook',
  );
}
