import 'package:app_good_taste/app/page/production_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductionDetailsPage extends StatefulWidget {
  const ProductionDetailsPage({super.key});

  @override
  State<ProductionDetailsPage> createState() => _ProductionDetailsPageState();
}

class _ProductionDetailsPageState extends State<ProductionDetailsPage> {
  bool lineWasPressed = false;
  int selectedLine = -1;
  final List<Map<String, dynamic>> productions = [
    {
      "id": 1,
      "flavor": "Morango",
      "quantity": 12,
      "subtotal": 18,
      "price": 1.35
    },
    {"id": 2, "flavor": "Uva", "quantity": 13, "subtotal": 19.5, "price": 1.35},
    {
      "id": 3,
      "flavor": "Baunilha com limão",
      "quantity": 12,
      "subtotal": 18,
      "price": 1.35
    },
    {
      "id": 4,
      "flavor": "Azul",
      "quantity": 13,
      "subtotal": 19.5,
      "price": 1.35
    },
    {
      "id": 5,
      "flavor": "Chocolate",
      "quantity": 12,
      "subtotal": 18,
      "price": 1.35
    },
    {
      "id": 6,
      "flavor": "Leite condensado",
      "quantity": 10,
      "subtotal": 15,
      "price": 1.35
    },
  ];

  final List<Map<String, bool>> rowsPressed = [];
  final List<Map<String, dynamic>> feedstocks = [
    {"id": 1, "name": "Açucar", "brand": "", "price": 19.5},
    {"id": 2, "name": "suco de morando", "brand": "TANG", "price": 1.35},
    {"id": 3, "name": "uva", "brand": "MID", "price": 1.25},
    {"id": 4, "name": "Baunilha com limão", "brand": "", "price": 10.0},
    {"id": 5, "name": "Azul", "brand": "Nestle", "price": 8},
    {"id": 6, "name": "Chocolate", "brand": "", "price": 4.75},
    {"id": 7, "name": "Leite condensado", "brand": "", "price": 4.75},
  ];

  void checkIfProductionsIsGreaterThanZeroAndFillInTheListRowsPressed() {
    if (productions.isNotEmpty) {
      for (int i = 0; i < productions.length; i++) {
        rowsPressed.add({"isPressed": false});
      }
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
  void initState() {
    super.initState();
    checkIfProductionsIsGreaterThanZeroAndFillInTheListRowsPressed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detalhes do dia",
          style: TextStyle(fontSize: 25),
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
            child: IconButton(
              onPressed: !lineWasPressed
                  ? null
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ProductionPage(),
                        ),
                      );
                    },
              icon: Icon(
                lineWasPressed ? Icons.edit_outlined : Icons.edit,
                size: 25,
              ),
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
                height: MediaQuery.of(context).size.height / 2 - 170,
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
                                                productions[index]["subtotal"],
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
                height: MediaQuery.of(context).size.height / 2 - 170,
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
                                              feedstocks[index]["brand"],
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
            ],
          ),
        ),
      ),
    );
  }
}
