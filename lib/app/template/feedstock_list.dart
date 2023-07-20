import 'package:app_good_taste/app/controllers/feedstock_controller.dart';
import 'package:app_good_taste/app/utils/dialog.dart';
import 'package:app_good_taste/app/template/feedstock_form.dart';
import 'package:app_good_taste/app/utils/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:app_good_taste/app/utils/modal.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FeedstockList extends StatelessWidget {
  final Map<String, dynamic> feedstockItem;
  final Function(bool) onConfirmAction;
  const FeedstockList(
    this.feedstockItem, {
    required this.onConfirmAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final feedstockProvider =
        Provider.of<FeedstockController>(context, listen: false);
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            NumberFormat("R\$ #0.00", "PT-BR").format(
              feedstockItem["price"],
            ),
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
      title: Text(
        feedstockItem["name"],
        style: const TextStyle(fontSize: 18),
      ),
      subtitle: feedstockItem["brand"].toString().trim() == ""
          ? const Text("Sem marca registrada")
          : Text(
              feedstockItem["brand"],
              style: const TextStyle(fontSize: 14),
            ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () => showModal(
                context,
                Feedstock(feedstockItem: feedstockItem),
              ),
              icon: const Icon(
                Icons.edit_sharp,
                color: Color.fromARGB(255, 22, 104, 171),
              ),
            ),
            IconButton(
              onPressed: () {
                showExitDialog(context, ListMessageDialog.messageDialog("")[0])
                    .then((confirmeExit) {
                  if (confirmeExit!) {
                    feedstockProvider.delete(feedstockItem["id"]);
                    onConfirmAction(true);
                  }
                });
              },
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
