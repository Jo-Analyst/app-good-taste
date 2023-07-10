import 'package:app_good_taste/app/template/slide_year.dart';
import 'package:flutter/material.dart';

class AllProductionsPage extends StatelessWidget {
  const AllProductionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Todas as produções",
          style: TextStyle(fontSize: 25),
        ),
        toolbarHeight: 100,
      ),
      body: Container(
        color: const Color.fromARGB(179, 246, 245, 245),
        padding: const EdgeInsets.all(10),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 30,
                  ),
                  SlideYear(),
                ],
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
