import 'package:app_good_taste/app/utils/drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BalanceteSheetPage extends StatefulWidget {
  const BalanceteSheetPage({super.key});

  @override
  State<BalanceteSheetPage> createState() => _BalanceteSheetPageState();
}

class _BalanceteSheetPageState extends State<BalanceteSheetPage> {
  @override
  Widget build(BuildContext context) {
    final List<String> flavors = [
      "Morango",
      "Maracujá",
      "Uva",
      "Baunilha com limão"
    ];
    final List<String> feedstocks = [
      "Leite",
      "Suco de morango",
    ];

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
                              "Adicione a matéria prima",
                              style: TextStyle(fontSize: 18),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.add,
                                size: 30,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          width: double.infinity,
                          height: 2,
                          color: const Color.fromARGB(255, 228, 108, 148),
                        )
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
