import 'package:app_good_taste/app/controllers/production_controller.dart';
import 'package:app_good_taste/app/pages/feedstock_list_page.dart';
import 'package:app_good_taste/app/pages/list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

  void increment(int index) {
    setState(() {
      listOfSelectedFeedstocks[index]['quantity']++;
      for (int i = 0; i < feedstocks.length; i++) {
        if (feedstocks[i]["id"] == listOfSelectedFeedstocks[index]["id"]) {
          feedstocks[i]["quantity"] =
              listOfSelectedFeedstocks[index]['quantity'];
          break;
        }
      }
    });
    calculateSubTotal(index);
  }

  void decrement(int index) {
    if (listOfSelectedFeedstocks[index]['quantity'] == 1) return;
    setState(() {
      listOfSelectedFeedstocks[index]['quantity'] -= 1;

      for (int i = 0; i < feedstocks.length; i++) {
        if (feedstocks[i]["id"] == listOfSelectedFeedstocks[index]["id"]) {
          if (feedstocks[i]['quantity'] == 1) return;
          feedstocks[i]["quantity"] =
              listOfSelectedFeedstocks[index]['quantity'];
          break;
        }
      }
    });
    calculateSubTotal(index);
  }

  void calculateSubTotal(int index) {
    setState(() {
      listOfSelectedFeedstocks[index]['subtotal'] =
          listOfSelectedFeedstocks[index]['quantity'] *
              listOfSelectedFeedstocks[index]['price'];
    });
    calculateLeave();
    calculateProfit();
  }

  @override
  void initState() {
    super.initState();
    loadFeedstock();

    copyListOfSelectedFeedstocks.addAll(widget.listFeedstock);
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
    price = widget.production["price"];
    productionId = widget.production["id"];
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
        int quantity = 1;
        double subtotal = item["price"];
        if (widget.isEdition) {
          for (var listOfSelectedFeedstock in listOfSelectedFeedstocks) {
            if (item["id"] == listOfSelectedFeedstock["id"]) {
              quantity = listOfSelectedFeedstock["quantity"];
              subtotal = listOfSelectedFeedstock["subtotal"];
              break;
            }
          }
        }

        feedstocks.add({
          "id": item["id"],
          "name": item["name"],
          "price": item["price"],
          "brand": item["brand"],
          "quantity": quantity,
          "subtotal": subtotal,
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
    }, getItemsProduction());
  }

  List<Map<String, dynamic>> getItemsProduction() {
    List<Map<String, dynamic>> list = [];
    for (var listFeedstocks in listOfSelectedFeedstocks) {
      for (int i = 0; i < listFeedstocks["quantity"]; i++) {
        list.add({
          "item_production_id": listFeedstocks["item_production_id"],
          "feedstock_id": listFeedstocks["id"],
          "price_feedstock": listFeedstocks["price"],
          "production_id": productionId,
        });
      }
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
        valueLeave += feedstock["subtotal"];
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

  void changeListItemsChecked(Map<String, dynamic> listOfSelectedFeedstock) {
    for (var feedstock in feedstocks) {
      if (feedstock["id"] == listOfSelectedFeedstock["id"]) {
        feedstock["isChecked"] = false;
        break;
      }
    }
  }

  void addFeedstock() async {
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
      for (var feedstock in feedstocks) {
        feedstock["isChecked"] = false;
      }
      calculateLeave();
      calculateProfit();
    }
  }

  Future<bool> closeScreen() async {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop([false, dateSelected]);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => closeScreen(),
      child: Scaffold(
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
                            FocusScope.of(context).unfocus();
                            Navigator.pop(context, [confirmSave, dateSelected]);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(!widget.isEdition
                                    ? "Produção adicionado com sucesso."
                                    : "Produção atualizado com sucesso."),
                                duration: const Duration(milliseconds: 3000),
                              ),
                            );
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
            onPressed: () => closeScreen(),
            icon: const Icon(
              Icons.keyboard_arrow_left,
              size: 40,
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
                                    quantity =
                                        value != "" ? int.parse(value) : 0;
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
                            InkWell(
                              onTap: () => showCalendarPicker(),
                              child: Row(
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      DateFormat(
                                              "dd 'de' MMMM 'de' yyyy", "pt-br")
                                          .format(dateSelected),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Icon(
                                    Icons.calendar_month_sharp,
                                    color: Theme.of(context).primaryColor,
                                    size: 35,
                                  ),
                                ],
                              ),
                            )
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
                  InkWell(
                    onTap: () => addFeedstock(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Matéria prima",
                            style: TextStyle(fontSize: 18),
                          ),
                          Icon(
                            Icons.add,
                            size: 30,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 228, 108, 148),
                    height: 2,
                  ),
                  listOfSelectedFeedstocks.isEmpty
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height / 2 - 120,
                          child: const Center(
                            child: Text(
                              "Não há matéria prima adicionada.",
                              style: TextStyle(fontSize: 18),
                            ),
                          ))
                      : SizedBox(
                          height: MediaQuery.of(context).size.height / 2 - 120,
                          child: ListView.builder(
                            itemCount: listOfSelectedFeedstocks.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Slidable(
                                    endActionPane: ActionPane(
                                      motion: const StretchMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (_) {
                                            decreaseOutputWhenExcludingRawMaterial(
                                                index);
                                            calculateProfit();
                                            changeListItemsChecked(
                                                listOfSelectedFeedstocks[
                                                    index]);
                                            listOfSelectedFeedstocks
                                                .removeAt(index);

                                            setState(() {});
                                          },
                                          backgroundColor: Colors.red,
                                          icon: Icons.delete,
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
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
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            NumberFormat("R\$ #0.00", "PT-BR")
                                                .format(
                                                    listOfSelectedFeedstocks[
                                                        index]["subtotal"]),
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      trailing: SizedBox(
                                        width: 67,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 31,
                                              alignment: Alignment.center,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  listOfSelectedFeedstocks[
                                                          index]['quantity']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                InkWell(
                                                  onTap: () => increment(index),
                                                  child: Icon(
                                                    Icons.keyboard_arrow_up,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    size: 28,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () => decrement(index),
                                                  child: Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    size: 28,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
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
                        child: Container(
                          alignment: Alignment.center,
                          height: 25,
                          width: 90,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue,
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              NumberFormat("R\$ #0.00", "PT-BR")
                                  .format(valueEntry),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
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
                        child: Container(
                          alignment: Alignment.center,
                          height: 25,
                          width: 90,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              NumberFormat("R\$ #0.00", "PT-BR")
                                  .format(valueLeave),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
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
                        child: Container(
                          alignment: Alignment.center,
                          height: 25,
                          width: 90,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green,
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              NumberFormat("R\$ #0.00", "PT-BR")
                                  .format(valueProfit),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
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
      ),
    );
  }
}
