import 'package:app_good_taste/app/model/flavor_model.dart';

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

  // static Future<List<Map<String, dynamic>>> getData() async {
  //   final db = await DB.database();
  //   const String query =
  //       "SELECT products.id as product_id, products.name, products.price, flavors.type, flavors.id as flavor_id FROM products INNER JOIN flavors ON flavors.product_id =  products.id";
  //   return db.rawQuery(query);
  // }

  static Future<List<Map<String, dynamic>>> getData() async {
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
    try {
      await db.transaction(
        (txn) async {
          if (id == 0) {
            final lastInsertRowId = await txn.insert("products", {
              "name": name,
              "price": price,
            });

            for (var model in flavorModel) {
              model.productId = lastInsertRowId;
              await model.save(txn);
            }
          } else {
            await txn.update("products", {"name": name, "price": price},
                where: "id = ?", whereArgs: [id]);

            for (var model in flavorModel) {
              model.productId = id;
              await model.save(txn);
            }
          }
        },
      );
    } catch (ex) {
      //
    }
  }
}
