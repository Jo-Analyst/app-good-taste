import 'package:app_good_taste/app/controller/flavor_controller.dart';
import 'package:app_good_taste/app/template/flavor_form.dart';
import 'package:app_good_taste/app/utils/modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/dialog.dart';
import '../utils/message_dialog.dart';

class FlavorList extends StatefulWidget {
  final List<Map<String, dynamic>> flavors;
  final Map<String, dynamic> product;
  final bool isExpanded;
  final Function(bool) confirmAction;

  const FlavorList(
      {required this.flavors,
      required this.isExpanded,
      required this.product,
      required this.confirmAction,
      super.key});

  @override
  State<FlavorList> createState() => _FlavorListState();
}

class _FlavorListState extends State<FlavorList> {
  @override
  void initState() {
    super.initState();
  }

  void save(Map<String, dynamic> data) async {
    final flavorProvider =
        Provider.of<FlavorController>(context, listen: false);
    await flavorProvider.update(data);
    widget.confirmAction(true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(179, 246, 245, 245),
      child: Column(
        children: widget.flavors
            .where((e) => e["product_id"] == widget.product["id"])
            .map((flavor) {
          return Visibility(
            visible: widget.isExpanded,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.shopify_rounded,
                    size: 40,
                    color: Colors.black,
                  ),
                  title: Text(
                    flavor['type'].toString(),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  trailing: PopupMenuButton(
                    color: const Color.fromARGB(192, 233, 30, 98),
                    icon: const Icon(
                      Icons.more_vert,
                      color: Color.fromARGB(183, 13, 13, 13),
                    ),
                    iconSize: 30,
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
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
                      if (option == "delete") {
                        showExitDialog(
                                context, ListMessageDialog.messageDialog[1])
                            .then((message) async {
                          if (message!) {
                            final flavorProvider =
                                Provider.of<FlavorController>(context,
                                    listen: false);
                            await flavorProvider.delete(flavor["id"]);
                            widget.confirmAction(true);
                          }
                        });
                      } else if (option == "edit") {
                        final type = await showModal(
                          context,
                          FlavorForm(
                            type: flavor["type"],
                          ),
                        );

                        final data = {"id": flavor["id"], "type": type, "product_id": flavor["product_id"]};
                        save(data);
                      }
                    },
                  ),
                ),
                const Divider()
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
