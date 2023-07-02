import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Feedstock extends StatefulWidget {
  final Map<String, dynamic> feedstockItem;
  const Feedstock({required this.feedstockItem, super.key});

  @override
  State<Feedstock> createState() => _FeedstockState();
}

class _FeedstockState extends State<Feedstock> {
  final _key = GlobalKey<FormState>();
  final _product = TextEditingController();
  final _price = TextEditingController();
  final _brand = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.feedstockItem.isEmpty) return;

    _product.text = widget.feedstockItem["name"];
    _brand.text = widget.feedstockItem["brand"];
    _price.text =
        NumberFormat("#0.00", "PT-BR").format(widget.feedstockItem["price"]);
  }

  void save() {
    if (_key.currentState!.validate()) {
      // método para salvar
      // print(_product.text);
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
            key: _key,
            child: Column(
              children: [
                TextFormField(
                  controller: _product,
                  decoration: InputDecoration(
                    labelText: "Produto",
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
                    if (name!.isEmpty) return "Informe o produto!";
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
                      children: [
                        Icon(Icons.check),
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
        ],
      ),
    );
  }
}
