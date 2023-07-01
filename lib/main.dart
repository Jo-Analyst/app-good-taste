import 'package:flutter/material.dart';

import 'package:ice_cream/app/page/ice_cream_view.dart';
import 'package:ice_cream/app/route/routes.dart';

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
        scaffoldBackgroundColor: const Color.fromARGB(179, 246, 245, 245),
        primaryColor: Colors.pink[500],
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 18, color: Colors.black),
        ),
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.pink[500]),
      ),
      routes: {
        AppRoutes.home: (ctx) => const IceCreamView(),
      },
    );
  }
}
