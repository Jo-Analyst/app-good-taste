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
  final List<String> _items = [
    "1x Açucar",
    "1x Sacolas",
    "1x Sucos",
  ];

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                title: Row(
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
                          fontSize: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.fontSize,
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
                child: _items.length > 3
                    ? SizedBox(
                        height:
                            150, // Altura máxima desejada para o conteúdo rolável
                        child: ListView.builder(
                          padding: EdgeInsets.zero, // Remover o padding
                          itemCount: _items.length,
                          itemBuilder: (ctx, index) {
                            return Container(
                              width: double.infinity,
                              color: const Color.fromARGB(255, 222, 219, 219),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10,
                                  ),
                                  child: Text(_items[index]),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Column(
                        children: _items.map((item) {
                          return Container(
                            width: double.infinity,
                            color: const Color.fromARGB(255, 222, 219, 219),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                child: Text(item),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
