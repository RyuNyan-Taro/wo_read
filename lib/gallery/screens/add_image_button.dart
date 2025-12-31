import 'package:flutter/material.dart';

Widget addImageButton({required BuildContext context, Function? returnAction}) {
  return FloatingActionButton(
    // onPressed: () async {
    //   await Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (context) {
    //         return AddRecordPage();
    //       },
    //     ),
    //   );
    //   if (returnAction != null) returnAction();
    // },
    onPressed: () {
      print('pushAddImageButton');
    },
    heroTag: 'addImage',
    child: Icon(Icons.add_photo_alternate),
  );
}
