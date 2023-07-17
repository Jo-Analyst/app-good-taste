import 'package:app_good_taste/app/controller/flavor_controller.dart';
import 'package:app_good_taste/app/controller/product_controller.dart';
import 'package:app_good_taste/app/model/flavor_model.dart';
import 'package:app_good_taste/app/utils/message_dialog.dart';
import 'package:app_good_taste/app/utils/dialog.dart';
import 'package:app_good_taste/app/template/flavor_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _key = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  String name = "";
  double price = 0;
  int productId = 0;
  List<Map<String, dynamic>> flavors = [];
  List<Map<String, dynamic>> flavorsRemoved = [];
  List<FlavorModel> flavorModel = [];

  @override
  void initState() {
    super.initState();
  }

  void exitScreen() {
    Provider.of<FlavorController>(context, listen: false).clear();
    Navigator.of(context).pop();
  }

  void addFlavor(String flavorText) {
    setState(() {
      flavors.add({"id": 0, "type": flavorText, "product_id": 0});
    });
  }

  void updateFlavor(int index, String flavorText) {
    setState(() {
      flavors[index].update("type", (_) => flavorText);
    });
  }

  void removeFlavor(int index) {
    setState(() {
      flavorsRemoved.add(flavors.removeAt(index));
    });
  }

  Future<String?> showModalFlavorForm(
      BuildContext context, String? type) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (_) {
        return FlavorForm(
          type: type,
        );
      },
    );

    return result ?? '';
  }

  void confirmProduct() {
    final productProvider =
        Provider.of<ProductController>(context, listen: false);
    setListFlavorModel(); // Adiciona na lista flavorModel a classe antes da confirmação
    productProvider.save(productId, name, price, flavorModel);
    productProvider.loadProducts();
    // print(productProvider.items.length);
    // print(productProvider.items);
  }

  void setListFlavorModel() {
    for (var flavor in flavors) {
      flavorModel.add(
        FlavorModel(
          id: flavor["id"],
          type: flavor["type"],
          productId: flavor["product_id"],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final confirmExit =
            await showExitDialog(context, ListMessageDialog.messageDialog[0]);
        return confirmExit ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Meu Produto",
            style: TextStyle(fontSize: 25),
          ),
          leading: IconButton(
            onPressed: () {
              if (flavors.isNotEmpty ||
                  _nameController.text.isNotEmpty ||
                  _priceController.text.isNotEmpty) {
                showExitDialog(context, ListMessageDialog.messageDialog[0])
                    .then(
                  (confirmExit) {
                    if (confirmExit!) {
                      exitScreen();
                    }
                  },
                );
              } else {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(
              Icons.close,
              size: 35,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: flavors.isNotEmpty && name.isNotEmpty && price > 0
                    ? () {
                        confirmProduct();
                        Navigator.of(context).pop();
                      }
                    : null,
                icon: const Icon(
                  Icons.check_outlined,
                  size: 35,
                ),
              ),
            )
          ],
          toolbarHeight: 100,
        ),
        body: Container(
          height: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 15,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: _key,
                      child: Column(
                        children: [
                          Column(
                            children: [
                              TextFormField(
                                onChanged: (nameProduct) {
                                  setState(
                                    () {
                                      name = nameProduct;
                                    },
                                  );
                                },
                                controller: _nameController,
                                decoration:
                                    const InputDecoration(labelText: "Nome"),
                                textInputAction: TextInputAction.next,
                              ),
                              TextFormField(
                                controller: _priceController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                textInputAction: TextInputAction.next,
                                decoration:
                                    const InputDecoration(labelText: "Preço"),
                                onChanged: (String? priceProduct) {
                                  setState(() {
                                    price = (priceProduct != null &&
                                            priceProduct != "")
                                        ? double.tryParse(priceProduct) ?? 0.0
                                        : 0.0;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Sabores ou tipos: ",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              final typeOrFlavor =
                                  await showModalFlavorForm(context, null);
                              if (typeOrFlavor!.isNotEmpty) {
                                addFlavor(typeOrFlavor);
                              }
                            },
                            icon: Icon(
                              Icons.add_circle_outline,
                              color: Theme.of(context).primaryColor,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: double.infinity,
                      height: 1,
                      color: const Color.fromARGB(255, 238, 173, 195),
                    ),
                    flavors.isEmpty
                        ? Container(
                            margin: const EdgeInsets.only(top: 150),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    "Não há sabores adicionados.",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: flavors.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(flavors[index]["type"]),
                                    trailing: SizedBox(
                                      width: 100,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              final flavorOrType =
                                                  await showModalFlavorForm(
                                                      context,
                                                      flavors[index]["type"]);
                                              if (flavorOrType!.isNotEmpty) {
                                                updateFlavor(
                                                    index, flavorOrType);
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () => showExitDialog(
                                              context,
                                              ListMessageDialog
                                                  .messageDialog[1],
                                            ).then(
                                              (message) {
                                                if (message!) {
                                                  removeFlavor(index);
                                                }
                                              },
                                            ),
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                ],
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
