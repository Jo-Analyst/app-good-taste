import 'package:flutter/material.dart';
import 'package:ice_cream/app/partils/modal.dart';
import 'package:ice_cream/app/template/feedstock_list.dart';

class FeedstockPage extends StatelessWidget {
  const FeedstockPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> feedstock = [
      {"name": "Açucar", "price": 19.50, "brand": ""},
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
              onPressed: () => Modal.showModal(context, {}),
              icon: const Icon(
                Icons.add,
                size: 40,
              ),
            ),
          ),
        ],
        title: const Text(
          "Gerenciar M. Prima",
          style: TextStyle(fontSize: 30),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 100,
      ),
      body: feedstock.isNotEmpty
          ? ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                    itemCount: feedstock.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Card(
                        child: FeedstockList(feedstock[index]),
                      );
                    },
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                "Não há matéria prima cadastrada.",
                style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.displayLarge!.fontSize),
              ),
            ),
    );
  }
}
