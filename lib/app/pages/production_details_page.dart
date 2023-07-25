import 'package:app_good_taste/app/controllers/product_controller.dart';
import 'package:app_good_taste/app/pages/production_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/production_controller.dart';

class ProductionDetailsPage extends StatefulWidget {
  final String date;
  const ProductionDetailsPage({super.key, required this.date});

  @override
  State<ProductionDetailsPage> createState() => _ProductionDetailsPageState();
}

class _ProductionDetailsPageState extends State<ProductionDetailsPage> {
  bool lineWasPressed = false;
  int selectedLine = -1;
  List<Map<String, dynamic>> productions = [];

  List<Map<String, bool>> rowsPressed = [];
  List<Map<String, dynamic>> feedstocks = [];

  @override
  initState() {
    super.initState();
    getDetailsFlavors();
    getDetailsFeedstocks();
    checkIfProductionsIsGreaterThanZeroAndFillInTheListRowsPressed();
  }

  void getDetailsFlavors() async {
    final productionProvider =
        Provider.of<ProductionController>(context, listen: false);
    final productionsList =
        await productionProvider.getDetailsFlavors(widget.date);
    setState(() {
      productions = productionsList;
    });
  }

  void getDetailsFeedstocks() async {
    final productionProvider =
        Provider.of<ProductionController>(context, listen: false);
    final feedstocksList =
        await productionProvider.getDetailsFeedstocks(widget.date);
    setState(() {
      feedstocks = feedstocksList;
    });
  }

  void checkIfProductionsIsGreaterThanZeroAndFillInTheListRowsPressed() {
    if (productions.isNotEmpty) {
      for (int i = 0; i < productions.length; i++) {
        rowsPressed.add({"isPressed": false});
      }
    }
  }

// limpa o item selecionado
  void clearSelection() {
    for (var row in rowsPressed) {
      row["isPressed"] = false;
    }
  }

  void toggleRowsPressed(int index) {
    for (int i = 0; i < rowsPressed.length; i++) {
      if (i != index) {
        rowsPressed[i]["isPressed"] = false;
      }
    }
    rowsPressed[index]["isPressed"] = !rowsPressed[index]["isPressed"]!;
    lineWasPressed = rowsPressed[index]["isPressed"]! ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detalhes do dia",
        ),
        toolbarHeight: 100,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            size: 35,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: Row(
              children: [
                IconButton(
                  onPressed: !lineWasPressed
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProductionPage(
                                production: productions[selectedLine],
                              ),
                            ),
                          );
                        },
                  icon: Icon(
                    lineWasPressed ? Icons.edit_outlined : Icons.edit,
                    size: 25,
                  ),
                ),
                IconButton(
                  onPressed: !lineWasPressed
                      ? null
                      : () {
                          setState(() {
                            productions.removeAt(selectedLine);
                            lineWasPressed = false;
                            clearSelection();
                          });
                        },
                  icon: const Icon(
                    Icons.delete,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        child: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
          child: Column(
            children: [
              Divider(
                color: Colors.pink[500],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_month_outlined),
                  Text("12/07/2023"),
                ],
              ),
              Divider(
                color: Colors.pink[500],
              ),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.topLeft,
                child: Text("Sabores:"),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2 - 180,
                width: double.infinity,
                child: Card(
                  elevation: 8,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Flexible(
                            child: ListView.builder(
                              itemCount: productions.length,
                              itemBuilder: (context, index) {
                                final rowColor = index == selectedLine &&
                                        rowsPressed[index]["isPressed"]!
                                    ? Theme.of(context).primaryColor
                                    : index % 2 > 0
                                        ? Colors.white
                                        : Colors.grey.shade200;

                                return InkWell(
                                  onLongPress: () {
                                    setState(() {
                                      selectedLine = index;
                                      toggleRowsPressed(index);
                                    });
                                  },
                                  child: Container(
                                    color: rowColor,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 15,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            productions[index]["flavor"],
                                            style: TextStyle(
                                              color: index == selectedLine &&
                                                      rowsPressed[index]
                                                          ["isPressed"]!
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${productions[index]["quantity"]}x",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: index == selectedLine &&
                                                        rowsPressed[index]
                                                            ["isPressed"]!
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              NumberFormat("R\$#0.00", "PT-BR")
                                                  .format(
                                                productions[index]["price"],
                                              ),
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: index == selectedLine &&
                                                        rowsPressed[index]
                                                            ["isPressed"]!
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              NumberFormat("R\$#0.00", "PT-BR")
                                                  .format(
                                                productions[index]
                                                    ["value_entry"],
                                              ),
                                              style: TextStyle(
                                                color: index == selectedLine &&
                                                        rowsPressed[index]
                                                            ["isPressed"]!
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.topLeft,
                child: Text("Gastos:"),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2 - 180,
                width: double.infinity,
                child: Card(
                  elevation: 8,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Flexible(
                            child: ListView.builder(
                              itemCount: feedstocks.length,
                              itemBuilder: (context, index) {
                                final rowColor = index % 2 > 0
                                    ? Colors.white
                                    : Colors.grey.shade200;
                                return Container(
                                  color: rowColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child:
                                              Text(feedstocks[index]["name"])),
                                      SizedBox(
                                        width: 120,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              feedstocks[index]["brand"] ?? "",
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              NumberFormat("R\$ #0.00", "PT-BR")
                                                  .format(
                                                feedstocks[index]["price"],
                                              ),
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "E:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Flexible(
                      child: Chip(
                        backgroundColor: Colors.blue,
                        label: Text(
                          NumberFormat("R\$ #0.00", "PT-BR").format(100),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const Text(
                      "S:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Flexible(
                      child: Chip(
                        backgroundColor: Colors.red,
                        label: Text(
                          NumberFormat("R\$ #0.00", "PT-BR").format(40),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const Text(
                      "L:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Flexible(
                      child: Chip(
                        backgroundColor: Colors.green,
                        label: Text(
                          NumberFormat("R\$ #0.00", "PT-BR").format(60),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
