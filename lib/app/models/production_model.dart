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

  Future<bool> save(int id, List<Map<String, dynamic>> itemsProduction) async {
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

    try {
      final db = await DB.openDatabase();
      await db.transaction((txn) async {
        if (id == 0) {
          lastInsertRowId = await txn.insert("productions", data);
        } else {
          await txn
              .update("productions", data, where: "id = ?", whereArgs: [id]);
        }
        for (var items in itemsProduction) {
          await ItemsProductionModel(
                  id: items["item_product_id"],
                  productionId: id == 0 ? lastInsertRowId : id,
                  priceFeedstock: items["price_feedstock"],
                  feedstockId: items["feedstock_id"])
              .save(txn);
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> findAll() async {
    final db = await DB.openDatabase();
    return db.query("productions");
  }

  static void delete(int id) async {
    final db = await DB.openDatabase();
    await db.transaction((txn) async {
      await txn.delete("productions", where: "id = ?", whereArgs: [id]);
      await ItemsProductionModel.delete(txn, id);
    });
  }

  static Future<List<Map<String, dynamic>>> findDateAndValuesByYear(
      String date) async {
    final db = await DB.openDatabase();
    return db.rawQuery(
        "SELECT date, SUM(value_entry) AS value_entry, SUM(value_leave) AS value_leave, SUM(value_profit) AS value_profit from productions WHERE date LIKE '%$date%' GROUP BY date");
  }

  static Future<List<Map<String, dynamic>>> getSumQuantityAndValueEntry(
      String month) async {
    final db = await DB.openDatabase();
    return db.rawQuery(
        "SELECT SUM(productions.quantity) AS quantity, SUM(productions.value_entry) AS price, flavors.type AS name FROM productions INNER JOIN flavors ON productions.flavor_id = flavors.id WHERE date LIKE '%$month%' GROUP BY flavors.type");
  }

  static Future<List<Map<String, dynamic>>>
      getSumPriceFeedstockAndCountFeedstockAndValueLeave(String month) async {
    final db = await DB.openDatabase();
    return db.rawQuery(
        "SELECT SUM(items_productions.price_feedstock) AS price, COUNT(feedstocks.name) AS quantity, feedstocks.name, feedstocks.unit FROM productions INNER JOIN items_productions ON productions.id = items_productions.production_id INNER JOIN feedstocks ON feedstocks.id = items_productions.feedstock_id WHERE date LIKE '%$month%' GROUP BY feedstocks.name");
  }

  static Future<List<Map<String, dynamic>>> getSumValueProfit(
      String month) async {
    final db = await DB.openDatabase();
    return db.rawQuery(
        "SELECT SUM(value_profit) AS value_profit FROM productions WHERE date LIKE '%$month%'");
  }

  static Future<List<Map<String, dynamic>>> getSumValueEntry(
      String month) async {
    final db = await DB.openDatabase();
    return db.rawQuery(
        "SELECT SUM(value_entry) AS value_entry FROM productions WHERE date LIKE '%$month%'");
  }

  static Future<List<Map<String, dynamic>>> getSumValueLeave(
      String month) async {
    final db = await DB.openDatabase();
    return db.rawQuery(
        "SELECT SUM(value_leave) AS value_leave FROM productions WHERE date LIKE '%$month%'");
  }

  static Future<List<Map<String, dynamic>>> getDetailsFlavors(
      String date) async {
    final db = await DB.openDatabase();
    return db.rawQuery(
        "SELECT p.id, p.date, f.type AS flavor, p.flavor_id, p.quantity, p.value_entry, p.value_leave, p.value_profit, p.price_product AS price, ps.name, ps.id AS product_id FROM productions AS p INNER JOIN flavors AS f ON f.id = p.flavor_id INNER JOIN products AS ps ON ps.id = f.product_id WHERE date = '$date'");
  }

  static Future<List<Map<String, dynamic>>> getDetailsFeedstocks(
      String date) async {
    final db = await DB.openDatabase();
    return db.rawQuery(
        "SELECT f.name, COUNT(f.name) count_feedstock, f.unit, SUM(f.price) AS price FROM productions AS p inner join items_productions AS i ON p.id = i.production_id INNER JOIN feedstocks AS f ON f.id = i.feedstock_id WHERE date = '$date' GROUP BY f.name");
  }
}
