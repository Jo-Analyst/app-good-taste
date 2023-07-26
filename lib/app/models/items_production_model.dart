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

  static Future<void> delete(Transaction txn, int productId) async {
    txn.delete("items_productions",
        where: "production_id = ?", whereArgs: [productId]);
  }

  static Future<List<Map<String, dynamic>>> findByProductionId(
      productionId) async {
    final db = await DB.openDatabase();
    return db.rawQuery("SELECT * FROM items_productions AS i INNER JOIN feedstocks AS f ON f.id = i.feedstock_id WHERE i.product_id = ? ", [productionId]);
  }
}
