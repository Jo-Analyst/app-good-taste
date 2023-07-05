import 'package:flutter/material.dart';

showModal(BuildContext context, dynamic screenForm) {
  showModalBottomSheet(
    context: context,
    builder: (_) {
      return screenForm;
    },
  );
}
