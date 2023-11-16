import 'package:flutter/material.dart';

class Message {
  static void showMessage(BuildContext context, Widget content,
      Color? backgroundColor, int milliseconds) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: content,
        backgroundColor:
            backgroundColor ?? const Color.fromARGB(255, 20, 20, 20),
        duration: Duration(milliseconds: milliseconds),
      ),
    );
  }
}
