import 'package:app_good_taste/app/models/production_model.dart';
import 'package:flutter/material.dart';

class ProductionController extends ChangeNotifier {
  List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items {
    return List<Map<String, dynamic>>.from(_items);
  }

  Future<void> save(Map<String, dynamic> data,
      List<Map<String, dynamic>> itemsProduction) async {
    await ProductionModel(
      quantity: data["quantity"],
      date: data["date"],
      flavorId: data["flavor_id"],
      priceProduct: data["price_product"],
      valueEntry: data["value_entry"],
      valueLeave: data["value_leave"],
      valueProfit: data["value_profit"],
    ).save(data["id"], itemsProduction);

    notifyListeners();
  }

  Future<void> load() async {
    final flavors = await ProductionModel.findAll();
    _items = List<Map<String, dynamic>>.from(flavors);
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getSumQuantityAndValueEntry(
      String month) async {
        // /07/
    return await ProductionModel.getSumQuantityAndValueEntry(month);
  }

  Future<List<Map<String, dynamic>>> getSumPriceFeedstockAndCountFeedstockAndValueLeave(
      String month) async {
        // /07/
    return await ProductionModel.getSumPriceFeedstockAndCountFeedstockAndValueLeave(month);
  }
  Future<List<Map<String, dynamic>>> getSumValueProfit(
      String month) async {
        // /07/
    return await ProductionModel.getSumValueProfit(month);
  }

  Future<List<Map<String, dynamic>>> getSumValueEntry(
      String month) async {
        // /07/
    return await ProductionModel.getSumValueEntry(month);
  }

  Future<List<Map<String, dynamic>>> getSumValueLeave(
      String month) async {
        // /07/
    return await ProductionModel.getSumValueLeave(month);
  }
}
