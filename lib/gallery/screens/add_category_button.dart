import 'package:flutter/material.dart';

import 'add_category_page.dart';

Widget addCategoryButton({
  required BuildContext context,
  Function? returnAction,
}) {
  return FloatingActionButton(
    onPressed: () async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return AddCategoryPage();
          },
        ),
      );
      if (returnAction != null) returnAction();
    },
    child: Icon(Icons.playlist_add),
  );
}
