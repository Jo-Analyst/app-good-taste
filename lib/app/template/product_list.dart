import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/dialog.dart';

class ProductList extends StatelessWidget {
  final Map<String, dynamic> productItem;
  const ProductList(this.productItem, {super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> messageDialog = {
      "title": "Deseja excluir?",
      "content": "Você realmente tem certeza que deseja excluir?",
      "action": "Excluir",
    };

    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            NumberFormat("R\$ #0.00", "PT-BR").format(
              productItem["price"],
            ),
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
      title: Text(
        productItem["type"],
        style: const TextStyle(fontSize: 18),
      ),
      subtitle: Text(
        productItem["name"],
        style: const TextStyle(fontSize: 14),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.edit_sharp,
                color: Colors.blue,
              ),
            ),
            IconButton(
              onPressed: () => showExitDialog(context, messageDialog).then(
                (message) {
                  if (message!) {
                    print("produto excluido");
                  }
                },
              ),
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
