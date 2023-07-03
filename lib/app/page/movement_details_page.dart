import 'package:flutter/material.dart';
// import 'package:app_good_taste/app/partils/month.dart';
import 'package:app_good_taste/app/template/movement_details_template.dart';

import '../template/slide_month.dart';

class MovementDetailsPage extends StatelessWidget {
  const MovementDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Bom Paladar',
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),

            const SlideMonth(),

            // const SizedBox(height: 10),
            const SizedBox(height: 20),
            const Column(
              children: [
                MovementDetailsTemplate(price: 150, description: "Entrada"),
                MovementDetailsTemplate(price: 50, description: "Saida"),
                // MovementDetailsTemplate(price: 25, description: "Total")
              ],
            )
          ],
        ),
        Positioned(
          top: 120,
          left: MediaQuery.of(context).size.width / 2 - 125,
          width: 250,
          child: Card(
            elevation: 6,
            // shadowColor: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                            fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.add_circle,
                          color: Theme.of(context).primaryColor,
                          size: 35,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
