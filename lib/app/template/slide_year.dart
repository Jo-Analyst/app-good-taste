import 'package:flutter/material.dart';

class SlideYear extends StatefulWidget {
  const SlideYear({super.key});

  @override
  State<SlideYear> createState() => _SlideYearState();
}

class _SlideYearState extends State<SlideYear> {
  int numberYear = DateTime.now().year;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width -70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: numberYear == 2023
                ? null
                : () => setState(() {
                      if (numberYear == 2023) return;
                      numberYear--;
                    }),
            icon: const Icon(
              Icons.keyboard_arrow_left,
              size: 30,
            ),
          ),
          Text(
            numberYear.toString(),
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.displayLarge?.fontSize,
            ),
          ),
          IconButton(
            onPressed: numberYear == 2300
                ? null
                : () => setState(() {
                      if (numberYear == 2300) return;
                      numberYear++;
                    }),
            icon: const Icon(
              Icons.keyboard_arrow_right,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
