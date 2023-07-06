import 'package:flutter/material.dart';

import '../utils/scroll_button_modal.dart';

class FlavorForm extends StatelessWidget {
  const FlavorForm({super.key});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
           const ScrollButtomModal(),
          Form(
            key: key,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Sabor ou tipo",
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Row(
                        children: [
                          Icon(Icons.add),
                          Text("Adicionar"),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
