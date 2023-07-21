import 'package:app_good_taste/app/controllers/feedstock_controller.dart';
import 'package:app_good_taste/app/controllers/flavor_controller.dart';
import 'package:app_good_taste/app/controllers/product_controller.dart';
import 'package:app_good_taste/app/controllers/production_controller.dart';
import 'package:app_good_taste/app/models/items_production_model.dart';
import 'package:flutter/material.dart';

import 'app/config/db.dart';
import 'app/pages/good_taste_page.dart';
import 'app/route/routes.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const AppGoodTaste());
  // final db = await DB.database();

  // await db.execute("DROP TABLE productions");
  // await db.execute("DROP TABLE items_productions");

  // db.execute(
  //   'CREATE TABLE productions (id INTEGER PRIMARY KEY, quantity INTEGER NOT NULL, value_entry REAL, value_leave REAL NOT NULL, value_profit REAL, price_product, date TEXT, flavor_id INTEGER, FOREIGN KEY (flavor_id) REFERENCES flavors(id) ON DELETE SET NULL)',
  // );

  // db.execute(
  //   'CREATE TABLE items_productions (id INTEGER PRIMARY KEY, price_feedstock REAL, feedstock_id INTEGER, production_id INTEGER, FOREIGN KEY (feedstock_id) REFERENCES feedstock(id) ON DELETE SET NULL, FOREIGN KEY (production_id) REFERENCES production(id) ON DELETE CASCADE)',
  // );
  // print(await db.rawQuery("PRAGMA table_info(productions)"));
  // print("++++++++++++++++++++++++++++++++++++++++++++++++");
  // print(await db.rawQuery("PRAGMA table_info(items_productions)"));
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
        ChangeNotifierProvider(create: (_) => ProductionController()),
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
