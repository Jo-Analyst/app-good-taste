import 'package:app_good_taste/app/utils/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/dialog.dart';

class ProductList extends StatefulWidget {
  final Map<String, dynamic> productItem;
  final Function(bool) toggleCard;
  const ProductList(
    this.productItem, {
    required this.toggleCard,
    super.key,
  });

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  bool expanded = false;

  void toggleCard() {
    setState(() {
      expanded = !expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        child: Row(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    toggleCard();
                    widget.toggleCard(expanded);
                  },
                  icon: Icon(
                    expanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                  ),
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      NumberFormat("R\$ #0.00", "PT-BR").format(
                        widget.productItem["price"],
                      ),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.productItem["name"],
                style: const TextStyle(fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),

      // subtitle: Text(
      //   productItem["name"],
      //   style: const TextStyle(fontSize: 14),
      // ),
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
              onPressed: () =>
                  showExitDialog(context, ListMessageDialog.messageDialog[1])
                      .then(
                (message) {
                  if (message!) {}
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
