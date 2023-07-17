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

  void save(Transaction txn) async {
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

  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await DB.database();
    return db.query("flavors");
  }
}
