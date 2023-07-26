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
  const ProductionPage({
    required this.production,
    required this.listFeedstock,
    super.key,
  });

  @override
  State<ProductionPage> createState() => _ProductionPageState();
}

class _ProductionPageState extends State<ProductionPage> {
  final productController = TextEditingController();
  final flavorController = TextEditingController();
  final quantityController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> products = [],
      feedstocks = [],
      listOfSelectedFeedstocks = [];
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
    loadFeedstock();

    if (widget.production.isEmpty) return;

    loadFieldProduction();
    listOfSelectedFeedstocks = widget.listFeedstock;
  }

  void loadFieldProduction() {
    quantity = widget.production["quantity"];
    valueEntry = widget.production["value_entry"];
    valueLeave = widget.production["value_leave"];
    valueProfit = widget.production["value_profit"];
    flavorEditing = widget.production["flavor"];
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

  void confirmProdution() async {
    final productionProvider = Provider.of<ProductionController>(
      context,
      listen: false,
    );

    await productionProvider.save({
      "id": productionId,
      "quantity": quantity,
      "date": DateFormat("dd/MM/yyyy").format(dateSelected),
      "flavor_id": flavorId,
      "price_product": price,
      "value_entry": valueEntry,
      "value_leave": valueLeave,
      "value_profit": valueProfit,
    }, getItemsProduction());
  }

  List<Map<String, dynamic>> getItemsProduction() {
    List<Map<String, dynamic>> list = [];
    for (var listFeedstocks in listOfSelectedFeedstocks) {
      list.add({
        "item_product_id": itemProductionId,
        "feedstock_id": listFeedstocks["id"],
        "price_feedstock": listFeedstocks["price"],
        "production_id": productionId,
      });
    }

    return list;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 233, 233),
      appBar: AppBar(
        title: const Text(
          "Produção do dia",
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
                      confirmProdution();
                      Navigator.pop(context, true);
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
            Navigator.of(context).pop();
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
                        dynamic selectedFeedstocks = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FeedstockListPage(
                                listOfSelectedFeedstocks, feedstocks),
                          ),
                        );
                        if (selectedFeedstocks != null) {
                          setState(() {
                            listOfSelectedFeedstocks.clear();
                            listOfSelectedFeedstocks.addAll(selectedFeedstocks);
                            for (var feedstock in feedstocks) {
                              feedstock["isChecked"] = false;
                            }
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
                                      listOfSelectedFeedstocks.removeAt(index);
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
