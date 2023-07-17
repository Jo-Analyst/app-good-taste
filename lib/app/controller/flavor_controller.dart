import 'package:app_good_taste/app/model/flavor_model.dart';
import 'package:flutter/material.dart';

class FlavorController extends ChangeNotifier {
  List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items {
    return List<Map<String, dynamic>>.from(_items);
  }

  Future<void> loadFlavors() async {
    final flavors = await FlavorModel.getData();
    _items = List<Map<String, dynamic>>.from(flavors);
    notifyListeners();
  }
 
  Future<void> findByProductId(int productId) async {
    final flavors = await FlavorModel.findByProductId(productId);
    _items = List<Map<String, dynamic>>.from(flavors);
    notifyListeners();
  }

  void add(String type) {
    _items.add({"id": null, "type": type});
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  void removeAt(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
}
