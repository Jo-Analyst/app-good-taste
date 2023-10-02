import 'package:app_good_taste/app/models/production_model.dart';
import 'package:flutter/material.dart';

class ProductionController extends ChangeNotifier {
  List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items {
    return List<Map<String, dynamic>>.from(_items);
  }

  Future<bool> save(
      Map<String, dynamic> data,
      List<Map<String, dynamic>> itemsProduction) async {
    return await ProductionModel(
      quantity: data["quantity"],
      date: data["date"],
      flavorId: data["flavor_id"],
      priceProduct: data["price_product"],
      valueEntry: data["value_entry"],
      valueLeave: data["value_leave"],
      valueProfit: data["value_profit"],
    ).save(data["id"], itemsProduction);
  }

  Future<void> load() async {
    final flavors = await ProductionModel.findAll();
    _items = List<Map<String, dynamic>>.from(flavors);
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> loadDate(String date) async {
    return await ProductionModel.findDateAndValuesByYear(date);
  }

  Future<List<Map<String, dynamic>>> getSumQuantityAndValueEntry(
      String monthAndYear) async {
    return await ProductionModel.getSumQuantityAndValueEntry(monthAndYear);
  }

  void remove(int id) {
    ProductionModel.delete(id);
  }

  Future<List<Map<String, dynamic>>>
      getSumPriceFeedstockAndCountFeedstockAndValueLeave(
          String monthAndYear) async {
    return await ProductionModel
        .getSumPriceFeedstockAndCountFeedstockAndValueLeave(monthAndYear);
  }

  Future<List<Map<String, dynamic>>> getSumValueProfit(
      String monthAndYear) async {
    return await ProductionModel.getSumValueProfit(monthAndYear);
  }

  Future<List<Map<String, dynamic>>> getSumValueEntry(
      String monthAndYear) async {
    return await ProductionModel.getSumValueEntry(monthAndYear);
  }

  Future<List<Map<String, dynamic>>> getSumValueLeave(
      String monthAndYear) async {
    return await ProductionModel.getSumValueLeave(monthAndYear);
  }

  Future<List<Map<String, dynamic>>> getDetailsFlavors(String date) async {
    return await ProductionModel.getDetailsFlavors(date);
  }

  Future<List<Map<String, dynamic>>> getDetailsFeedstocks(String date) async {
    return await ProductionModel.getDetailsFeedstocks(date);
  }
}
