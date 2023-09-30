import 'package:flutter/material.dart';

Future<String?> showDialogApp(BuildContext context, String content) async {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          "Sair",
        ),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text(
              'Cancelar',
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              'Não',
            ),
            onPressed: () {
              Navigator.of(context).pop("Sair");
            },
          ),
          ElevatedButton(
            child: const Text(
              "Sim",
            ),
            onPressed: () {
              Navigator.of(context).pop("Sair e gerar backup");
            },
          ),
        ],
      );
    },
  );
}
