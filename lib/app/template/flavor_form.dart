import 'package:flutter/material.dart';

class FlavorForm extends StatelessWidget {
  const FlavorForm({super.key});

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<FormState>();
    return Form(
      key: _key,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Sabor ou tipo",
            ),
          ),
          ElevatedButton(onPressed: (){}, child: Text("oi"))
        ],
      ),
    );
  }
}
