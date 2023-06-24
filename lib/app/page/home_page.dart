import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 80, left: 30),
                  child: const Text(
                    'ICE CREAM',
                    style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16), // Espaçamento entre o Text e o Card
          ],
        ),
         Positioned(
          top: 150, // Posiciona o elemento a 80 pixels do topo
          left: 50, // Posiciona o elemento a 16 pixels da esquerda
          width: 250,
          child: Card(
            elevation: 8,
            shadowColor: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lucro Total',
                    style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
                  ),
                   Text(
                    'R\$ 650,00',
                    style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor, fontWeight: FontWeight.w700),
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
