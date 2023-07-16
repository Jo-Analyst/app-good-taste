import 'package:app_good_taste/app/model/flavor_model.dart';
import 'package:flutter/material.dart';

class FlavorController with ChangeNotifier {
  List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items {
    return [..._items];
  }

  Future<void> loadFlavors() async {
    _items = await FlavorModel.getData();
  }
}
