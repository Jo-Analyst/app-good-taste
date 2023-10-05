import 'package:app_good_taste/app/config/db.dart';

class FeedstockModel {
  final int? id;
  final String? name;
  final String? brand;
  final double? price;
  final String? unit;

  FeedstockModel({
    this.id,
    this.name,
    this.brand,
    this.price,
    this.unit,
  });

  static Future<List<Map<String, dynamic>>> findAll() async {
    final db = await DB.openDatabase();
    return db.query("feedstocks", orderBy: "name asc");
  }

  Future<void> delete() async {
    try {
      final db = await DB.openDatabase();
      await db.delete("feedstocks", where: "id = ?", whereArgs: [id]);
    } catch (e) {
      //
    }
  }

  Future<int> save() async {
    int latestId = 0;
    try {
      final db = await DB.openDatabase();
      final data = {"name": name, "brand": brand, "price": price, "unit": unit};
      if (id == 0) {
        latestId = await db.insert("feedstocks", data);
      } else {
        await db.update("feedstocks", data, where: "id = ?", whereArgs: [id]);
      }
    } catch (e) {
      //
    }

    return latestId;
  }
}
