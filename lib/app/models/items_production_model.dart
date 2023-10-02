import 'package:app_good_taste/app/config/db.dart';
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

  static Future<void> deleteByProductId(Transaction txn, int productId) async {
    txn.delete("items_productions",
        where: "production_id = ?", whereArgs: [productId]);
  }

  static Future<void> deleteByProductionId(
      Transaction txn, int productionId) async {
    txn.delete("items_productions",
        where: "production_id = ?", whereArgs: [productionId]);
  }

  static Future<List<Map<String, dynamic>>> findByProductionId(
      productionId) async {
    final db = await DB.openDatabase();
    return db.rawQuery(
        "SELECT f.id, f.name, f.price, f.brand, i.id AS item_production_id, sum(f.price) as subtotal, COUNT(f.id) as quantity FROM items_productions AS i INNER JOIN feedstocks AS f ON f.id = i.feedstock_id WHERE i.production_id = ? GROUP BY f.name ",
        [productionId]);
  }

  static Future<List<Map<String, dynamic>>> findItemProductionByfeedstockId(
      int feedstockID) async {
    final db = await DB.openDatabase();
    return db.rawQuery(
        "SELECT i.id AS item_production_id FROM items_productions AS i INNER JOIN feedstocks AS f ON f.id = i.feedstock_id WHERE i.feedstock_id = ? ",
        [feedstockID]);
  }
}
