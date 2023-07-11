import 'package:flutter/material.dart';

import '../utils/month.dart';

class SlideMonth extends StatefulWidget {
  const SlideMonth({super.key});

  @override
  State<SlideMonth> createState() => _SlideMonthState();
}

class _SlideMonthState extends State<SlideMonth> {
  int numberMonth = int.parse(DateTime.now().month.toString()) - 1;
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
                  }),
          icon: const Icon(
            Icons.keyboard_arrow_left,
            size: 30,
          ),
        ),
        MonthPartils(numberMonth),
        IconButton(
          onPressed: numberMonth == 11
              ? null
              : () => setState(() {
                    if (numberMonth == 11) return;
                    numberMonth++;
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
