import 'package:app_good_taste/app/controllers/feedstock_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FeedstockForm extends StatefulWidget {
  final Map<String, dynamic> feedstockItem;
  const FeedstockForm({required this.feedstockItem, super.key});

  @override
  State<FeedstockForm> createState() => _FeedstockState();
}

class _FeedstockState extends State<FeedstockForm> {
  final _key = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _brand = TextEditingController();
  final _unit = TextEditingController();
  int _id = 0;

  @override
  void initState() {
    super.initState();
    if (widget.feedstockItem.isEmpty) return;

    _id = widget.feedstockItem["id"];
    _name.text = widget.feedstockItem["name"];
    _brand.text = widget.feedstockItem["brand"];
    _unit.text = widget.feedstockItem["unit"].toString();
    _price.text =
        NumberFormat("#0.00", "PT-BR").format(widget.feedstockItem["price"]);
  }

  void save() async {
    final feedstockProvider =
        Provider.of<FeedstockController>(context, listen: false);
    if (_key.currentState!.validate()) {
      final data = {
        "id": _id,
        "name": _name.text.trim(),
        "brand": _brand.text.trim(),
        "unit": _unit.text.trim().toUpperCase(),
        "price": double.parse(_price.text.replaceAll(RegExp(r','), '.')),
      };

      data["id"] = await feedstockProvider.save(data);
      confirmSave(data);
    }
  }

  confirmSave(Map<String, Object> data) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Matéria prima salvo com sucesso."),
        duration: Duration(milliseconds: 3000),
      ),
    );
    Navigator.pop(context, data);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Form(
            key: _key,
            child: Column(
              children: [
                TextFormField(
                  controller: _name,
                  textCapitalization: TextCapitalization.sentences,
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
                  textCapitalization: TextCapitalization.sentences,
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
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
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
                    } else if (double.parse(
                            price.replaceAll(RegExp(r','), '.')) <=
                        0) {
                      return "Este não um valor válido";
                    }

                    return null;
                  },
                  onFieldSubmitted: (_) => save(),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  controller: _unit,
                  decoration: InputDecoration(
                    labelText: "Unidade/Embalagem",
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
                  validator: (unidade) {
                    if (unidade!.isEmpty) {
                      return "Informe a Unidade/Embalagem!";
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
