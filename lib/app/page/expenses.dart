import 'package:flutter/material.dart';
import 'package:ice_cream/app/template/expense_list.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> expenses = [
      {"name": "Açucar", "price": 19.50, "brand": "GIGANTE"},
      {"name": "Leite", "price": 4, "brand": "JV"},
      {"name": "Leite", "price": 4, "brand": "JVC"},
      {"name": "Leite", "price": 3.50, "brand": "ML"},
      {"name": "Suco de morango", "price": 1.35, "brand": "TANG"},
      {"name": "Suco de maracujá", "price": 1.35, "brand": "TANG"},
      {"name": "Suco de baunilha com limão", "price": 0.95, "brand": "MID"},
      {"name": "Suco de Abacaxi", "price": 1.00, "brand": "Torange"},
      {"name": "Suco de Uva", "price": 1.35, "brand": "TANG"},
      {"name": "Suco de Iorgute de Morango", "price": .95, "brand": "MID"},
      {"name": "Suco de Iorgute de Maracujá", "price": .95, "brand": "MID"},
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
          "Gerenciar despesas",
          style: TextStyle(fontSize: 30),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 100,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(
              itemCount: expenses.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Card(
                  child: ExpenseList(expenses[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
