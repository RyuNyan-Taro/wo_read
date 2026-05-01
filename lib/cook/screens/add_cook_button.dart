import 'package:flutter/material.dart';

import '../../common/app_theme.dart';
import 'cook_form_page.dart';

Widget addCookButton({required BuildContext context, Function? returnAction}) {
  return FloatingActionButton.extended(
    icon: Icon(
      Icons.restaurant,
      color: AppTheme.themeData.colorScheme.onPrimary,
    ),
    label: const Text('記録する'),
    foregroundColor: AppTheme.themeData.colorScheme.onPrimary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

    onPressed: () async {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const CookFormPage()));
      if (returnAction != null) returnAction();
    },
    heroTag: 'addCook',
  );
}
