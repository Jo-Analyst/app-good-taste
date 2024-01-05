import 'package:flutter/material.dart';

import '../utils/month.dart';

class SlideMonth extends StatefulWidget {
  final int year;
  final Function(dynamic numberMonth, int year) getNumberMonth;
  const SlideMonth({
    super.key,
    required this.getNumberMonth,
    required this.year,
  });

  @override
  State<SlideMonth> createState() => _SlideMonthState();
}

class _SlideMonthState extends State<SlideMonth> {
  int numberMonth = int.parse(DateTime.now().month.toString()) - 1, year = 0;
  String stringMonth = "";

  void getNumberMonth(int numberMonth) {
    widget.getNumberMonth(
        Month.listMonths[numberMonth]["number"].toString(), year);
  }

  @override
  void initState() {
    super.initState();

    year = widget.year;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: numberMonth == 0 && year == 2023
              ? null
              : () => setState(() {
                    if (numberMonth == 0 && year == 2023) return;

                    numberMonth = numberMonth > 0 ? numberMonth - 1 : 11;
                    if (numberMonth == 11) {
                      year--;
                    }
                    getNumberMonth(numberMonth);
                  }),
          icon: const Icon(
            Icons.keyboard_arrow_left,
            size: 30,
          ),
        ),
        Text(
          "${Month.listMonths[numberMonth]["month"]} de ${widget.year.toString()}",
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.displayLarge?.fontSize,
          ),
        ),
        IconButton(
          onPressed: () => setState(() {
            numberMonth = numberMonth < 11 ? numberMonth + 1 : 0;

            if (numberMonth == 0) {
              year++;
            }
            getNumberMonth(numberMonth);
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
