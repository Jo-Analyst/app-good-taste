import 'package:app_good_taste/app/models/flavor_model.dart';

import '../config/db.dart';

class ProductModel {
  late int id;
  final String? name;
  final double? price;

  ProductModel({
    required this.id,
    this.name,
    this.price,
  });

  static Future<List<Map<String, dynamic>>> findAllPartsByProductId(int productId) async {
    final db = await DB.database();
    const String query =
        "SELECT flavors.type AS flavor, products.price, flavors.id FROM products INNER JOIN flavors ON flavors.product_id =  products.id  WHERE products.id = ?  ORDER BY flavors.type ASC";
    return db.rawQuery(query, [productId]);
  }

  static Future<List<Map<String, dynamic>>> findAll() async {
    final db = await DB.database();
    return db.query("products");
  }

  static Future<void> delete(int id) async {
    final db = await DB.database();
    try {
      await db.transaction((txn) async {
        txn.delete("products", where: "id = ?", whereArgs: [id]);
        FlavorModel.deleteByProductId(txn, id);
      });
    } catch (e) {
      //
    }
  }

  static Future<void> save(
      List<FlavorModel> flavorModel, Map<String, dynamic> data) async {
    final db = await DB.database();
    final id = data["id"];
    final name = data["name"];
    final price = data["price"];
    late int lastInsertRowId;
    try {
      await db.transaction(
        (txn) async {
          if (id == 0) {
            lastInsertRowId = await txn.insert("products", {
              "name": name,
              "price": price,
            });
          } else {
            await txn.update("products", {"name": name, "price": price},
                where: "id = ?", whereArgs: [id]);
          }

          for (var model in flavorModel) {
            model.productId = id == 0 ? lastInsertRowId : id;
            await model.save(txn);
          }
        },
      );
    } catch (ex) {
      //
    }
  }
}
