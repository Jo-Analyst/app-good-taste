import 'package:app_good_taste/app/page/all_productions_page.dart';
import 'package:app_good_taste/app/page/production_page.dart';
import 'package:flutter/material.dart';
import 'package:app_good_taste/app/template/movement_details_template.dart';

import '../template/slide_month.dart';

class MovementDetailsPage extends StatelessWidget {
  const MovementDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        width: 50,
        height: 50,
        child: FloatingActionButton(
          heroTag: null,
          mini: true,
          onPressed: () {},
          child: const Icon(
            Icons.picture_as_pdf_outlined,
            size: 30,
          ),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 28),
                const SlideMonth(),
                const Padding(
                  padding:  EdgeInsets.all(10.0),
                  child:  Column(
                    children: [
                      MovementDetailsTemplate(price: 150, description: "Entrada"),
                      MovementDetailsTemplate(price: 50, description: "Saida"),
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 90,
            left: MediaQuery.of(context).size.width / 2 - 125,
            width: 250,
            child: Card(
              elevation: 6,
              // shadowColor: Theme.of(context).primaryColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lucro Total',
                      style: TextStyle(fontSize: 18),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'R\$ 650,00',
                          style: TextStyle(
                            fontSize: 30,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        PopupMenuButton(
                          // color: const Color.fromRGBO(233, 30, 98, 0.877),
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.pink.shade500,
                          ),
                          iconSize: 30,
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem(
                              padding: EdgeInsets.zero,
                              value: "production-of-the-day",
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  Text("Adicionar Produção"),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: "all-productions",
                              padding: EdgeInsets.zero,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.zoom_in,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "Acessar Produções",
                                  ),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == "production-of-the-day") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ProductionPage(),
                                ),
                              );
                            } else if (value == "all-productions") {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const AllProductionsPage()));
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
