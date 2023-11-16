import 'package:flutter/material.dart';

class ContentMessage extends StatelessWidget {
  final String title;
  final IconData icon;
  const ContentMessage({required this.title, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 18),
          ),
        )
      ],
    );
  }
}
