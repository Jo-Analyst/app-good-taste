import 'package:app_good_taste/app/controllers/product_controller.dart';
import 'package:app_good_taste/app/pages/raw_material_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/drop_down.dart';

class ProductionPage extends StatefulWidget {
  final Map<String, dynamic> production;
  const ProductionPage({required this.production, super.key});

  @override
  State<ProductionPage> createState() => _ProductionPageState();
}

class _ProductionPageState extends State<ProductionPage> {
  final formKey = GlobalKey<FormState>();
  final quantityController = TextEditingController();
  List<Map<String, dynamic>> products = [];

  // entrada = 0, saida = 0, lucro = 0, quantidade = 0, preço
  double entry = 0, leave = 0, proft = 0, price = 0;

  String? flavorSelect, flavorEditing = '';
  int quantity = 0, id = 0;

  final List<String> flavors = [];

  final valueNotifier = ValueNotifier("");

  @override
  void dispose() {
    valueNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadProducts();

    if (widget.production.isEmpty) return;

    quantity = widget.production["quantity"];
    quantityController.text = quantity.toString();

    entry = widget.production["subtotal"];
    flavorEditing = widget.production["flavor"];
    flavorSelect = flavors[getIndexListFlavors(flavorEditing!)];
    price = widget.production["price"];
    id = widget.production["id"];
    calculateProfit();
  }

  void loadProducts() async {
    final productController =
        Provider.of<ProductController>(context, listen: false);
    await productController.loadingProductByParts();
    setState(() {
      products = productController.items;
      for (var product in products) {
        flavors.add(product["flavor"]);
      }
    });
  }

  final List<Map<String, dynamic>> listOfSelectedRawMaterials = [];

  int getIndexListFlavors(String flavorEditing) {
    int index = -1;
    for (int i = 0; i < flavors.length; i++) {
      if (flavorEditing.toLowerCase() == flavors[i].toLowerCase()) {
        index = i;
      }
    }
    return index;
  }

  void calculateInputValue() {
    setState(() {
      entry = quantity * price;
    });
  }

  void calculateProfit() {
    setState(() {
      proft = entry - leave;
    });
  }

  void calculateLeave() {
    leave = 0;

    setState(() {
      for (var feedstock in listOfSelectedRawMaterials) {
        leave += feedstock["price"];
      }
    });
  }

  void decreaseOutputWhenExcludingRawMaterial(int index) {
    setState(() {
      double price =
          double.parse(listOfSelectedRawMaterials[index]["price"].toString());
      if (leave >= price) {
        leave -= price;
      } else {
        leave = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Produção do dia",
          style: TextStyle(fontSize: 25),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: quantity > 0 &&
                      flavorSelect != null &&
                      listOfSelectedRawMaterials.isNotEmpty
                  ? () {
                      // salva os dados aqui no sqllite
                      Navigator.of(context).pop();
                    }
                  : null,
              icon: const Icon(
                Icons.check,
                size: 35,
              ),
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.close,
            size: 35,
          ),
        ),
        toolbarHeight: 100,
      ),
      body: Container(
        color: const Color.fromARGB(255, 235, 233, 233),
        padding: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                child: Column(
                  children: [
                    DropDownUtils(flavors, "Sabor",
                        indexFlavorEditing: getIndexListFlavors(flavorEditing!),
                        onValueChanged: (selectedIndex) {
                      flavorSelect = products[selectedIndex]["flavor"];
                      setState(
                        () {
                          price = products[selectedIndex]["price"] as double;
                        },
                      );
                      calculateInputValue();
                      calculateProfit();
                    }),
                    const Divider(),
                    TextFormField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        setState(() {
                          quantity = value != "" ? int.parse(value) : 0;
                        });
                        calculateInputValue();
                        calculateProfit();
                      },
                      decoration: InputDecoration(
                        labelText: "Quantidade",
                        labelStyle: const TextStyle(fontSize: 18),
                        floatingLabelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Divider(
                color: Color.fromARGB(255, 228, 108, 148),
                height: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Matéria prima",
                    style: TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    onPressed: () async {
                      dynamic selectedRawMaterials = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              RawMaterialPage(listOfSelectedRawMaterials),
                        ),
                      );
                      if (selectedRawMaterials != null) {
                        setState(() {
                          listOfSelectedRawMaterials.clear();
                          listOfSelectedRawMaterials
                              .addAll(selectedRawMaterials);
                        });

                        calculateLeave();
                        calculateProfit();
                      }
                    },
                    icon: Icon(
                      Icons.add,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              const Divider(
                color: Color.fromARGB(255, 228, 108, 148),
                height: 2,
              ),
              listOfSelectedRawMaterials.isEmpty
                  ? const Flexible(
                      child: Center(
                      child: Text(
                        "Não há matéria prima adicionada.",
                        style: TextStyle(fontSize: 18),
                      ),
                    ))
                  : Flexible(
                      child: ListView.builder(
                        itemCount: listOfSelectedRawMaterials.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  "${listOfSelectedRawMaterials[index]['name']}",
                                  style: const TextStyle(fontSize: 18),
                                ),
                                subtitle: Text(
                                  "${listOfSelectedRawMaterials[index]['brand']}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                leading: CircleAvatar(
                                  radius: 30,
                                  child: Text(
                                    NumberFormat("R\$ #0.00", "PT-BR").format(
                                        listOfSelectedRawMaterials[index]
                                            ["price"]),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    decreaseOutputWhenExcludingRawMaterial(
                                        index);
                                    calculateProfit();
                                    listOfSelectedRawMaterials.removeAt(index);
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "E:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Flexible(
                    child: Chip(
                      backgroundColor: Colors.blue,
                      label: Text(
                        NumberFormat("R\$ #0.00", "PT-BR").format(entry),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const Text(
                    "S:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Flexible(
                    child: Chip(
                      backgroundColor: Colors.red,
                      label: Text(
                        NumberFormat("R\$ #0.00", "PT-BR").format(leave),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const Text(
                    "L:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Flexible(
                    child: Chip(
                      backgroundColor: Colors.green,
                      label: Text(
                        NumberFormat("R\$ #0.00", "PT-BR").format(proft),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
