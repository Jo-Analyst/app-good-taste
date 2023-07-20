import 'package:app_good_taste/app/controllers/product_controller.dart';
import 'package:app_good_taste/app/pages/product_form_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/flavor_controller.dart';
import '../utils/dialog.dart';
import '../utils/message_dialog.dart';
import '../utils/modal.dart';
import 'flavor_form.dart';

class ProductList extends StatefulWidget {
  final Map<String, dynamic> productItem;
  final List<Map<String, dynamic>>? flavors;
  final Function(bool) toggleCard;
  final Function(bool) confirmAction;
  const ProductList(
    this.productItem, {
    required this.toggleCard,
    required this.confirmAction,
    this.flavors,
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
  void initState() {
    super.initState();
  }

  void save(Map<String, dynamic> data) async {
    final flavorProvider =
        Provider.of<FlavorController>(context, listen: false);

    await flavorProvider.add(data);
    widget.confirmAction(true);
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
            value: "new",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: const Text("Novo"),
                ),
              ],
            ),
          ),
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
        onSelected: (option) async {
          if (option.toLowerCase() == "delete") {
            showExitDialog(context, ListMessageDialog.messageDialog("")[1])
                .then((message) async {
              if (message!) {
                final productProvider =
                    Provider.of<ProductController>(context, listen: false);
                await productProvider.delete(widget.productItem["id"]);
                widget.confirmAction(true);
              }
            });
          } else if (option.toLowerCase() == "edit") {
            final confirmUpdate = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProductFormPage(
                  product: widget.productItem,
                  flavors: widget.flavors,
                ),
              ),
            );

            if (confirmUpdate == true) {
              widget.confirmAction(true);
            }
          } else if (option == "new") {
            final type = await showModal(
              context,
              const FlavorForm(),
            );

            if (type.isEmpty) return;
            save({"type": type, "product_id": widget.productItem["id"]});
          }
        },
      ),
    );
  }
}
