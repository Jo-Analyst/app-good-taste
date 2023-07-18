import 'package:sqflite/sqflite.dart';

import '../config/db.dart';

class FlavorModel {
  int id;
  String type;
  int productId;

  FlavorModel({
    required this.id,
    required this.type,
    required this.productId,
  });

  Future<void> update() async {
    try {
      final db = await DB.database();
      await db.update("flavors", {"type": type},
          where: "id = ? ", whereArgs: [id]);
    } catch (e) {
      //
    }
  }

  Future<void> save(Transaction txn) async {
    try {
      if (id == 0) {
        await txn.insert("flavors", {
          "type": type,
          "product_id": productId,
        });
      } else {
        await txn.update("flavors", {"type": type, "product_id": productId},
            where: "id = ?", whereArgs: [id]);
      }
    } catch (ex) {
      //
    }
  }

  static Future<List<Map<String, dynamic>>> findByProductId(
      int productId) async {
    final db = await DB.database();
    return db.query("flavors", where: "product_id = ?", whereArgs: [productId]);
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await DB.database();
    return db.query("flavors");
  }

  Future<void> delete() async {
    final db = await DB.database();
    try {
      await db.delete("flavors", where: "id = ?", whereArgs: [id]);
    } catch (e) {
      //
    }
  }

  Future<void> deleteByProductId(Transaction txn) async {
    try {
      await txn
          .delete("flavors", where: "product_id = ?", whereArgs: [productId]);
    } catch (e) {
      //
    }
  }
}
