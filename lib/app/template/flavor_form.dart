import 'package:flutter/material.dart';
import '../utils/scroll_button_modal.dart';

class FlavorForm extends StatelessWidget {
  const FlavorForm({super.key});

  @override
  Widget build(BuildContext context) {
    final globalKey = GlobalKey<FormState>();
    final textController = TextEditingController();

    void addFlavor() {
      if (globalKey.currentState!.validate()) {
        Navigator.pop(context, textController.text);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          const ScrollButtomModal(),
          Form(
            key: globalKey,
            child: Column(
              children: [
                TextFormField(
                  controller: textController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: "Sabor ou tipo",
                  ),
                  validator: (flavorOrType) {
                    if (flavorOrType!.isEmpty) return "Digite o sabor!";

                    return null;
                  },
                  onFieldSubmitted: (_) => addFlavor(),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => addFlavor(),
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
