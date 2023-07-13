import 'package:flutter/material.dart';

class DropDownUtils extends StatefulWidget {
  final List<String> flavors;
  final String? flavorEditing;
  final String hint;
  final Function(int) onValueChanged;

  const DropDownUtils(
    this.flavors,
    this.hint, {
    Key? key,
    required this.onValueChanged,
    this.flavorEditing,
  }) : super(key: key);

  @override
  State<DropDownUtils> createState() => _DropDownUtilsState();
}

class _DropDownUtilsState extends State<DropDownUtils> {
  final valueNotifier = ValueNotifier("");

  @override
  void initState() {
    super.initState();
    if (widget.flavorEditing != null) {
      valueNotifier.value = widget.flavors[widget.flavors.length - 1];
    }
  }

  @override
  void dispose() {
    valueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (BuildContext context, String? valueDrop, _) {
        return DropdownButtonFormField<String>(
          isExpanded: true,
          decoration: InputDecoration(
            labelText: widget.hint,
            labelStyle: const TextStyle(fontSize: 18),
          ),
          value: valueDrop,
          onChanged: (option) {
            valueNotifier.value = option!;
            widget.onValueChanged(widget.flavors.indexOf(option));
          },
          items: widget.flavors
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
