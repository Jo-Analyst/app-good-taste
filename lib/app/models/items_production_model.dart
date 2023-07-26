import 'package:sqflite/sqflite.dart';

class ItemsProductionModel {
  int? id;
  int? feedstockId;
  double? priceFeedstock;
  int? productionId;

  ItemsProductionModel({
    this.id,
    this.feedstockId,
    this.priceFeedstock,
    this.productionId,
  });

  Future<void> save(Transaction txn) async {
    Map<String, dynamic> data = {
      "price_feedstock": priceFeedstock,
      "feedstock_id": feedstockId,
      "production_id": productionId,
    };
    if (id == 0) {
      await txn.insert("items_productions", data);
    } else {
      await txn
          .update("items_productions", data, where: "id = ?", whereArgs: [id]);
    }
  }

 static Future<void> delete(Transaction txn, int productId) async {
    txn.delete("items_productions",
        where: "production_id = ?", whereArgs: [productId]);
  }
}
