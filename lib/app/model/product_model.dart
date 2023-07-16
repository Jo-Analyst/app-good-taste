import 'package:app_good_taste/app/model/flavor_model.dart';

import '../config/db.dart';

class ProductModel {
 late int? id;
  late final String name;
  late final double price;

  ProductModel({
    this.id,
    required this.name,
    required this.price,
  });

  Future<void> save(List<FlavorModel> flavorModel) async {
    final db = await DB.database();
    try {
      await db.transaction(
        (txn) async {
          if (id == null) {
            final lastInsertRowId = await txn.insert("products", {
              "name": name,
              "price": price,
            });

            for (var model in flavorModel) {
              model.productId = lastInsertRowId;
              model.save(txn);
            }
          } else {
            await txn.update("products", {"name": name, "price": price},
                where: "id = ?", whereArgs: [id!]);

            for (var model in flavorModel) {
              model.productId = id!;
              model.save(txn);
            }

            FlavorModel(productId: id!, type: "Trufa de morango").save(txn);
          }
        },
      );
    } catch (ex) {
      //
    }
  }
}
