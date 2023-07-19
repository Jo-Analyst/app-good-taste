import 'package:app_good_taste/app/controller/flavor_controller.dart';
import 'package:app_good_taste/app/controller/product_controller.dart';
import 'package:app_good_taste/app/model/flavor_model.dart';
import 'package:app_good_taste/app/utils/message_dialog.dart';
import 'package:app_good_taste/app/utils/dialog.dart';
import 'package:app_good_taste/app/template/flavor_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/modal.dart';

class ProductFormPage extends StatefulWidget {
  final Map<String, dynamic>? product;
  final List<Map<String, dynamic>>? flavors;
  const ProductFormPage({
    this.product,
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

  @override
  void initState() {
    super.initState();
    if (widget.product == null && widget.flavors == null) return;

    name = widget.product!["name"];
    price = widget.product!["price"];
    productId = widget.product!["id"];

    _nameController.text = name;
    _priceController.text = price.toString();

    for (var flavor in widget.flavors!) {
      if (flavor["product_id"] == productId) {
        flavors.add(flavor);
      }
    }
  }

  void exitScreen() {
    if (flavors.isNotEmpty ||
        _nameController.text.isNotEmpty ||
        _priceController.text.isNotEmpty) {
      showExitDialog(context, ListMessageDialog.messageDialog[0]).then(
        (confirmExit) {
          if (confirmExit!) {
            Provider.of<FlavorController>(context, listen: false).clear();
            Navigator.of(context).pop();
          }
        },
      );
    } else {
      Navigator.of(context).pop(false);
    }
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

  void removeFlavorList(int index) {
    if (productId > 0) {
      setState(() {
        flavorsRemoved.add(flavors.removeAt(index));
      });
    }
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
    final flavorProvider = Provider.of<FlavorController>(context, listen: false);
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
    return WillPopScope(
      onWillPop: () async {
        bool? confirmExit = false;
        if (flavors.isNotEmpty ||
            _nameController.text.isNotEmpty ||
            _priceController.text.isNotEmpty) {
          confirmExit =
              await showExitDialog(context, ListMessageDialog.messageDialog[0]);
          return confirmExit ?? false;
        } else {
          Navigator.pop(context);
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Meu Produto",
            style: TextStyle(fontSize: 25),
          ),
          leading: IconButton(
            onPressed: () => exitScreen(),
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
                                        ? double.tryParse(priceProduct) ?? 0.0
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
                              showModalForm("", null);
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
                                              showModalForm(
                                                  flavors[index]["type"],
                                                  index);
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
                                                  removeFlavorList(index);
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
