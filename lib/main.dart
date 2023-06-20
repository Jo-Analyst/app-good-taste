import 'package:app_ice_cream/app/view/ice_cream-view.dart';
import 'package:app_ice_cream/route/routes.dart';
import 'package:flutter/material.dart';

void main() {
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
          // primarySwatch: ,
        )
      ),
      // home:
      routes: {
        AppRoutes.home: (ctx) => const IceCreamView(),
      },
    );
  }
}
