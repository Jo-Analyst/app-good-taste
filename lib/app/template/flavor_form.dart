import 'package:flutter/material.dart';
import '../utils/scroll_button_modal.dart';

class FlavorForm extends StatefulWidget {
  final String? type;
  final bool isEdition;
  const FlavorForm({required this.isEdition, this.type, super.key});

  @override
  State<FlavorForm> createState() => _FlavorFormState();
}

class _FlavorFormState extends State<FlavorForm> {
  final globalKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!widget.isEdition) return;

    textController.text = widget.type!;
  }

  void addFlavor() {
    if (globalKey.currentState!.validate()) {
      Navigator.pop(context, textController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  textCapitalization: TextCapitalization.sentences,
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
                      child: Row(
                        children: [
                          Icon(!widget.isEdition ? Icons.add : Icons.edit),
                          Text(!widget.isEdition ? "Adicionar" : "Atualizar"),
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
