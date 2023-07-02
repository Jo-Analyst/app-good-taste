import 'package:flutter/material.dart';
import 'package:ice_cream/app/partils/modal.dart';
import 'package:ice_cream/app/template/feedstock_list.dart';

class FeedstockPage extends StatelessWidget {
  const FeedstockPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> feedstock = [
      {"id": 0, "name": "Açucar", "price": 19.50, "brand": ""},
      {"id": 1, "name": "Leite", "price": 4, "brand": "JV"},
      {"id": 2, "name": "Leite", "price": 4, "brand": "JVC"},
      {"id": 3, "name": "Leite", "price": 3.50, "brand": "ML"},
      {"id": 4, "name": "Suco de morango", "price": 1.35, "brand": "TANG"},
      {"id": 5, "name": "Suco de maracujá", "price": 1.35, "brand": "TANG"},
      {"id": 6, "name": "Suco de baunilha com limão", "price": 0.95, "brand": "MID"},
      {"id": 7, "name": "Suco de Abacaxi", "price": 1.00, "brand": "Torange"},
      {"id": 8, "name": "Suco de Uva", "price": 1.35, "brand": "TANG"},
      {"id": 9, "name": "Suco de Iorgute de Morango", "price": .95, "brand": "MID"},
      {"id": 10, "name": "Suco de Iorgute de Maracujá", "price": .95, "brand": "MID"},
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
