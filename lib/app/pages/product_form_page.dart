// ignore_for_file:

import 'package:app_good_taste/app/controllers/flavor_controller.dart';
import 'package:app_good_taste/app/controllers/product_controller.dart';
import 'package:app_good_taste/app/models/flavor_model.dart';
import 'package:app_good_taste/app/utils/dialog.dart';
import 'package:app_good_taste/app/template/flavor_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../utils/modal.dart';

class ProductFormPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final List<Map<String, dynamic>>? flavors;
  const ProductFormPage({
    required this.product,
    this.flavors,
    super.key,
  });

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _key = GlobalKey<FormState>();
  final _nameController = TextEditingController(),
      _priceController = TextEditingController();
  String name = "";
  double price = 0;
  int productId = 0;
  List<Map<String, dynamic>> flavors = [], flavorsRemoved = [];
  List<FlavorModel> flavorModel = [];
  late FlavorController flavorController;
  @override
  void initState() {
    super.initState();
    flavorController = Provider.of<FlavorController>(context, listen: false);
    if (widget.product.isEmpty) return;

    name = widget.product["name"];
    price = widget.product["price"];
    productId = widget.product["id"] == null ? 0 : widget.product["id"] as int;

    _nameController.text = name;
    _priceController.text =
        price.toStringAsFixed(2).replaceAll(RegExp(r'\.'), ',');

    for (var flavor in widget.flavors!) {
      if (flavor["product_id"] == productId) {
        flavors.add(flavor);
      }
    }
  }

  void addFlavor(String flavorText) {
    setState(() {
      flavors.add({"id": 0, "type": flavorText, "product_id": 0});
    });
  }

  void updateFlavor(int index, String flavorText) {
    setState(() {
      flavors[index] = {
        "id": flavors[index]["id"],
        "type": flavorText,
        "product_id": flavors[index]["product_id"],
      };
    });
  }

  void removeFlavorList(int index) {
    setState(() {
      if (productId > 0) {
        flavorsRemoved.add(flavors.removeAt(index));
      } else {
        flavors.removeAt(index);
      }
    });
  }

  String getFlavorsRemoved() {
    String text = "\n\n";
    for (var flavorRemoved in flavorsRemoved) {
      text += "\t* ${flavorRemoved["type"]}\n";
    }
    return text;
  }

  // Mostra um dialogo para que o usuário confirma a exclusão
  bool _shouldExit = false;

  Future<bool> confirmBeforeLeaving() async {
    if (flavorsRemoved.isNotEmpty) {
      final confirmExit = await showExitDialog(
        context,
        {
          "title": "Confirmação",
          "content":
              "Os seguintes sabores foram excluídos da lista: ${getFlavorsRemoved()}\n Você confirma esta ação?",
          "show_button_cancel": false,
          "show_button_YN": true,
          "action": "Sim",
        },
      );

      if (confirmExit != null) {
        if (confirmExit) {
          confirmProduct();
          flavorController.clear();
          navigatorKey.currentState?.pop(true); // Fechar a tela atual
        } else {
          _shouldExit = true;
        }
      }
    } else {
      _shouldExit = true;
    }

    return _shouldExit;
  }

  void confirmProduct() async {
    final productProvider =
        Provider.of<ProductController>(context, listen: false);
    setListFlavorModel(); // Adiciona na lista flavorModel a classe antes da confirmação
    await productProvider.save(productId, name, price, flavorModel);
    if (productId > 0 && flavorsRemoved.isNotEmpty) {
      removeFlavorDB();
    }
  }

  void removeFlavorDB() {
    final flavorProvider =
        Provider.of<FlavorController>(context, listen: false);
    for (var fr in flavorsRemoved) {
      flavorProvider.delete(fr["id"]);
    }
  }

  void setListFlavorModel() {
    for (var flavor in flavors) {
      flavorModel.add(
        FlavorModel(
          flavor["id"],
          flavor["type"],
          flavor["product_id"],
        ),
      );
    }
  }

  void showModalForm(String type, int? index) async {
    final typeOrFlavor = await showModal(
        context,
        FlavorForm(
          isEdition: type.isNotEmpty,
          type: type,
        ));
    if (typeOrFlavor.isNotEmpty && type.isEmpty) {
      addFlavor(typeOrFlavor);
    } else if (typeOrFlavor.isNotEmpty && type.isNotEmpty) {
      updateFlavor(index!, typeOrFlavor);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_shouldExit) {
      // Fecha a tela atual
      WidgetsBinding.instance
          .addPostFrameCallback((_) => Navigator.of(context).pop());
    }

    return WillPopScope(
      onWillPop: confirmBeforeLeaving,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Meu Produto",
          ),
          leading: IconButton(
            onPressed: () {
              confirmBeforeLeaving().then((shouldExit) {
                if (shouldExit) {
                  Navigator.of(context).pop(); // Fechar a tela atual
                }
              });
            },
            icon: const Icon(
              Icons.keyboard_arrow_left,
              size: 40,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: name.isNotEmpty && price > 0
                    ? () {
                        confirmProduct();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Produto salvo com sucesso."),
                            duration: Duration(milliseconds: 3000),
                          ),
                        );

                        Navigator.of(context).pop(true);
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
                                      name = nameProduct.trim();
                                    },
                                  );
                                },
                                controller: _nameController,
                                decoration:
                                    const InputDecoration(labelText: "Nome"),
                                textInputAction: TextInputAction.next,
                                textCapitalization: TextCapitalization.words,
                              ),
                              TextFormField(
                                controller: _priceController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                textInputAction: TextInputAction.next,
                                decoration:
                                    const InputDecoration(labelText: "Preço"),
                                onChanged: (String? priceProduct) {
                                  setState(() {
                                    price = (priceProduct != null &&
                                            priceProduct != "")
                                        ? double.parse(priceProduct.replaceAll(
                                            RegExp(r','), '.'))
                                        : 0.0;
                                  });
                                },
                                onFieldSubmitted: (_) =>
                                    showModalForm("", null),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: GestureDetector(
                        onTap: () => showModalForm("", null),
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
                            Icon(
                              Icons.add_circle_outline,
                              color: Theme.of(context).primaryColor,
                              size: 40,
                            ),
                          ],
                        ),
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
                                              showModalForm(
                                                  flavors[index]["type"],
                                                  index);
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Color.fromARGB(
                                                  255, 22, 104, 171),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () =>
                                                removeFlavorList(index),
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
