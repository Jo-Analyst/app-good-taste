import 'package:flutter/material.dart';

Future<dynamic> showExitDialogFeedstock(
  BuildContext context,
  dynamic feedstock,
) async {
  return showDialog<dynamic>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Align(
          alignment: Alignment.center,
          child: Text(
            "Matéria Prima",
            style: TextStyle(color: Colors.black54),
          ),
        ),
        content: feedstock,
      );
    },
  );
}
