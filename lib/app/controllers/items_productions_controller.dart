import 'package:app_good_taste/app/models/items_production_model.dart';
import 'package:flutter/material.dart';

class ItemsProductionsController extends ChangeNotifier {
  Future<List<Map<String, dynamic>>> loadItemsProductions(
      int productionId) async {
    return ItemsProductionModel.findByProductionId(productionId);
  }
}
