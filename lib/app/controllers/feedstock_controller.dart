import 'package:app_good_taste/app/models/feedestock_model.dart';
import 'package:flutter/material.dart';

class FeedstockController extends ChangeNotifier {
  List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items {
    return List<Map<String, dynamic>>.from(_items);
  }

  Future<void> loadFeedstock() async {
    _items = await FeedstockModel.findAll();
  }

  Future<void> delete(int id) async {
    FeedstockModel(id: id).delete();
    notifyListeners();
  }

  Future<void> save(Map<String, dynamic> data) async {
    _items.add(data);
    FeedstockModel(
      id: data["id"],
      name: data["name"],
      brand: data["brand"],
      price: data["price"],
    ).save();
    notifyListeners();
  }
}
