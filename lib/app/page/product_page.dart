import 'package:app_good_taste/app/controller/flavor_controller.dart';
import 'package:app_good_taste/app/controller/product_controller.dart';
import 'package:app_good_taste/app/page/product_form_page.dart';
import 'package:flutter/material.dart';
import 'package:app_good_taste/app/template/product_list.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> flavors = [];
  @override
  void initState() {
    super.initState();
    loadProducts();
    loadFlavors();
  }

  Future<void> loadProducts() async {
    final productProvider =
        Provider.of<ProductController>(context, listen: false);
    await productProvider.loadProducts();
    setState(() {
      products = productProvider.items;
    });
  }

  Future<void> loadFlavors() async {
    final flavorsProvider =
        Provider.of<FlavorController>(context, listen: false);
    await flavorsProvider.loadFlavors();
    setState(() {
      flavors = flavorsProvider.items;
      print(flavors);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () async {
                final isSaved = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductFormPage(),
                  ),
                );

                if (isSaved == true) {
                  await loadProducts();
                }
              },
              icon: const Icon(
                Icons.add,
                size: 40,
              ),
            ),
          ),
        ],
        title: const Text(
          "Gerenciar Produtos",
          style: TextStyle(fontSize: 25),
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
                      return Column(
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  ProductList(products[index]),
                                  const SizedBox(height: 5),
                                  Container(
                                    color: const Color.fromARGB(
                                        179, 246, 245, 245),
                                    child: Column(
                                      children: flavors
                                          .where((e) =>
                                              e["product_id"] ==
                                              products[index]["id"])
                                          .map((flavor) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(flavor['type'].toString()),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
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
