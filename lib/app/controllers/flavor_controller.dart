import 'package:app_good_taste/app/models/flavor_model.dart';
import 'package:flutter/material.dart';

class FlavorController extends ChangeNotifier {
  List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items {
    return List<Map<String, dynamic>>.from(_items);
  }

  Future<void> load() async {
    final flavors = await FlavorModel.findAll();
    _items = List<Map<String, dynamic>>.from(flavors);
    notifyListeners();
  }

  Future<void> findByProductId(int productId) async {
    final flavors = await FlavorModel.findByProductId(productId);
    _items = List<Map<String, dynamic>>.from(flavors);
    notifyListeners();
  }

  Future<void> update(Map<String, dynamic> data) async {
    await FlavorModel.update(data);
  }

  Future<void> delete(int id) async {
    await FlavorModel.delete(id);
    notifyListeners();
  }

  Future<void> add(Map<String, dynamic> data) async {
    _items.add({"id": null, "type": data["type"]});
    final product = {
      "type": data["type"],
      "product_id": data["product_id"],
    };
    await FlavorModel.insert(product);
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
