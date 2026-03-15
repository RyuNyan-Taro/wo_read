import 'package:flutter/material.dart';

import 'add_cook_page.dart';

Widget addCookButton({required BuildContext context, Function? returnAction}) {
  return FloatingActionButton(
    onPressed: () async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return AddCookPage();
          },
        ),
      );
      if (returnAction != null) returnAction();
    },
    heroTag: 'addCook',
    child: Icon(Icons.add_card),
  );
}
