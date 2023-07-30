import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/production_controller.dart';

class LoadDetailsProductions {
  static Future<List<Map<String, dynamic>>>
      getSumPriceFeedstockAndCountFeedstockAndValueLeave(
          BuildContext context, String monthAndYear) async {
    final productionProvider =
        Provider.of<ProductionController>(context, listen: false);
    return productionProvider
        .getSumPriceFeedstockAndCountFeedstockAndValueLeave(monthAndYear);
  }

  static Future<List<Map<String, dynamic>>> getSumQuantityAndValueEntry(
      BuildContext context, String monthAndYear) async {
    final productionProvider =
        Provider.of<ProductionController>(context, listen: false);
    return await productionProvider.getSumQuantityAndValueEntry(monthAndYear);
  }

  static Future<List<Map<String, dynamic>>> getSumValueEntry(
      BuildContext context, String monthAndYear) async {
    final productionProvider =
        Provider.of<ProductionController>(context, listen: false);
    return productionProvider.getSumValueEntry(monthAndYear);
  }

  static Future<List<Map<String, dynamic>>> getSumValueLeave(
      BuildContext context, String monthAndYear) async {
    final productionProvider =
        Provider.of<ProductionController>(context, listen: false);
    return await productionProvider.getSumValueLeave(monthAndYear);
  }

  static Future<List<Map<String, dynamic>>> getSumValueProfit(
      BuildContext context, String monthAndYear) async {
    final productionProvider =
        Provider.of<ProductionController>(context, listen: false);
    return productionProvider.getSumValueProfit(monthAndYear);
  }
}
