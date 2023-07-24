import 'package:flutter/material.dart';

import '../utils/month.dart';

class SlideMonth extends StatefulWidget {
  final Function(dynamic value) getNumberMonth;
  const SlideMonth({super.key, required this.getNumberMonth});

  @override
  State<SlideMonth> createState() => _SlideMonthState();
}

class _SlideMonthState extends State<SlideMonth> {
  int numberMonth = int.parse(DateTime.now().month.toString()) - 1;
  String stringMonth = "";

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: numberMonth == 0
              ? null
              : () => setState(() {
                    if (numberMonth == 0) return;
                    numberMonth--;
                    widget.getNumberMonth(
                        Month.listMonths[numberMonth]["number"].toString());
                  }),
          icon: const Icon(
            Icons.keyboard_arrow_left,
            size: 30,
          ),
        ),
        Text(
          Month.listMonths[numberMonth]["month"].toString(),
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.displayLarge?.fontSize,
          ),
        ),
        IconButton(
          onPressed: numberMonth == 11
              ? null
              : () => setState(() {
                    if (numberMonth == 11) return;
                    numberMonth++;
                    widget.getNumberMonth(
                        Month.listMonths[numberMonth]["number"].toString());
                  }),
          icon: const Icon(
            Icons.keyboard_arrow_right,
            size: 30,
          ),
        ),
      ],
    );
  }
}
