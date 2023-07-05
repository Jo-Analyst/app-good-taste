// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MonthPartils extends StatelessWidget {
  final int numberMonth;
  const MonthPartils(this.numberMonth, {super.key});

  @override
  Widget build(BuildContext context) {
    
    final List<String> months = [
      "Janeiro",
      "Fevereiro",
      "Março",
      "Abril",
      "Maio",
      "Junho",
      "Julho",
      "Agosto",
      "Setembro",
      "Outubro",
      "Novembro",
      "Dezembro"
    ];

    return Text(
      months[numberMonth],
      style: TextStyle(
        fontSize: Theme.of(context).textTheme.displayLarge?.fontSize,
      ),
    );
  }
}
