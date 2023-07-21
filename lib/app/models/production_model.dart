import 'package:app_good_taste/app/config/db.dart';

import 'items_production_model.dart';

class ProductionModel {
  int? id;
  int? quantity;
  double? valueEntry;
  double? valueLeave;
  double? valueProfit;
  double? priceProduct;
  String? date;
  int? flavorId;

  ProductionModel({
    this.id,
    this.quantity,
    this.valueEntry,
    this.valueLeave,
    this.valueProfit,
    this.priceProduct,
    this.date,
    this.flavorId,
  });

  Future<void> save(int id, List<Map<String, dynamic>> itemsProduction) async {
    int lastInsertRowId = 0;
    Map<String, dynamic> data = {
      "quantity": quantity,
      "value_entry": valueEntry,
      "value_leave": valueLeave,
      "value_profit": valueProfit,
      "price_product": priceProduct,
      "date": date,
      "flavor_id": flavorId,
    };

    final db = await DB.database();
    await db.transaction((txn) async {
      if (id == 0) {
        lastInsertRowId = await txn.insert("productions", data);
      } else {
        await txn.update("productions", data, where: "id = ?", whereArgs: [id]);
      }

      for (var itemsProduction in itemsProduction) {
        ItemsProductionModel(
            feedstockId: itemsProduction["feedstock_id"],
            priceFeedstock: itemsProduction["price_feedstock"],
            id: itemsProduction["id"],
            productionId: id == 0 ? lastInsertRowId : id);
        ItemsProductionModel().save(txn);
      }
    });
  }
}
