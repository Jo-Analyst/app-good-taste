import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductionDetailsPage extends StatelessWidget {
  const ProductionDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> production = [
      {"id": 1, "flavor": "Morango", "quantity": 12, "price": 18},
      {"id": 2, "flavor": "Uva", "quantity": 13, "price": 19.5},
      {"id": 3, "flavor": "Baunilha com limão", "quantity": 12, "price": 18},
      {"id": 4, "flavor": "Azul", "quantity": 13, "price": 19.5},
      {"id": 4, "flavor": "Chocolate", "quantity": 12, "price": 18},
      {"id": 4, "flavor": "Leite consensado", "quantity": 10, "price": 15},
    ];
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
      ),
      body: Container(
        color: Colors.white,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        child: DefaultTextStyle(
          style: const TextStyle(fontSize: 18, color: Colors.black),
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
                height: MediaQuery.of(context).size.height / 2 - 135,
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
                              itemCount: production.length,
                              itemBuilder: (context, index) {
                                final rowColor = index % 2 > 0
                                    ? Colors.white
                                    : const Color.fromARGB(255, 191, 190, 190);
                                return Container(
                                  color: rowColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(production[index]["flavor"]),
                                      Row(
                                        children: [
                                          Text(
                                              "${production[index]["quantity"]}x"),
                                          const SizedBox(width: 5),
                                          Text(
                                            NumberFormat("R\$ #0.00", "PT-BR")
                                                .format(
                                              production[index]["price"],
                                            ),
                                          ),
                                        ],
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
              SizedBox(
                height: MediaQuery.of(context).size.height / 2 - 135,
                width: double.infinity,
                child: const Card(
                  elevation: 8,
                  child: Text(""),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
