import 'package:flutter/material.dart';

import 'package:ice_cream/app/view/ice_cream_view.dart';
import 'package:ice_cream/route/routes.dart';

void main() async {
  runApp(const MyApp());
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
            ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 18),
        ),
      ),
      routes: {
        AppRoutes.home: (ctx) => const IceCreamView(),
      },
    );
  }
}
