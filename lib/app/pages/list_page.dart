import 'package:app_good_taste/app/controllers/product_controller.dart';
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
  late dynamic dataSelected;
  bool dataWasSelected = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void selectData(int index) {
    for (var data in data) {
      data["data_selected"] = false;
    }
    setState(() {
      data[index]["data_selected"] = true;
      dataWasSelected = true;
      dataSelected = widget.labelText == "Produtos"
          ? {"name": data[index]["name"], "id": data[index]["id"]}
          : {
              "type": data[index]["type"],
              "id": data[index]["id"],
              "price": data[index]["price"]
            };
    });
  }

  void loadData() async {
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
    });
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
              onPressed: dataWasSelected
                  ? () {
                      Navigator.pop(context, dataSelected);
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
                // onChanged: searchForRawMaterial,
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        Container(
                          color: data[index]["data_selected"]
                              ? Theme.of(context).primaryColor
                              : const Color.fromARGB(255, 227, 226, 226),
                          child: ListTile(
                              onTap: () => selectData(index),
                              title: Text(
                                widget.labelText == "Produtos"
                                    ? data[index]["name"]
                                    : data[index]["type"],
                                style: TextStyle(
                                  color: data[index]["data_selected"]
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              leading: Icon(
                                data[index]["data_selected"]
                                    ? Icons.check
                                    : Icons.shopify_sharp,
                                size: 35,
                                color: data[index]["data_selected"]
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
