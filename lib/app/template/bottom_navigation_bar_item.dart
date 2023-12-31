import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavigationBarItemTemplate {
  static List<BottomNavigationBarItem> items() {
    return const [
      BottomNavigationBarItem(
        label: "Finanças",
        icon: Icon(Icons.auto_graph),
      ),
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.productHunt),
        label: "Matéria Prima",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.shopify_rounded),
        label: "Produtos",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.backup),
        label: "Backup",
      ),
    ];
  }
}
