import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeedstockListPage extends StatefulWidget {
  final List<Map<String, dynamic>> listOfSelectedFeedstocks;
  final List<Map<String, dynamic>> feedstocks;
  final bool isEdition;
  final List<Map<String, dynamic>> removeItemsFlavors;
  const FeedstockListPage(this.listOfSelectedFeedstocks, this.feedstocks,
      this.isEdition, this.removeItemsFlavors,
      {super.key});

  @override
  State<FeedstockListPage> createState() => _FeedstockListPageState();
}

class _FeedstockListPageState extends State<FeedstockListPage> {
  List<Map<String, dynamic>> filteredFeedstocks = [];
  List<Map<String, dynamic>> valuesOfSelectedFeedstock = [];

  @override
  void initState() {
    super.initState();
    changeIsCheckedAttribute();
    filteredFeedstocks = List.from(widget.feedstocks);
  }

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
  }

  void addValuesSelectedFeedstock(
      Map<String, dynamic> listFeedstock, bool isChecked) {
    setState(() {
      if (isChecked) {
        valuesOfSelectedFeedstock.add(listFeedstock);
      } else {
        valuesOfSelectedFeedstock
            .removeWhere((feedstock) => feedstock["id"] == listFeedstock["id"]);
      }
    });
  }

  void addItemInListemoveItemsFlavors(
      Map<String, dynamic> listFeedstock, bool isChecked) {
    print(filteredFeedstocks);
    if (widget.isEdition) {
      if (isChecked) {
        widget.removeItemsFlavors
            .removeWhere((feedstock) => feedstock["id"] == listFeedstock["id"]);
      } else {
        widget.removeItemsFlavors.add(listFeedstock);
      }
    }
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
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: !haveSelectedFeedstock
                  ? null
                  : () => Navigator.pop(context, valuesOfSelectedFeedstock),
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
                                    addItemInListemoveItemsFlavors(filteredFeedstocks[index], checked);
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
