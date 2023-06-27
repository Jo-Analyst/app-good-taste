import 'package:flutter/material.dart';
import 'package:ice_cream/app/partils/month.dart';
import 'package:ice_cream/app/template/movement_details_template.dart';

class MovementDetailsPage extends StatefulWidget {
  const MovementDetailsPage({super.key});

  @override
  State<MovementDetailsPage> createState() => _MovementDetailsPageState();
}

class _MovementDetailsPageState extends State<MovementDetailsPage> {
  int numberMonth = int.parse(DateTime.now().month.toString()) - 1;
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
            const SizedBox(height: 28),
            SizedBox(
              width: 330,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => setState(() {
                      if (numberMonth == 0) return;
                      numberMonth--;
                    }),
                    icon: const Icon(Icons.keyboard_arrow_left),
                  ),
                  MonthPartils(numberMonth),
                  IconButton(
                    onPressed: () => setState(() {
                      if (numberMonth == 11) return;
                      numberMonth++;
                    }),
                    icon: const Icon(Icons.keyboard_arrow_right),
                  ),
                ],
              ),
            ),
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
