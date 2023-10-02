import 'package:app_good_taste/app/pages/good_taste_page.dart';
import 'package:app_good_taste/app/pages/production_page.dart';
import 'package:app_good_taste/app/utils/dialog.dart';
import 'package:app_good_taste/app/utils/loading.dart';
import 'package:app_good_taste/app/utils/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/items_productions_controller.dart';
import '../controllers/production_controller.dart';

class ProductionDetailsPage extends StatefulWidget {
  final String date;
  final double valueEntry, valueLeave, valueProfit;
  const ProductionDetailsPage(
      {super.key,
      required this.valueEntry,
      required this.valueLeave,
      required this.valueProfit,
      required this.date});

  @override
  State<ProductionDetailsPage> createState() => _ProductionDetailsPageState();
}

class _ProductionDetailsPageState extends State<ProductionDetailsPage> {
  bool lineWasPressed = false, confirmedDeleteOrEdit = false, isLoading = true;
  int selectedLine = -1, productionId = 0;
  List<Map<String, dynamic>> productions = [];
  double valueEntry = 0, valueLeave = 0, valueProfit = 0;
  String date = DateFormat("dd/MM/yyyy", "pt-br").format(DateTime.now());

  List<Map<String, bool>> rowsPressed = [];
  List<Map<String, dynamic>> valuesProductions = [];
  List<Map<String, dynamic>> feedstocks = [];
  List<Map<String, dynamic>> listOfSelectedFeedstocks = [];

  @override
  initState() {
    super.initState();
    loadDetailsProductions(widget.date);
  }

  void sumValueEntry() {
    setState(() {
      valueEntry = 0;
      for (var production in productions) {
        valueEntry += production["value_entry"];
      }
    });
  }

  void selectedItemFlavor(int index) {
    setState(() {
      selectedLine = index;
      toggleRowsPressed(index);
      productionId = productions[index]["id"];
    });

    loadFeedstockEdition();
  }

  void updateSelectedItemFlavor(int index) {
    setState(() {
      productionId = productions[index]["id"];
    });

    loadFeedstockEdition();
  }

  void loadFeedstockEdition() async {
    final feedstockProvider =
        Provider.of<ItemsProductionsController>(context, listen: false);
    final feedstockItems =
        await feedstockProvider.loadItemsProductions(productionId);
    setState(() {
      listOfSelectedFeedstocks.clear();
      for (var item in feedstockItems) {
        listOfSelectedFeedstocks.add({
          "id": item["id"],
          "name": item["name"],
          "price": item["price"],
          "brand": item["brand"],
          "item_production_id": item["item_production_id"],
          "isChecked": false,
          "subtotal": item["subtotal"],
          "quantity": item["quantity"],
        });
      }
    });
  }

  void sumValueLeave() {
    setState(() {
      valueLeave = 0;
      for (var feedstock in feedstocks) {
        valueLeave += feedstock["price"];
      }
    });
  }

  void subtractValueEntryByValueLeave() {
    setState(() {
      valueProfit = valueEntry - valueLeave;
    });
  }

  void loadDetailsProductions(String date) {
    setState(() {
      this.date = date;
      getDetailsFlavors();
      getDetailsFeedstocks();
      isLoading = false;
    });
  }

  void getDetailsFlavors() async {
    final productionProvider =
        Provider.of<ProductionController>(context, listen: false);
    final productionsList = await productionProvider.getDetailsFlavors(date);
    setState(() {
      productions = productionsList;
      checkIfProductionsIsGreaterThanZeroAndFillInTheListRowsPressed();
      sumValueEntry();
    });
  }

  void getDetailsFeedstocks() async {
    final productionProvider =
        Provider.of<ProductionController>(context, listen: false);
    final feedstocksList = await productionProvider.getDetailsFeedstocks(date);
    setState(() {
      feedstocks = feedstocksList;
      sumValueLeave();
      subtractValueEntryByValueLeave();
    });
  }

  void getDetailsValuesProductions() async {
    final productionProvider =
        Provider.of<ProductionController>(context, listen: false);
    final values = await productionProvider.loadDate(date);
    setState(() {
      valuesProductions = values;
    });
  }

  void checkIfProductionsIsGreaterThanZeroAndFillInTheListRowsPressed() {
    if (productions.isNotEmpty) {
      for (int i = 0; i < productions.length; i++) {
        rowsPressed.add({"isPressed": false});
      }
    }
  }

// limpa o item selecionado
  void clearSelection() {
    for (var row in rowsPressed) {
      row["isPressed"] = false;
    }
  }

  void toggleRowsPressed(int index) {
    for (int i = 0; i < rowsPressed.length; i++) {
      if (i != index) {
        rowsPressed[i]["isPressed"] = false;
      }
    }
    rowsPressed[index]["isPressed"] = !rowsPressed[index]["isPressed"]!;
    lineWasPressed = rowsPressed[index]["isPressed"]! ? true : false;
  }

