import 'package:app_good_taste/app/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/dialog.dart';
import '../utils/message_dialog.dart';

class ProductList extends StatefulWidget {
  final Map<String, dynamic> productItem;
  final Function(bool) toggleCard;
  final Function(bool) confirmAction;
  const ProductList(
    this.productItem, {
    required this.toggleCard,
    required this.confirmAction,
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
      leading: IconButton(
        onPressed: () {
          toggleCard();
          widget.toggleCard(expanded);
        },
        icon: Icon(
          expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_left,
        ),
      ),
      title: Text(
        widget.productItem["name"],
        style: const TextStyle(fontSize: 18),
      ),
      subtitle: Text(
        NumberFormat("R\$ #0.00", "PT-BR").format(
          widget.productItem["price"],
        ),
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: PopupMenuButton(
        color: const Color.fromARGB(183, 13, 13, 13),
        icon: Icon(
          Icons.more_vert,
          color: Theme.of(context).primaryColor,
        ),
        iconSize: 30,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem(
            padding: EdgeInsets.zero,
            value: "edit",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: const Text("Editar"),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: "delete",
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: const Text(
                    "Excluir",
                  ),
                ),
              ],
            ),
          ),
        ],
        onSelected: (option) {
          if (option.toLowerCase() == "delete") {
            showExitDialog(context, ListMessageDialog.messageDialog[4])
                .then((message) async {
              if (message!) {
                final productProvider =
                    Provider.of<ProductController>(context, listen: false);
                await productProvider.delete(widget.productItem["id"]);
                widget.confirmAction(true);
              }
            });
          }
        },
      ),
    );
  }
}
