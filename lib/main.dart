import 'package:app_good_taste/app/controllers/feedstock_controller.dart';
import 'package:app_good_taste/app/controllers/flavor_controller.dart';
import 'package:app_good_taste/app/controllers/product_controller.dart';
import 'package:flutter/material.dart';

import 'app/pages/good_taste_page.dart';
import 'app/route/routes.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const AppGoodTaste());
  final feedstock = FeedstockController();
  await feedstock
      // .save({"id": 0, "name": "Leite", "brand": "IVAN", "price": 3.00});
      .save({"id": 0, "name": "Suco de morango", "brand": "TANG", "price": 1.35});
      await feedstock.save({"id": 0, "name": "Suco de baunilha de limão", "brand": "MID", "price": 1.25});
      await feedstock.save({"id": 0, "name": "Açucar", "brand": "Gigante", "price": 19.5});
  await feedstock.loadFeedstock();
  print(feedstock.items);
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppGoodTaste extends StatelessWidget {
  const AppGoodTaste({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FlavorController()),
        ChangeNotifierProvider(create: (_) => ProductController()),
        ChangeNotifierProvider(create: (_) => FeedstockController()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: "APP - Good Taste",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // useMaterial3: true,
          scaffoldBackgroundColor: const Color.fromARGB(179, 246, 245, 245),
          primarySwatch: Colors.pink,
          primaryColor: Colors.pink[500],
          popupMenuTheme: const PopupMenuThemeData(
            textStyle: TextStyle(color: Colors.white),
            color: Color.fromRGBO(233, 30, 98, 0.877),
          ),
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
