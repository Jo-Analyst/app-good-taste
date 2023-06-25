import 'package:flutter/material.dart';
import 'package:ice_cream/app/template/movement_details.dart';

class MovementDetailsPage extends StatelessWidget {
  const MovementDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  'ICE CREAM',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 330,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.keyboard_arrow_left),
                  Text(
                    "Janeiro",
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.displayLarge?.fontSize,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_right),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Movimentação:",
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.displayLarge?.fontSize),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const MovementDetails(price: 25, description: "Entrada"),
            const MovementDetails(price: 25, description: "Saida"),
            const MovementDetails(price: 25, description: "Total")
          ],
        ),
         Positioned(
          top: 120,
          left: 50,
          width: 250,
          child: Card(
            elevation: 6,
            // shadowColor: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lucro Total',
                    style: TextStyle(
                        fontSize: 18),
                  ),
                  Text(
                    'R\$ 650,00',
                    style: TextStyle(
                        fontSize: 40,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700),
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
