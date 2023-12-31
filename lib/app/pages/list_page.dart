import 'package:app_good_taste/app/controllers/flavor_controller.dart';
import 'package:app_good_taste/app/controllers/product_controller.dart';
import 'package:app_good_taste/app/pages/product_form_page.dart';
import 'package:app_good_taste/app/template/flavor_form.dart';
import 'package:app_good_taste/app/utils/modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget {
  final int? productId;
  final String labelText;
  const ListPage({
    this.productId,
    required this.labelText,
    super.key,
  });

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> filteredData = [];
  late dynamic dataSelected;
  bool dataWasSelected = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void selectData(int index) {
    for (var data in filteredData) {
      data["data_selected"] = false;
    }
    setState(() {
      filteredData[index]["data_selected"] = true;
      dataWasSelected = true;
      dataSelected = widget.labelText == "Produtos"
          ? {
              "name": filteredData[index]["name"],
              "id": filteredData[index]["id"]
            }
          : {
              "type": filteredData[index]["type"],
              "id": filteredData[index]["id"],
              "price": filteredData[index]["price"]
            };
    });

    FocusScope.of(context).unfocus();
    Navigator.pop(context, dataSelected);
  }

  void loadData() async {
    data.clear();
    late dynamic dataProvider;
    final productController =
        Provider.of<ProductController>(context, listen: false);

    if (widget.labelText == "Produtos") {
      await productController.load();
      dataProvider = productController.items;
    } else {
      await productController
          .loadingProductsAndFlavorsBYProductId(widget.productId!);
      dataProvider = productController.items;
    }
    setState(() {
      for (var item in dataProvider) {
        data.add(widget.labelText == "Produtos"
            ? {
                "id": item["id"],
                "name": item["name"],
                "data_selected": false,
              }
            : {
                "type": item["flavor"],
                "id": item["id"],
                "price": item["price"],
                "data_selected": false,
              });
      }

      filteredData = List.from(data);
    });
  }

  void searchForData(String searchText) {
    String nameColumn = widget.labelText == "Produtos" ? "name" : "type";
    setState(() {
      if (searchText.isEmpty) {
        filteredData = List.from(data);
      } else {
        filteredData = data
            .where((item) => item[nameColumn]
                .toString()
                .trim()
                .toLowerCase()
                .contains(searchText.trim().toLowerCase()))
            .toList();
      }
    });
  }

  void showModalForm(String type, int? index) async {
    await showModal(
        context,
        FlavorForm(
          isEdition: type.isNotEmpty,
          type: type,
        ));
  }

  void addNewProductOrFlavor() async {
    final flavorController =
        Provider.of<FlavorController>(context, listen: false);
    late dynamic response;
    if (widget.labelText.toLowerCase() == "produtos") {
      response = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const ProductFormPage(product: {}),
        ),
      );
    } else {
      response = await showModal(
          context,
          const FlavorForm(
            isEdition: false,
          ));

      if (response.isNotEmpty) {
        flavorController
            .add({"type": response, "product_id": widget.productId});
      }
    }

    if (response != null) {
      loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de ${widget.labelText}"),
        toolbarHeight: 100,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () => addNewProductOrFlavor(),
              icon: const Icon(
                Icons.add,
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
            Icons.keyboard_arrow_left,
            size: 40,
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
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 0,
                  ),
                  labelText: widget.labelText,
                  labelStyle: const TextStyle(fontSize: 18),
                  suffixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                ),
                onChanged: searchForData,
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredData.length,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        Container(
                          color: const Color.fromARGB(255, 227, 226, 226),
                          child: ListTile(
                              onTap: () => selectData(index),
                              title: Text(
                                widget.labelText == "Produtos"
                                    ? filteredData[index]["name"]
                                    : filteredData[index]["type"],
                                style: TextStyle(
                                  color: filteredData[index]["data_selected"]
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              leading: Icon(
                                filteredData[index]["data_selected"]
                                    ? Icons.check
                                    : Icons.shopify_sharp,
                                size: 35,
                                color: filteredData[index]["data_selected"]
                                    ? Colors.white
                                    : Colors.black87,
                              )),
                        ),
                        const Divider()
                      ],
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
