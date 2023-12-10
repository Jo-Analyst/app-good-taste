import 'package:app_good_taste/app/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MovementDetailsTemplate extends StatefulWidget {
  final double price;
  final String description;
  final List<Map<String, dynamic>> items;
  final bool isLoading;
  const MovementDetailsTemplate({
    required this.price,
    required this.isLoading,
    required this.description,
    required this.items,
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
                      label: widget.isLoading
                          ? Center(
                              child: loadingFourRotatingDots(
                                context,
                                20,
                                null,
                              ),
                            )
                          : Text(
                              NumberFormat('R\$ #0.00', 'PT-BR')
                                  .format(widget.price),
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
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : null,
              ),
              Visibility(
                visible: _expanded,
                child: widget.items.length > 3
                    ? SizedBox(
                        height:
                            100, // Altura máxima desejada para o conteúdo rolável
                        child: ListView.builder(
                          padding: EdgeInsets.zero, // Remover o padding
                          itemCount: widget.items.length,
                          itemBuilder: (ctx, index) {
                            final name = widget.items[index]['name'];
                            final price = widget.items[index]['subtotal'];
                            final quantity = widget.items[index]['quantity'];
                            final unit = widget.items[index]["unit"];
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
                                        widget.description == "Saída"
                                            ? "$quantity $unit de $name - ${NumberFormat('R\$ #0.00', 'PT-BT').format(price)}"
                                            : "$quantity chup-chup de $name - ${NumberFormat('R\$ #0.00', 'PT-BT').format(price)}",
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
                        children: widget.items.map(
                          (item) {
                            final name = item['name'];
                            final price = item['subtotal'];
                            final quantity = item['quantity'];
                            final unit = item["unit"];

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
                                        widget.description == "Saída"
                                            ? "$quantity $unit de $name - ${NumberFormat('R\$ #0.00', 'PT-BR').format(price)}"
                                            : "$quantity chup-chup de $name - ${NumberFormat('R\$ #0.00', 'PT-BR').format(price)}",
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
