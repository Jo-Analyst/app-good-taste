import 'package:flutter/material.dart';

class ScrollButtomModal extends StatelessWidget {
  const ScrollButtomModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
