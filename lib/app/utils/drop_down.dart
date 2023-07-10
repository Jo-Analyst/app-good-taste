import 'package:flutter/material.dart';

class DropDownUtils extends StatefulWidget {
  final List<String> flavors;
  final String hint;
  final Function(int) onValueChanged;
  const DropDownUtils(
    this.flavors,
    this.hint, {
    super.key,
    required this.onValueChanged,
  });

  @override
  State<DropDownUtils> createState() => _DropDownUtilsState();
}

class _DropDownUtilsState extends State<DropDownUtils> {
  final valueNotifier = ValueNotifier("");
  final textController = TextEditingController();

  @override
  void dispose() {
    valueNotifier.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (BuildContext context, String valueDrop, _) {
        return DropdownButtonFormField<String>(
          validator: (option) {
            if (option == null || option.isEmpty) {
              return "Selecione o sabor";
            }

            return null;
          },
          isExpanded: true,
          decoration: InputDecoration(
            labelText: widget.hint,
            labelStyle: const TextStyle(fontSize: 18),
          ),
          value: (valueDrop.isEmpty ? null : valueDrop),
          onChanged: (option) {
            valueNotifier.value = option.toString();
            widget.onValueChanged(widget.flavors.indexOf(option.toString()));
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
