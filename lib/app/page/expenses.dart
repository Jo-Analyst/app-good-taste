import 'package:flutter/material.dart';
import 'package:ice_cream/app/template/slide_month.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> expenses = [
      {"name": "Açucar", "price": 19.50, "brand": "gigante"},
      {"name": "Leite", "price": 4, "brand": "JV"},
      {"name": "Leite", "price": 4, "brand": "JVC"},
      {"name": "Leite", "price": 3.50, "brand": "ML"},
      {"name": "Suco de morango", "price": 1.35, "brand": "TANG"},
      {"name": "Suco de maracujá", "price": 1.35, "brand": "TANG"},
      {"name": "Suco de baunilha com limão", "price": 0.95, "brand": "MID"},
      {"name": "Suco de Abacaxi", "price": 1.00, "brand": "Torange"},
    ];
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add,
                size: 40,
              ),
            ),
          ),
        ],
        title: const Text(
          "Minhas despesas",
          style: TextStyle(fontSize: 35),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 100,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.topCenter,
                child: SlideMonth(),
              ),
              ListView.builder(
                itemCount: expenses.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ListTile(
                        title: Text(
                          expenses[index]['name'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
