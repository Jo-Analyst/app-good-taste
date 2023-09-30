import 'package:app_good_taste/app/template/dialog_feedstock.dart';
import 'package:app_good_taste/app/template/feedstock_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeedstockListPage extends StatefulWidget {
  final List<Map<String, dynamic>> listOfSelectedFeedstocks;
  final List<Map<String, dynamic>> feedstocks;

  final bool isEdition;
  const FeedstockListPage(
    this.listOfSelectedFeedstocks,
    this.feedstocks,
    this.isEdition, {
    super.key,
  });

  @override
  State<FeedstockListPage> createState() => _FeedstockListPageState();
}

class _FeedstockListPageState extends State<FeedstockListPage> {
  List<Map<String, dynamic>> filteredFeedstocks = [];
  List<Map<String, dynamic>> valuesOfSelectedFeedstock = [];
  final List<Map<String, dynamic>> removeItemsFlavors = [];
  List<Map<String, dynamic>> listItemsChecked = [];
  final List<bool> valuesDefault = [];

  @override
  void initState() {
    super.initState();
    changeIsCheckedAttribute();
    filteredFeedstocks = List.from(widget.feedstocks);
  }

  void increment() {}

  // void loadFeedstock() async {
  //   widget.feedstocks.clear();
  //   final feedstockProvider =
  //       Provider.of<FeedstockController>(context, listen: false);
  //   await feedstockProvider.loadFeedstock();
  //   setState(() {
  //     for (var item in feedstockProvider.items) {
  //       widget.feedstocks.add({
  //         "id": item["id"],
  //         "name": item["name"],
  //         "price": item["price"],
  //         "brand": item["brand"],
  //         "isChecked": false,
  //       });
  //     }
  //   });

  //   filteredFeedstocks = List.from(widget.feedstocks);
  // }

  void changeIsCheckedAttribute() {
    if (widget.listOfSelectedFeedstocks.isEmpty) return;

    for (var feedstock in widget.feedstocks) {
      for (var list in widget.listOfSelectedFeedstocks) {
        if (list["id"] == feedstock["id"]) {
          setState(() {
            haveSelectedFeedstock = true;
            feedstock["isChecked"] = true;
            valuesOfSelectedFeedstock.add(feedstock);
          });
        }
      }
    }
    setState(() {});
  }

  void addValuesSelectedFeedstock(
      Map<String, dynamic> listFeedstock, bool isChecked) {
    setState(() {
      if (isChecked) {
        listFeedstock["quantity"] = 1;
        listFeedstock["subtotal"] = listFeedstock["price"];
        valuesOfSelectedFeedstock.add(listFeedstock);
      } else {
        valuesOfSelectedFeedstock
            .removeWhere((feedstock) => feedstock["id"] == listFeedstock["id"]);
      }
    });
  }

  void addItemInListemoveItemsFlavors(
      Map<String, dynamic> listFeedstock, bool isChecked) async {
    if (widget.isEdition) {
      if (isChecked) {
        removeItemsFlavors
            .removeWhere((feedstock) => feedstock["id"] == listFeedstock["id"]);
      } else {
        final int itemProductionid = getItemProductionId(listFeedstock["id"]);
        if (itemProductionid > 0) {
          listFeedstock["item_production_id"] = itemProductionid;
          removeItemsFlavors.add(listFeedstock);
        }
      }
    }
  }

  void changeListItemsChecked(Map<String, dynamic> item, bool checked) {
    bool found = false;
    for (var list in listItemsChecked) {
      if (list["id"] == item["id"]) {
        found = true;
        break;
      }
    }

    if (!found) {
      listItemsChecked.add(item);
      valuesDefault.add(checked);
    }
  }

  void changeListFeedstockInWaiver() {
    for (var feedstock in widget.feedstocks) {
      int index = 0;
      for (var listItem in listItemsChecked) {
        if (listItem["id"] == feedstock["id"]) {
          feedstock["isChecked"] = valuesDefault[index];
        }
        index++;
      }
    }
  }

  int getItemProductionId(int itemProdutionId) {
    int foundId = 0;
    for (var list in widget.listOfSelectedFeedstocks) {
      if (list["id"] == itemProdutionId) {
        foundId = list["item_production_id"];
        break;
      }
    }
    return foundId;
  }

  void searchForFeedstock(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        filteredFeedstocks = List.from(widget.feedstocks);
      } else {
        filteredFeedstocks = widget.feedstocks
            .where((item) => item['name']
                .toString()
                .trim()
                .toLowerCase()
                .contains(searchText.trim().toLowerCase()))
            .toList();
      }
    });
  }

  bool haveSelectedFeedstock = false;

  void checkIfThereIsFeedstockSelected() {
    List<Map<String, dynamic>> filteredFeedstocks =
        widget.feedstocks.where((feedstock) {
      return feedstock["isChecked"] == true;
    }).toList();

    setState(() {
      haveSelectedFeedstock = filteredFeedstocks.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              final confirm = await showExitDialogFeedstock(
                context,
                const FeedstockForm(
                  feedstockItem: {},
                ),
              );

              if (confirm != null) {
                changeIsCheckedAttribute();
                // loadFeedstock();
              }
            },
            icon: const Icon(
              Icons.add,
              size: 35,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: !haveSelectedFeedstock
                  ? null
                  : () => Navigator.pop(
                      context, [valuesOfSelectedFeedstock, removeItemsFlavors]),
              icon: const Icon(
                Icons.check,
                size: 35,
              ),
            ),
          ),
        ],
        title: const Text(
          "Matéria Prima",
        ),
        toolbarHeight: 100,
        leading: IconButton(
          onPressed: () {
            changeListFeedstockInWaiver();
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.close,
            size: 35,
          ),
        ),
      ),
      body: Card(
        margin: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 0,
                  ),
                  labelText: "Matéria Prima",
                  labelStyle: TextStyle(fontSize: 18),
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: searchForFeedstock,
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredFeedstocks.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          filteredFeedstocks[index]["isChecked"] =
                              !(filteredFeedstocks[index]["isChecked"] ??
                                  false);
                          checkIfThereIsFeedstockSelected();
                          addValuesSelectedFeedstock(filteredFeedstocks[index],
                              filteredFeedstocks[index]["isChecked"] ?? false);
                        });
                      },
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(filteredFeedstocks[index]["name"]),
                            subtitle: Text(filteredFeedstocks[index]["brand"]),
                            leading: CircleAvatar(
                              maxRadius: 30,
                              child: Text(
                                NumberFormat("R\$ #0.00", "Pt-BR")
                                    .format(filteredFeedstocks[index]["price"]),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            trailing: Transform.scale(
                              scale: 1.5,
                              child: Checkbox(
                                value: filteredFeedstocks[index]["isChecked"] ??
                                    false,
                                onChanged: (bool? checked) {
                                  setState(() {
                                    filteredFeedstocks[index]["isChecked"] =
                                        checked!;
                                    checkIfThereIsFeedstockSelected();
                                    addValuesSelectedFeedstock(
                                        filteredFeedstocks[index], checked);
                                    addItemInListemoveItemsFlavors(
                                        filteredFeedstocks[index], checked);
                                    changeListItemsChecked(
                                        filteredFeedstocks[index], !checked);
                                  });
                                },
                              ),
                            ),
                          ),
                          const Divider()
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
