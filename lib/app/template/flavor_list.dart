import 'package:flutter/material.dart';

class FlavorList extends StatefulWidget {
  final List<Map<String, dynamic>> flavors;
  final Map<String, dynamic> product;
  final bool isExpanded;

  const FlavorList(
      {required this.flavors,
      required this.isExpanded,
      required this.product,
      super.key});

  @override
  State<FlavorList> createState() => _FlavorListState();
}

class _FlavorListState extends State<FlavorList> {
  @override
  void initState() {
    super.initState();
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
                  leading:  Icon(Icons.shopify_rounded, size: 40, color: Theme.of(context).primaryColor,),
                  title: Text(
                    flavor['type'].toString(),
                    style: const TextStyle(
                      fontSize: 18,
                    ),
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
