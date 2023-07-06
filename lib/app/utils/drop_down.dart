import 'package:flutter/material.dart';

class DropDownUtils extends StatelessWidget {
  final List<String> flavors;
  final String hint;
  const DropDownUtils(this.flavors, this.hint, {super.key});

  @override
  Widget build(BuildContext context) {
    final valueNotifier = ValueNotifier("");
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (BuildContext context, String valueDrop, _) {
        return DropdownButtonFormField<String>(
          // icon: Icon(fonta),
          isExpanded: true,
          decoration: InputDecoration(
            labelText: hint,
            labelStyle: const TextStyle(fontSize: 18),
          ),
          // hint: Text(hint),
          value: (valueDrop.isEmpty ? null : valueDrop),
          onChanged: (option) => valueNotifier.value = option.toString(),
          items: flavors
              .map(
                (flavor) => DropdownMenuItem(
                  value: flavor,
                  child: Text(flavor),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
