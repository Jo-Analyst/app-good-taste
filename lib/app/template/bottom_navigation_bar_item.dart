import 'package:flutter/material.dart';

class BottomNavigationBarItemTemplate {
  static List<BottomNavigationBarItem> items() {
    return const [
      BottomNavigationBarItem(
        label: "Finanças",
        icon: Icon(Icons.auto_graph),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.card_travel_sharp),
        label: "M. Prima",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.shopify_rounded),
        label: "Produtos",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.picture_as_pdf_outlined),
        label: "Relatório",
      ),
      // BottomNavigationBarItemTemplate.buttomItem(const Icon(Icons.home), "Início"),
    ];
  }
}
