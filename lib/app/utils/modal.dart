import 'package:flutter/material.dart';

Future<String> showModal(BuildContext context, dynamic screenForm) async {
  final result = await showModalBottomSheet(
    context: context,
    builder: (_) {
      return SizedBox(
        height: 900,
        child: screenForm,
      );
    },
  );

  return result ?? "";
}
