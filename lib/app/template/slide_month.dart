import 'package:flutter/material.dart';

import '../partils/month.dart';

class SlideMonth extends StatefulWidget {
  const SlideMonth({super.key});

  @override
  State<SlideMonth> createState() => _SlideMonthState();
}

class _SlideMonthState extends State<SlideMonth> {
  int numberMonth = int.parse(DateTime.now().month.toString()) - 1;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => setState(() {
              if (numberMonth == 0) return;
              numberMonth--;
            }),
            icon: const Icon(Icons.keyboard_arrow_left),
          ),
          MonthPartils(numberMonth),
          IconButton(
            onPressed: () => setState(() {
              if (numberMonth == 11) return;
              numberMonth++;
            }),
            icon: const Icon(Icons.keyboard_arrow_right),
          ),
        ],
      ),
    );
  }
}
