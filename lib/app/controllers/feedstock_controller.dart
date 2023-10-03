import 'package:app_good_taste/app/models/feedestock_model.dart';
import 'package:flutter/material.dart';

class FeedstockController with ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items {
    return [
      ..._items
        ..sort((a, b) => a["name"]
            .toString()
            .toLowerCase()
            .compareTo(b["name"].toString().toLowerCase()))
    ];
  }

  Future<void> loadFeedstock() async {
    _items.clear();
    for (var feedstock in await FeedstockModel.findAll()) {
      _items.add(feedstock);
    }
  }

  Future<void> delete(int id) async {
    FeedstockModel(id: id).delete();
    notifyListeners();
  }

  Future<void> save(Map<String, dynamic> data) async {
    FeedstockModel(
      id: data["id"],
      name: data["name"],
      brand: data["brand"],
      price: data["price"],
      unit: data["unit"],
    ).save();
    notifyListeners();
  }
}
