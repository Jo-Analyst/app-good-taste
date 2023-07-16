import 'package:flutter/material.dart';

import '../utils/scroll_button_modal.dart';

Future<String?> showModalFlavorForm(BuildContext context) async {
  final result = await showModalBottomSheet<String>(
    context: context,
    builder: (_) {
      final key = GlobalKey<FormState>();
      final textController = TextEditingController();
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
                    controller: textController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: "Sabor ou tipo",
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, textController.text),
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
    },
  );

  return result ?? ''; // Retorna uma string vazia se o resultado for nulo
}
