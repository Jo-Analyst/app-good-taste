import 'package:app_good_taste/app/utils/drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/scroll_button_modal.dart';

class BalanceteSheetPage extends StatelessWidget {
  const BalanceteSheetPage({super.key});

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

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            left: 30,
            right: 30,
            top: 10,
            bottom: 10 + MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.center,
              child: ScrollButtomModal(),
            ),
            const Text(
              "Entrada:",
              style: TextStyle(fontSize: 18),
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
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: "Quantidade",
                        labelStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Saída:",
              style: TextStyle(fontSize: 18),
            ),
            Card(
              elevation: 10,
              child: Column(
                children: [
                  DropDownUtils(feedstocks, "Matéria prima"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
