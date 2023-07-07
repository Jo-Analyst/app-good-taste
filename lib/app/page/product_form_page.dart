import 'package:app_good_taste/app/utils/message_dialog.dart';
import 'package:app_good_taste/app/utils/modal.dart';
import 'package:app_good_taste/app/utils/dialog.dart';
import 'package:app_good_taste/app/template/flavor_form.dart';
import 'package:flutter/material.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _key = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  List<String> flavors = [
    "Morango",
    "Abacaxi",
    "Maracujá",
    "Uva",
    "Baunilha com limão",
    "Iorgute de morango",
    "Iorgute de maracujá",
    "Chocolate",
    "Açai"
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final confirmExit =
            await showExitDialog(context, ListMessageDialog.messageDialog[0]);
        return confirmExit ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Meu Produto",
            style: TextStyle(fontSize: 25),
          ),
          leading: IconButton(
            onPressed: () {
              if (flavors.isNotEmpty ||
                  _nameController.text.isNotEmpty ||
                  _priceController.text.isNotEmpty) {
                showExitDialog(context, ListMessageDialog.messageDialog[0])
                    .then(
                  (confirmExit) {
                    if (confirmExit!) {
                      Navigator.of(context).pop();
                    }
                  },
                );
              } else {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(
              Icons.close,
              size: 35,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {
                  if (_key.currentState!.validate() && flavors.isEmpty) {
                    showExitDialog(context, ListMessageDialog.messageDialog[2])
                        .then(
                      (confirmExit) {
                        // if (confirmExit!) {
                        //   Navigator.of(context).pop();
                        // }
                      },
                    );
                  }

                  if (_key.currentState!.validate() && flavors.isNotEmpty) {
                    // salva os dados e fecha a tela
                    Navigator.of(context).pop();
                  }
                },
                icon: const Icon(
                  Icons.check_outlined,
                  size: 35,
                ),
              ),
            )
          ],
          toolbarHeight: 100,
        ),
        body: Container(
          height: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 15,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: _key,
                      child: Column(
                        children: [
                          Column(
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration:
                                    const InputDecoration(labelText: "Nome"),
                                textInputAction: TextInputAction.next,
                                validator: (name) {
                                  if (name!.isEmpty) {
                                    return "Informe o nome do produto!";
                                  }

                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _priceController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                textInputAction: TextInputAction.next,
                                decoration:
                                    const InputDecoration(labelText: "Preço"),
                                validator: (price) {
                                  if (price!.isEmpty) {
                                    return "Informe o preço do produto!";
                                  }

                                  return null;
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Sabores ou tipos: ",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 25,
                                fontWeight: FontWeight.w700),
                          ),
                          IconButton(
                            onPressed: () {
                              showModal(
                                context,
                                const FlavorForm(),
                              );
                            },
                            icon: Icon(
                              Icons.add_circle_outline,
                              color: Theme.of(context).primaryColor,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: double.infinity,
                      height: 1,
                      color: const Color.fromARGB(255, 238, 173, 195),
                    ),
                    flavors.isEmpty
                        ? Container(
                            margin: const EdgeInsets.only(top: 150),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    "Não há sabores adicionados",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: flavors.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(flavors[index]),
                                    trailing: SizedBox(
                                      width: 100,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () => showExitDialog(
                                              context,
                                              ListMessageDialog
                                                  .messageDialog[1],
                                            ).then((message) {
                                              if (message!) {
                                                flavors.removeAt(index);
                                                setState(
                                                  () {},
                                                );
                                              }
                                            }),
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                ],
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// Widget build(BuildContext context) {
    // return WillPopScope(
    //   onWillPop: () async {
    //     bool confirmExit = await showDialog(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return AlertDialog(
    //           title: const Text('Deseja sair?'),
    //           content: const Text(
    //               'Você tem certeza que deseja sair sem confirmar a transação?'),
    //           actions: [
    //             TextButton(
    //               child: const Text('Cancelar'),
    //               onPressed: () {
    //                 Navigator.of(context).pop(false);
    //               },
    //             ),
    //             TextButton(
    //               child: const Text('Sair'),
    //               onPressed: () {
    //                 Navigator.of(context).pop(true);
    //               },
    //             ),
    //           ],
    //         );
    //       },
    //     );

    //     return confirmExit;
    //   },
// }