import 'package:flutter/material.dart';

class BottomNavigationBarItemTemplate {
  static List<BottomNavigationBarItem> items() {
    return const [
      BottomNavigationBarItem(
        label: "Início",
        icon: Icon(Icons.home_outlined),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.save_outlined),
        label: "Cadastro",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.attach_money),
        label: "Gastos",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.picture_as_pdf_outlined),
        label: "Relatório",
      ),
      // BottomNavigationBarItemTemplate.buttomItem(const Icon(Icons.home), "Início"),
    ];
  }
}
