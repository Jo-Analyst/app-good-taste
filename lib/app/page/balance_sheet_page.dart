import 'package:app_good_taste/app/page/raw_material_list.dart';
import 'package:app_good_taste/app/utils/drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BalanceteSheetPage extends StatefulWidget {
  const BalanceteSheetPage({super.key});

  @override
  State<BalanceteSheetPage> createState() => _BalanceteSheetPageState();
}

class _BalanceteSheetPageState extends State<BalanceteSheetPage> {
  final List<String> flavors = [
    "Morango",
    "Maracujá",
    "Uva",
    "Baunilha com limão"
  ];
  final List<Map<String, dynamic>> feedstocks = [
    {
      "name": "leite",
      "price": 4,
      "brand": "ML",
    },
    {
      "name": "Suco de Maracujá",
      "price": 1.35,
      "brand": "TANG",
    },
    {
      "name": "Açucar",
      "price": 18.75,
      "brand": "",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Produção do dia",
          style: TextStyle(fontSize: 30),
        ),
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
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 4),
                child: const Text(
                  "Entrada:",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      DropDownUtils(flavors, "Escolha o sabor"),
                      const Divider(),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textInputAction: TextInputAction.next,
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
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(left: 4),
                child: const Text(
                  "Saída:",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Expanded(
                child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        // DropDownUtils(feedstocks, "Matéria prima"),]
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Matéria prima",
                              style: TextStyle(fontSize: 18),
                            ),
                            IconButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RawMaterialList(),
                                ),
                              ),
                              icon: Icon(
                                Icons.add,
                                size: 30,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          width: double.infinity,
                          height: 2,
                          color: const Color.fromARGB(255, 228, 108, 148),
                        ),
                        feedstocks.isEmpty
                            ? const Flexible(
                                child: Center(
                                child: Text(
                                  "Não há matéria prima adicionada.",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ))
                            : Flexible(
                                child: ListView.builder(
                                  itemCount: feedstocks.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            "${feedstocks[index]['name']}",
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                          subtitle: Text(
                                            "${feedstocks[index]['brand']}",
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          leading: CircleAvatar(
                                            radius: 30,
                                            child: Text(
                                              NumberFormat("R\$ #0.00", "PT-BR")
                                                  .format(feedstocks[index]
                                                      ["price"]),
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          trailing: IconButton(
                                            onPressed: () {
                                              feedstocks.removeAt(index);
                                              setState(() {});
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        const Divider()
                                      ],
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
