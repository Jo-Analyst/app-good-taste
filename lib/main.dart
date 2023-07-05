import 'package:flutter/material.dart';

import 'app/page/good_taste_page.dart';
import 'app/route/routes.dart';

void main() async {
  runApp(const AppGoodTaste());
}

class AppGoodTaste extends StatelessWidget {
  const AppGoodTaste({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "APP - Good Taste",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromARGB(179, 246, 245, 245),
        primarySwatch: Colors.pink,
        primaryColor: Colors.pink[500],
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
    );
  }
}
