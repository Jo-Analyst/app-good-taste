import 'package:flutter/material.dart';
import 'package:ice_cream/app/template/movement_details_template.dart';

class MovementDetailsPage extends StatelessWidget {
  const MovementDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 150,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
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
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: 330,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.keyboard_arrow_left),
                  ),
                  Text(
                    "Janeiro",
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.displayLarge?.fontSize,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.keyboard_arrow_right),
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 10),
            // const SizedBox(height: 10),
            const Column(
              children: [
                MovementDetailsTemplate(price: 25, description: "Entrada"),
                MovementDetailsTemplate(price: 25, description: "Saida"),
                MovementDetailsTemplate(price: 25, description: "Total")
              ],
            )
          ],
        ),
        Positioned(
          top: 90,
          left: 50,
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
                  Text(
                    'R\$ 650,00',
                    style: TextStyle(
                        fontSize: 30,
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
