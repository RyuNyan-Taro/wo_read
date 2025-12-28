import 'package:flutter/material.dart';

Widget addCategoryButton({
  required BuildContext context,
  Function? returnAction,
}) {
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
      print('pushCategoryButton');
    },
    child: Icon(Icons.dehaze),
  );
}
