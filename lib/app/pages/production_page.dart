import 'package:app_good_taste/app/controllers/production_controller.dart';
import 'package:app_good_taste/app/pages/feedstock_list_page.dart';
import 'package:app_good_taste/app/pages/list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/feedstock_controller.dart';

class ProductionPage extends StatefulWidget {
  final Map<String, dynamic> production;
  final List<Map<String, dynamic>> listFeedstock;
  final bool isEdition;
  const ProductionPage({
    required this.production,
    required this.listFeedstock,
    required this.isEdition,
    super.key,
  });

  @override
  State<ProductionPage> createState() => _ProductionPageState();
}

class _ProductionPageState extends State<ProductionPage> {
  final productController = TextEditingController();
  final flavorController = TextEditingController();
  final quantityController = TextEditingController();
  bool confirmSave = false;
  final formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> products = [],
      feedstocks = [],
      listOfSelectedFeedstocks = [],
      removeItemsFlavors = [],
      copyListOfSelectedFeedstocks = [];
  final List<String> flavors = [];
  bool productWasSelected = false;
  DateTime dateSelected = DateTime.now();

  // entrada = 0, saida = 0, lucro = 0, quantidade = 0, preço
  double valueEntry = 0, valueLeave = 0, valueProfit = 0, price = 0;

  String? flavorSelect, flavorEditing = '';
  String productText = "", flavorText = "";
  int quantity = 0,
      productionId = 0,
      itemProductionId = 0,
      productId = 0,
      flavorId = 0;

  final valueNotifier = ValueNotifier("");

  @override
  void dispose() {
    valueNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadFeedstock();

    copyListOfSelectedFeedstocks.addAll(widget.listFeedstock);
    // if (widget.production.isEmpty) return;
    if (!widget.isEdition) return;

    loadFieldProduction();
    listOfSelectedFeedstocks = widget.listFeedstock;
  }

  void loadFieldProduction() {
    quantity = widget.production["quantity"];
    valueEntry = widget.production["value_entry"];
    valueLeave = widget.production["value_leave"];
    valueProfit = widget.production["value_profit"];
    flavorEditing = widget.production["flavor"];
    flavorId = widget.production["flavor_id"];
    productId = widget.production["product_id"];
    // flavorSelect = flavors[getIndexListFlavors(flavorEditing!)];
    price = widget.production["price"];
    productionId = widget.production["id"];
    // itemProductionId = widget.itemProductionId["id"];
    productController.text = widget.production["name"];
    flavorController.text = flavorEditing!;
    quantityController.text = quantity.toString();
    int year = int.parse(widget.production["date"].toString().split("/")[2]);
    int month = int.parse(widget.production["date"].toString().split("/")[1]);
    int day = int.parse(widget.production["date"].toString().split("/")[0]);
    dateSelected = DateTime(year, month, day);
    productWasSelected = true;
    productText = productController.text;
    flavorText = flavorController.text;
    calculateProfit();
  }

  void loadFeedstock() async {
    final feedstockProvider =
        Provider.of<FeedstockController>(context, listen: false);
    await feedstockProvider.loadFeedstock();
    setState(() {
      for (var item in feedstockProvider.items) {
        feedstocks.add({
          "id": item["id"],
          "name": item["name"],
          "price": item["price"],
          "brand": item["brand"],
          "isChecked": false,
        });
      }
    });
  }

  Future<bool> confirmProdution() async {
    final productionProvider = Provider.of<ProductionController>(
      context,
      listen: false,
    );

    return await productionProvider.save({
      "id": productionId,
      "quantity": quantity,
      "date": DateFormat("dd/MM/yyyy").format(dateSelected),
      "flavor_id": flavorId,
      "price_product": price,
      "value_entry": valueEntry,
      "value_leave": valueLeave,
      "value_profit": valueProfit,
    }, getItemsProduction(), removeItemsFlavors);
  }

