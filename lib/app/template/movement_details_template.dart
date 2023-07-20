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
  final List<Map<String, dynamic>> _items = [
    {"name": "Açucar", "price": 39.00, "quantity": 1},
    {"name": "Saquinho", "price": 24.50, "quantity": 1},
    {"name": "Suco de Maracujá", "price": 13.5, "quantity": 10},
    {"name": "Suco de Morango", "price": 27.00, "quantity": 20},
  ];

  Color changeColorByDescription() {
    switch (widget.description.toLowerCase()) {
      case "entrada":
        return const Color.fromARGB(255, 22, 104, 171);
      case "total":
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 330,
      child: Card(
        elevation: 8,
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
                        NumberFormat('R\$ #0.00', 'PT-BR').format(widget.price),
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
                            100, // Altura máxima desejada para o conteúdo rolável
                        child: ListView.builder(
                          padding: EdgeInsets.zero, // Remover o padding
                          itemCount: _items.length,
                          itemBuilder: (ctx, index) {
                            final name = _items[index]['name'];
                            final price = _items[index]['price'];
                            final quantity = _items[index]['quantity'];

                            return Container(
                              width: double.infinity,
                              color: const Color.fromARGB(255, 217, 215, 215),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 10,
                                      ),
                                      child: Text(
                                        "${quantity}x $name ${NumberFormat('R\$ #0.00', 'PT-BT').format(price)}",
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : Column(
                        children: _items.map(
                          (item) {
                            final name = item['name'];
                            final price = item['price'];
                            final quantity = item['quantity'];

                            return Container(
                              width: double.infinity,
                              color: const Color.fromARGB(255, 217, 215, 215),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 10,
                                      ),
                                      child: Text(
                                        "${quantity}x $name ${NumberFormat('R\$ #0.00', 'PT-BT').format(price)}",
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                ],
                              ),
                            );
                          },
                        ).toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
