import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MovementDetailsTemplate extends StatefulWidget {
  final double price;
  final String description;
  const MovementDetailsTemplate({
    required this.price,
    required this.description,
    super.key,
  });

  @override
  State<MovementDetailsTemplate> createState() => _MovementDetailsTemplate();
}

class _MovementDetailsTemplate extends State<MovementDetailsTemplate> {
  bool _expanded = false;

  Color changeColorByDescription() {
    switch (widget.description.toLowerCase()) {
      case "entrada":
        return Colors.blue.shade300;
      case "total":
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330,
      child: Card(
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              title: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${widget.description}:",
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.displayLarge?.fontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Chip(
                    backgroundColor: changeColorByDescription(),
                    label: Text(
                      NumberFormat('R\$ #.00', 'PT-BR').format(widget.price),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            Theme.of(context).textTheme.displayLarge?.fontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: widget.description.toLowerCase() != "total"
                  ? IconButton(
                      onPressed: () => setState(() => _expanded = !_expanded),
                      icon: Icon(
                        _expanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_right,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : null,
            ),
            Visibility(
              visible: _expanded,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                color: const Color.fromARGB(255, 222, 219, 219),
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text("2x Açucar R\$12,50"),
                ),
              ),
            ),
            Visibility(
              visible: _expanded,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                color: const Color.fromARGB(255, 222, 219, 219),
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text("2x Açucar R\$12,50"),
                ),
              ),
            ),
            Visibility(
              visible: _expanded,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                color: const Color.fromARGB(255, 222, 219, 219),
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text("2x Açucar R\$12,50"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