  List<Map<String, dynamic>> getItemsProduction() {
    List<Map<String, dynamic>> list = [];
    for (var listFeedstocks in listOfSelectedFeedstocks) {
      list.add({
        "item_production_id": listFeedstocks["item_production_id"],
        "feedstock_id": listFeedstocks["id"],
        "price_feedstock": listFeedstocks["price"],
        "production_id": productionId,
      });
    }

    return list;
  }

  void rewriteItemsProductIdInList() {
    if (widget.isEdition) {
      for (var list in listOfSelectedFeedstocks) {
        var found =
            false; // Variável para rastrear se foi encontrado um objeto correspondente
        for (var copyList in copyListOfSelectedFeedstocks) {
          if (int.parse(copyList["id"].toString()) ==
              int.parse(list["id"].toString())) {
            list["item_production_id"] = copyList["item_production_id"];
            found =
                true; // Definir found como true se o objeto correspondente for encontrado
            break; // Não é necessário continuar procurando depois que o objeto correspondente é encontrado
          }
        }
        if (!found) {
          list["item_production_id"] =
              0; // Definir como 0 somente se não houver correspondência encontrada
        }
      }
    } else {
      for (var list in listOfSelectedFeedstocks) {
        list["item_production_id"] = 0;
      }
    }
  }

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
      valueEntry = quantity * price;
    });
  }

  void calculateProfit() {
    setState(() {
      valueProfit = valueEntry - valueLeave;
    });
  }

  void calculateLeave() {
    valueLeave = 0;

    setState(() {
      for (var feedstock in listOfSelectedFeedstocks) {
        valueLeave += feedstock["price"];
      }
    });
  }

  void decreaseOutputWhenExcludingRawMaterial(int index) {
    setState(() {
      double price =
          double.parse(listOfSelectedFeedstocks[index]["price"].toString());
      if (valueLeave >= price) {
        valueLeave -= price;
      } else {
        valueLeave = 0;
      }
    });
  }

  showCalendarPicker() {
    showDatePicker(
      context: context,
      initialDate: dateSelected,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    ).then(
      (date) => setState(() {
        if (date != null) {
          dateSelected = date;
        }
      }),
    );
  }

  void updateFlavorsRemovalList() {
    for (var list in listOfSelectedFeedstocks) {
      removeItemsFlavors.removeWhere((flavor) =>
          flavor["item_production_id"] == list["item_production_id"]);
    }
  }

  void changeListItemsChecked(Map<String, dynamic> listOfSelectedFeedstock) {
    for (var feedstock in feedstocks) {
      if (feedstock["id"] == listOfSelectedFeedstock["id"]) {
        feedstock["isChecked"] = false;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 233, 233),
      appBar: AppBar(
        title: Text(
          widget.isEdition
              ? "Produção de ${DateFormat("dd/MM/yy").format(dateSelected)}"
              : "Produção do dia",
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: quantity > 0 &&
                      listOfSelectedFeedstocks.isNotEmpty &&
                      productText.isNotEmpty &&
                      flavorText.isNotEmpty
                  ? () {
                      confirmProdution().then((confirmSave) {
                        if (confirmSave) {
                          Navigator.pop(context, [confirmSave, dateSelected]);
                        }
                      });
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
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.of(context).pop([false, dateSelected]);
          },
          icon: const Icon(
            Icons.close,
            size: 35,
          ),
        ),
        toolbarHeight: 100,
      ),
      body: SingleChildScrollView(
        child: Container(
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
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: productController,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: "Produto",
                                labelStyle: const TextStyle(fontSize: 18),
                                floatingLabelStyle: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          IconButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              final data = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const ListPage(
                                    labelText: "Produtos",
                                  ),
                                ),
                              );

                              if (data != null) {
                                productController.text = data["name"];
                                setState(() {
                                  productId = data["id"];
                                  productText = productController.text;
                                  productWasSelected = true;
                                  price = 0;
                                  valueEntry = 0;
                                });
                                flavorController.text = "";
                                flavorText = "";
                              }
                            },
                            icon: Icon(
                              Icons.select_all_sharp,
                              size: 40,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: flavorController,
                              readOnly: true,
                              decoration: InputDecoration(
                                fillColor: Colors.black,
                                labelText: "Sabor",
                                labelStyle: const TextStyle(fontSize: 18),
                                floatingLabelStyle: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          IconButton(
                            onPressed: !productWasSelected
                                ? null
                                : () async {
                                    FocusScope.of(context).unfocus();
                                    final data =
                                        await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ListPage(
                                          labelText: "Sabores",
                                          productId: productId,
                                        ),
                                      ),
                                    );

                                    if (data != null) {
                                      setState(() {
                                        flavorId = data["id"];
                                        flavorController.text = data["type"];
                                        flavorText = data["type"];
                                        price = data["price"];
                                      });
                                      calculateInputValue();
                                      calculateProfit();
                                    }
                                  },
                            icon: Icon(
                              Icons.select_all_sharp,
                              size: 40,
                              color: productText.isEmpty
                                  ? Colors.black12
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: TextFormField(
                              controller: quantityController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
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
                          ),
                          Text(
                            DateFormat("dd 'de' MMMM 'de' yyyy", "pt-br")
                                .format(dateSelected),
                            style: const TextStyle(fontSize: 19),
                          ),
                          IconButton(
                            onPressed: () => showCalendarPicker(),
                            icon: Icon(
                              Icons.calendar_month_sharp,
                              color: Theme.of(context).primaryColor,
                              size: 35,
                            ),
                          ),
                        ],
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
                        FocusScope.of(context).unfocus();
                        dynamic feedstockList = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FeedstockListPage(
                              listOfSelectedFeedstocks,
                              feedstocks,
                              widget.isEdition,
                            ),
                          ),
                        );

                        if (feedstockList != null) {
                          listOfSelectedFeedstocks.clear();
                          listOfSelectedFeedstocks.addAll(feedstockList[0]);
                          rewriteItemsProductIdInList();
                          updateFlavorsRemovalList();
                          for (var feedstock in feedstocks) {
                            feedstock["isChecked"] = false;
                          }
                          calculateLeave();
                          calculateProfit();

                          for (var list in feedstockList[1]) {
                            removeItemsFlavors.where((flavor) =>
                                flavor["item_product_id"] ==
                                list[flavor["item_product_id"]]);
                            removeItemsFlavors.add(list);
                          }
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
                listOfSelectedFeedstocks.isEmpty
                    ? const SizedBox(
                        height: 205,
                        child: Center(
                          child: Text(
                            "Não há matéria prima adicionada.",
                            style: TextStyle(fontSize: 18),
                          ),
                        ))
                    : SizedBox(
                        height: 205,
                        child: ListView.builder(
                          itemCount: listOfSelectedFeedstocks.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    "${listOfSelectedFeedstocks[index]['name']}",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  subtitle: Text(
                                    "${listOfSelectedFeedstocks[index]['brand']}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  leading: CircleAvatar(
                                    radius: 30,
                                    child: Text(
                                      NumberFormat("R\$ #0.00", "PT-BR").format(
                                          listOfSelectedFeedstocks[index]
                                              ["price"]),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      decreaseOutputWhenExcludingRawMaterial(
                                          index);
                                      calculateProfit();
                                      changeListItemsChecked(
                                          listOfSelectedFeedstocks[index]);
                                      final itemFlavor =
                                          listOfSelectedFeedstocks
                                              .removeAt(index);
                                      if (widget.isEdition) {
                                        removeItemsFlavors.add(itemFlavor);
                                      }

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
                          NumberFormat("R\$ #0.00", "PT-BR").format(valueEntry),
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
                          NumberFormat("R\$ #0.00", "PT-BR").format(valueLeave),
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
                          NumberFormat("R\$ #0.00", "PT-BR")
                              .format(valueProfit),
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
      ),
    );
  }
}