  void closeScreen() {
    Navigator.of(context).pop([confirmedDeleteOrEdit, date]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        closeScreen();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Produção",
          ),
          toolbarHeight: 100,
          leading: IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_left,
              size: 40,
            ),
            onPressed: () => closeScreen(),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 5),
              child: Row(
                children: [
                  IconButton(
                    onPressed: !lineWasPressed
                        ? null
                        : () async {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ProductionPage(
                                  production: productions[selectedLine],
                                  listFeedstock: listOfSelectedFeedstocks,
                                  isEdition: true,
                                ),
                              ),
                            );

                            if (result[0] == true) {
                              setState(() {
                                confirmedDeleteOrEdit = result[0];
                              });
                            }
                            if (result[1] != null) {
                              setState(() {
                                date = DateFormat("dd/MM/yyyy", "pt-br")
                                    .format(result[1]);
                              });
                            }

                            if (result != null) {
                              loadDetailsProductions(date);

                              updateSelectedItemFlavor(selectedLine);
                            }
                          },
                    icon: Icon(
                      lineWasPressed ? Icons.edit_outlined : Icons.edit,
                      size: 25,
                    ),
                  ),
                  IconButton(
                    onPressed: !lineWasPressed
                        ? null
                        : () async {
                            final confirmExit = await showExitDialog(context,
                                ListMessageDialog.messageDialog(null)[0]);

                            if (confirmExit!) {
                              setState(() {
                                final productionProvider =
                                    Provider.of<ProductionController>(context,
                                        listen: false);
                                productionProvider
                                    .remove(productions[selectedLine]["id"]);
                                lineWasPressed = false;
                                confirmedDeleteOrEdit = true;
                                clearSelection();
                              });

                              loadDetailsProductions(date);
                              showScaffoldMessage();
                            }
                          },
                    icon: const Icon(
                      Icons.delete,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: isLoading
            ? Center(
                child: loading(context, 50),
              )
            : Container(
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  child: Column(
                    children: [
                      Divider(
                        color: Colors.pink[500],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calendar_month_outlined),
                          Text(date),
                        ],
                      ),
                      Divider(
                        color: Colors.pink[500],
                      ),
                      const SizedBox(height: 10),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Sabores:"),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 2 - 210,
                        width: double.infinity,
                        child: Card(
                          elevation: 8,
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            child: productions.isEmpty
                                ? const Center(
                                    child: Text(
                                      "Sem dados a exibir...",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        Flexible(
                                          child: ListView.builder(
                                            itemCount: productions.length,
                                            itemBuilder: (context, index) {
                                              final rowColor = index ==
                                                          selectedLine &&
                                                      rowsPressed[index]
                                                          ["isPressed"]!
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : index % 2 > 0
                                                      ? Colors.white
                                                      : Colors.grey.shade200;

                                              return InkWell(
                                                onTap: () {
                                                  selectedItemFlavor(index);
                                                },
                                                child: Container(
                                                  color: rowColor,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10,
                                                    vertical: 15,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          productions[index]
                                                              ["flavor"],
                                                          style: TextStyle(
                                                            color: index ==
                                                                        selectedLine &&
                                                                    rowsPressed[
                                                                            index]
                                                                        [
                                                                        "isPressed"]!
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "${productions[index]["quantity"]}x",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: index ==
                                                                          selectedLine &&
                                                                      rowsPressed[
                                                                              index]
                                                                          [
                                                                          "isPressed"]!
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            NumberFormat(
                                                                    "R\$#0.00",
                                                                    "PT-BR")
                                                                .format(
                                                              productions[index]
                                                                      [
                                                                      "price"] ??
                                                                  0,
                                                            ),
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: index ==
                                                                          selectedLine &&
                                                                      rowsPressed[
                                                                              index]
                                                                          [
                                                                          "isPressed"]!
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            NumberFormat(
                                                                    "R\$#0.00",
                                                                    "PT-BR")
                                                                .format(
                                                              productions[index]
                                                                  [
                                                                  "value_entry"],
                                                            ),
                                                            style: TextStyle(
                                                              color: index ==
                                                                          selectedLine &&
                                                                      rowsPressed[
                                                                              index]
                                                                          [
                                                                          "isPressed"]!
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Gastos:"),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 2 - 210,
                        width: double.infinity,
                        child: Card(
                          elevation: 8,
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            child: feedstocks.isEmpty
                                ? const Center(
                                    child: Text(
                                      "Sem dados a exibir...",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        Flexible(
                                          child: ListView.builder(
                                            itemCount: feedstocks.length,
                                            itemBuilder: (context, index) {
                                              final rowColor = index % 2 > 0
                                                  ? Colors.white
                                                  : Colors.grey.shade200;
                                              return Container(
                                                color: rowColor,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 15),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Expanded(
                                                        child: Row(
                                                      children: [
                                                        Expanded(
                                                            child: Text(
                                                                "${feedstocks[index]["count_feedstock"]} ${feedstocks[index]["unit"]}  ${feedstocks[index]["name"]}")),
                                                      ],
                                                    )),
                                                    SizedBox(
                                                      width: 120,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            NumberFormat(
                                                                    "R\$ #0.00",
                                                                    "PT-BR")
                                                                .format(
                                                              feedstocks[index][
                                                                      "price"] ??
                                                                  0,
                                                            ),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        16),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
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
                                  child: Text(
                                    NumberFormat("R\$ #0.00", "PT-BR")
                                        .format(valueEntry),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
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
                                  child: Text(
                                    NumberFormat("R\$ #0.00", "PT-BR")
                                        .format(valueLeave),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
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
                                  child: Text(
                                    NumberFormat("R\$ #0.00", "PT-BR")
                                        .format(valueProfit),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GoodTastePage()),
                            (route) => false,
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.clear_all_sharp,
                              size: 25,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Fechar",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void showScaffoldMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Produção excluido com sucesso."),
        duration: Duration(milliseconds: 5000),
      ),
    );
  }
}
