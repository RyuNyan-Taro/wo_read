import 'package:flutter/material.dart';

import 'add_image_page.dart';

Widget addImageButton({required BuildContext context, Function? returnAction}) {
  return FloatingActionButton(
    onPressed: () async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return AddImagePage();
          },
        ),
      );
      if (returnAction != null) returnAction();
    },
    heroTag: 'addImage',
    child: Icon(Icons.add_photo_alternate),
  );
}
