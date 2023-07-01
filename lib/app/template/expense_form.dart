import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({super.key});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _key = GlobalKey<FormState>();

  final _name = TextEditingController();

  final _price = TextEditingController();

  final _brand = TextEditingController();

  void save() {
    if (_key.currentState!.validate()) {
      // método para salvar
      // print(_name.text);
      // print(_price.text);
      // print(_brand.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 10,
      ),
      child: Form(
        key: _key,
        child: Column(
          children: [
            TextFormField(
              controller: _name,
              decoration: InputDecoration(
                labelText: "Nome",
                floatingLabelStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
              ),
              validator: (name) {
                if (name!.isEmpty) return "Informe o nome do produto!";
                return null;
              },
              onFieldSubmitted: (_) => save(),
            ),
            TextFormField(
              controller: _brand,
              decoration: InputDecoration(
                labelText: "Marca",
                floatingLabelStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
              ),
              onFieldSubmitted: (_) => save(),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: _price,
              decoration: InputDecoration(
                labelText: "Preço",
                hoverColor: Colors.black87,
                floatingLabelStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              validator: (price) {
                if (price!.isEmpty) {
                  return "Informe o preço do produto!";
                } else if (double.parse(price) <= 0) {
                  return "Este não um valor válido";
                }

                return null;
              },
              onFieldSubmitted: (_) => save(),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.all(10)),
                onPressed: save,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Icons.save_alt),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Salvar")
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
