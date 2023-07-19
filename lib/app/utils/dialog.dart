import 'package:flutter/material.dart';

Future<bool?> showExitDialog(
    BuildContext context, Map<String, dynamic> messageDialog) async {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(messageDialog["title"]!),
        content: Text(messageDialog["content"]!),
        actions: [
          Visibility(
            visible: messageDialog["show_button_cancel"] || messageDialog["show_button_YN"],
            child: TextButton(
              child: Text(messageDialog["show_button_YN"] == false ? 'Cancelar' : "Não"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: ElevatedButton(
              child: Text(messageDialog["action"]!),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ),
        ],
      );
    },
  );
}
