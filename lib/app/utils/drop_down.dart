import 'package:flutter/material.dart';

class DropDownUtils extends StatefulWidget {
  final List<String> flavors;
  final int? indexFlavorEditing;
  final String hint;
  final Function(int) onValueChanged;

  const DropDownUtils(
    this.flavors,
    this.hint,
    {
    this.indexFlavorEditing, 
    Key? key,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  State<DropDownUtils> createState() => _DropDownUtilsState();
}

class _DropDownUtilsState extends State<DropDownUtils> {
  final valueNotifier = ValueNotifier("");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    valueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var seen = <String>{};
    List<String> flavorslist =
        widget.flavors.where((flavor) => seen.add(flavor)).toList();

    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: InputDecoration(
        labelText: widget.hint,
        labelStyle: const TextStyle(fontSize: 18),
        floatingLabelStyle: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      value: widget.indexFlavorEditing! >= 0 &&
              widget.indexFlavorEditing! < widget.flavors.length
          ? flavorslist[widget.indexFlavorEditing!]
          : null,
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
  }
}
