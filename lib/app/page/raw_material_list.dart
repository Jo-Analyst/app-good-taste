import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RawMaterialList extends StatefulWidget {
  const RawMaterialList({super.key});

  @override
  State<RawMaterialList> createState() => _RawMaterialListState();
}

class _RawMaterialListState extends State<RawMaterialList> {
  final List<Map<String, dynamic>> feedstocks = [
    {
      "id": 0,
      "name": "Açucar",
      "price": 19.50,
      "brand": "",
      "isChecked": false,
    },
    {
      "id": 1,
      "name": "Leite",
      "price": 4,
      "brand": "JV",
      "isChecked": false,
    },
    {
      "id": 2,
      "name": "Leite",
      "price": 4,
      "brand": "JVC",
      "isChecked": false,
    },
    {
      "id": 3,
      "name": "Leite",
      "price": 3.50,
      "brand": "ML",
      "isChecked": false,
    },
    {
      "id": 4,
      "name": "Suco de morango",
      "price": 1.35,
      "brand": "TANG",
      "isChecked": false,
    },
    {
      "id": 5,
      "name": "Suco de maracujá",
      "price": 1.35,
      "brand": "TANG",
      "isChecked": false,
    },
    {
      "id": 6,
      "name": "Suco de baunilha com limão",
      "price": 0.95,
      "brand": "MID",
      "isChecked": false,
    },
    {
      "id": 7,
      "name": "Suco de Abacaxi",
      "price": 1.00,
      "brand": "Torange",
      "isChecked": false,
    },
    {
      "id": 8,
      "name": "Suco de Uva",
      "price": 1.35,
      "brand": "TANG",
      "isChecked": false,
    },
    {
      "id": 9,
      "name": "Suco de Iorgute de Morango",
      "price": .95,
      "brand": "MID",
      "isChecked": false,
    },
    {
      "id": 10,
      "name": "Suco de Iorgute de Maracujá",
      "price": .95,
      "brand": "MID",
      "isChecked": false,
    },
  ];

  List<Map<String, dynamic>> filteredFeedstocks = [];

  @override
  void initState() {
    super.initState();
    filteredFeedstocks = List.from(feedstocks);
  }

  void searchForRawMaterial(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        filteredFeedstocks = List.from(feedstocks);
      } else {
        filteredFeedstocks = feedstocks
            .where((item) =>
                item['name'].toString().trim().toLowerCase().contains(searchText.trim().toLowerCase()))
            .toList();
      }
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
              onPressed: () {},
              icon: const Icon(
                Icons.check,
                size: 35,
              ),
            ),
          ),
        ],
        title: const Text(
          "Matéria Prima",
          style: TextStyle(fontSize: 25),
        ),
        toolbarHeight: 100,
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
                onChanged: searchForRawMaterial,
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredFeedstocks.length,
                  itemBuilder: (ctx, index) {
                    return Column(
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
                                });
                              },
                            ),
                          ),
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
