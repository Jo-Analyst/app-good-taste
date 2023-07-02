import 'package:flutter/material.dart';
import 'package:ice_cream/app/template/product_list.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> products = [
      {
        "product_id": 0,
        "name": "Chup-Chup Goumert",
        "price": 3,
        "type": "Trufa de Morango",
        "flavor_id": 0
      },
      {
        "product_id": 1,
        "name": "Chup-Chup Goumert",
        "price": 3,
        "type": "Trufa de Maracujá",
        "flavor_id": 1
      },
      {
        "product_id": 2,
        "name": "Chup-Chup Goumert",
        "price": 3,
        "type": "Trufa de limão",
        "flavor_id": 2
      },
      {
        "product_id": 3,
        "name": "Chup-Chup Goumert",
        "price": 3,
        "type": "BIS",
        "flavor_id": 3
      },
      {
        "product_id": 4,
        "name": "Chup-Chup cremoso",
        "price": 1.50,
        "type": "Morango",
        "flavor_id": 4
      },
      {
        "product_id": 5,
        "name": "Chup-Chup cremoso",
        "price": 1.50,
        "type": "Maracujá",
        "flavor_id": 5
      },
      {
        "product_id": 6,
        "name": "Chup-Chup cremoso",
        "price": 1.50,
        "type": "Baunilha com limão",
        "flavor_id": 6
      },
      {
        "product_id": 7,
        "name": "Chup-Chup cremoso",
        "price": 1.50,
        "type": "Abacaxi",
        "flavor_id": 7
      },
      {
        "product_id": 8,
        "name": "Chup-Chup cremoso",
        "price": 1.50,
        "type": "Chocolate",
        "flavor_id": 8
      },
      {
        "product_id": 9,
        "name": "Chup-Chup cremoso",
        "price": 1.50,
        "type": "Uva",
        "flavor_id": 9
      },
      {
        "product_id": 10,
        "name": "Chup-Chup cremoso",
        "price": 1.50,
        "type": "Iorgute de morango",
        "flavor_id": 10
      },
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
          "Gerenciar Produtos",
          style: TextStyle(fontSize: 30),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 100,
      ),
      body: products.isNotEmpty
          ? ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                    itemCount: products.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Card(
                        child: ProductList(products[index]),
                      );
                    },
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                "Não há produto cadastrado.",
                style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.displayLarge!.fontSize),
              ),
            ),
    );
  }
}
