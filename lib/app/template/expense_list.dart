import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseList extends StatelessWidget {
  final Map<String, dynamic> expenseItem;
  const ExpenseList(this.expenseItem, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Chip(
        padding: const EdgeInsets.all(5),
        label: Text(
          expenseItem["brand"],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      title: Text(expenseItem["name"]),
      subtitle:
          Text(NumberFormat("R\$ #0.00", "PT-BR").format(expenseItem["price"])),
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
