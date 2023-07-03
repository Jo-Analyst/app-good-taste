import 'package:flutter/material.dart';
import 'package:app_good_taste/app/partils/modal.dart';
import 'package:intl/intl.dart';

class FeedstockList extends StatelessWidget {
  final Map<String, dynamic> feedstockItem;
  const FeedstockList(this.feedstockItem, {super.key});

  @override
  Widget build(BuildContext context) {
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
              onPressed: () => Modal.showModal(context, feedstockItem),
              icon: const Icon(
                Icons.edit_sharp,
                color: Colors.blue,
              ),
            ),
            IconButton(
              onPressed: () {},
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
