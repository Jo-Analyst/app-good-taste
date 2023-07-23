import 'package:flutter/material.dart';

class MonthPartils extends StatefulWidget {
  final int numberMonth;
  final Function(String) getNumberMonth;
  const MonthPartils(this.numberMonth,
      {super.key, required this.getNumberMonth});

  @override
  State<MonthPartils> createState() => _MonthPartilsState();
}

class _MonthPartilsState extends State<MonthPartils> {
  final List<Map<String, String>> months = [
    {"month": "Janeiro", "number": "01"},
    {"month": "Fevereiro", "number": "02"},
    {"month": "Março", "number": "03"},
    {"month": "Abril", "number": "04"},
    {"month": "Maio", "number": "05"},
    {"month": "Junho", "number": "06"},
    {"month": "Julho", "number": "07"},
    {"month": "Agosto", "number": "08"},
    {"month": "Setembro", "number": "09"},
    {"month": "Outubro", "number": "10"},
    {"month": "Novembro", "number": "11"},
    {"month": "Dezembro", "number": "12"},
  ];

  @override
  void initState() {
    super.initState();
    // widget.getNumberMonth(months[widget.numberMonth]["number"].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      months[widget.numberMonth]["month"].toString(),
      style: TextStyle(
        fontSize: Theme.of(context).textTheme.displayLarge?.fontSize,
      ),
    );
  }
}
