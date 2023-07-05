import 'package:flutter/material.dart';

class FlavorForm extends StatelessWidget {
  const FlavorForm({super.key});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColor,
            ),
          ),
          Form(
            key: key,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Sabor ou tipo",
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Row(
                        children: [
                          Icon(Icons.add),
                          Text("Adicionar"),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
