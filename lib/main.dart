import 'package:app_good_taste/app/controllers/feedstock_controller.dart';
import 'package:app_good_taste/app/controllers/flavor_controller.dart';
import 'package:app_good_taste/app/controllers/items_productions_controller.dart';
import 'package:app_good_taste/app/controllers/product_controller.dart';
import 'package:app_good_taste/app/controllers/production_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/pages/good_taste_page.dart';
import 'app/route/routes.dart';
import 'package:provider/provider.dart';

void main() async {
  initializeDateFormatting('pt_BR', null);
  runApp(const AppGoodTaste());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppGoodTaste extends StatelessWidget {
  const AppGoodTaste({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a orientação do aplicativo como retrato (vertical) apenas.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FlavorController()),
        ChangeNotifierProvider(create: (_) => ProductController()),
        ChangeNotifierProvider(create: (_) => FeedstockController()),
        ChangeNotifierProvider(create: (_) => ProductionController()),
        ChangeNotifierProvider(create: (_) => ItemsProductionsController()),
      ],
      child: MaterialApp(
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [
          Locale('pt', 'BR'),
          // Outros idiomas suportados, se necessário
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
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
          AppRoutes.home: (ctx) => const GoodTastePage(),
        },
      ),
    );
  }
}
