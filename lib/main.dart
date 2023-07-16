import 'package:app_good_taste/app/config/db.dart';
import 'package:app_good_taste/app/controller/flavor_controller.dart';
import 'package:app_good_taste/app/controller/product_controller.dart';
import 'package:app_good_taste/app/model/product_model.dart';
import 'package:flutter/material.dart';

import 'app/page/good_taste_page.dart';
import 'app/route/routes.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const AppGoodTaste());
  //     await DB.save("products", {"name": "chup-chup  super cremoso", "price": 3.0});
  // await DB.save("flavors", {"type": "Morango", "product_id": 1});
  // await DB.save("flavors", {"type": "Limão", "product_id": 1});
  // await DB.save("flavors", {"type": "Maracujá", "product_id": 1});
  // await DB.save("flavors", {"type": "BIS", "product_id": 1});
  // await DB.save("flavors", {"type": "Lata", "product_id": 1});

  // final products = await DB.getData("products");
  // final flavors = await DB.getData("flavors");
  // final productAndFlavor = await ProductModel.getData("");
  // print(products);
  // print(flavors);
  // print(productAndFlavor);
}

class AppGoodTaste extends StatelessWidget {
  const AppGoodTaste({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FlavorController()),
        ChangeNotifierProvider(create: (_) => ProductController()),
      ],
      child: MaterialApp(
        title: "APP - Good Taste",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // useMaterial3: true,
          scaffoldBackgroundColor: const Color.fromARGB(179, 246, 245, 245),
          primarySwatch: Colors.pink,
          primaryColor: Colors.pink[500],
          popupMenuTheme: const PopupMenuThemeData(
              textStyle: TextStyle(color: Colors.white),
              color: Color.fromRGBO(233, 30, 98, 0.877)),
          // iconTheme: const IconThemeData(color: Colors.white),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.pink[500],
          ),
        ),
        routes: {
          AppRoutes.home: (ctx) => const GoodTastPage(),
        },
      ),
    );
  }
}
