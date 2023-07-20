import 'package:sqflite/sqflite.dart';

import '../config/db.dart';

class FlavorModel {
  int id;
  String type;
  int productId;

  FlavorModel(this.id, this.type, this.productId);

  static Future<void> update(Map<String, dynamic> data) async {
    try {
      final type = data["type"];
      final id = data["id"];
      final db = await DB.database();
      await db.update("flavors", {"type": type},
          where: "id = ? ", whereArgs: [id]);
    } catch (e) {
      //
    }
  }

  static Future<void> insert(data) async {
    try {
      final db = await DB.database();
      await db.insert("flavors", data);
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

  static Future<void> delete(int id) async {
    final db = await DB.database();
    try {
      await db.delete("flavors", where: "id = ?", whereArgs: [id]);
    } catch (e) {
      //
    }
  }

  static Future<void> deleteByProductId(Transaction txn, int productId) async {
    try {
      await txn
          .delete("flavors", where: "product_id = ?", whereArgs: [productId]);
    } catch (e) {
      //
    }
  }
}
