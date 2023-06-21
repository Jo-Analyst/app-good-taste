import 'package:ice_cream/app/view/ice_cream-view.dart';
import 'package:ice_cream/route/routes.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
  // DB.insert("products", {"name": "Suco de morango", "brand": "TANG", "price": 1.35});
  // DB.insert("products", {"name": "Suco de maracujá", "brand": "TANG", "price": 1.35});
  // DB.insert("products", {"name": "Suco de uva", "brand": "TANG", "price": 1.35});
  // DB.insert("products", {"name": "Suco de Baunilha de limão", "brand": "MID", "price": 0.95});
  // DB.insert("productions", {"quantity": 12,  "date_production": "21/06/2023"});
  // var products = await DB.getData("productions");
  // for (var product in products) {
  //   print(product);
  // }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "APP - Ice Cream",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
              // primarySwatch: ,
              )),
      // home:
      routes: {
        AppRoutes.home: (ctx) => const IceCreamView(),
      },
    );
  }
}
