import 'package:flutter/material.dart';

import '../../common/app_theme.dart';
import 'cook_form_page.dart';

Widget addCookButton({required BuildContext context, Function? returnAction}) {
  return FloatingActionButton.extended(
    icon: Icon(
      Icons.camera_alt,
      color: AppTheme.themeData.colorScheme.onPrimary,
    ),
    label: const Text('食事を記録'),
    foregroundColor: AppTheme.themeData.colorScheme.onPrimary,
    shape: StadiumBorder(),

    onPressed: () async {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const CookFormPage()));
      if (returnAction != null) returnAction();
    },
    heroTag: null,
  );
}
