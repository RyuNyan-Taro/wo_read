import 'package:flutter/material.dart';

import 'cook_form_page.dart';

Widget addCookButton({required BuildContext context, Function? returnAction}) {
  return FloatingActionButton.extended(
    icon: const Icon(Icons.photo_camera),
    label: const Text('食事を記録'),
    onPressed: () async {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const CookFormPage()));
      if (returnAction != null) returnAction();
    },
    heroTag: null,
  );
}
