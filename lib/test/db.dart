import 'package:app_good_taste/app/config/db.dart';
import 'package:sqflite/sqflite.dart';

late Database db;

void testSelect() async {
  db = await DB.openDatabase();
  final productions = await db.rawQuery(
      "SELECT SUM(items_productions.price_feedstock) AS price, COUNT(feedstocks.name) AS quantity, feedstocks.name, feedstocks.unit, items_productions.price_feedstock AS subtotal FROM productions INNER JOIN items_productions ON productions.id = items_productions.production_id INNER JOIN feedstocks ON feedstocks.id = items_productions.feedstock_id WHERE date LIKE '%/07/2023%' GROUP BY feedstocks.name");
  for (var production in productions) {
    print(production);
  }
}

void deleteInTable() async {
  // final db = await DB.openDatabase();
  // print(await db.query("productions"));
  // print(await db.query("items_productions"));
}

void insertInTables() {
  insertProduct();
  insertFeedstock();
}

void insertProduct() async {
  db = await DB.openDatabase();
  await db.transaction((txn) async {
    final id = await txn
        .insert("products", {"name": "Chup-Chup cremoso", "price": 1.5});
    await txn
        .insert("flavors", {"type": "Baunilha de limão", "product_id": id});
    await txn.insert("flavors", {"type": "Morango", "product_id": id});
    await txn.insert("flavors", {"type": "Maracujá", "product_id": id});
    await txn.insert("flavors", {"type": "Uva", "product_id": id});
    await txn.insert("flavors", {"type": "Limonada Suiça", "product_id": id});
    await txn.insert("flavors", {"type": "Chocolate", "product_id": id});
    await txn.insert("flavors", {"type": "Leite condensado", "product_id": id});
    await txn.insert("flavors", {"type": "Abacaxi", "product_id": id});
  });
  await db.transaction((txn) async {
    final id = await txn
        .insert("products", {"name": "Chup-Chup goumert", "price": 3.0});
    await txn.insert("flavors", {"type": "Trufa de limão", "product_id": id});
    await txn.insert("flavors", {"type": "Trufa de Morango", "product_id": id});
    await txn
        .insert("flavors", {"type": "Trufa de Maracujá", "product_id": id});
    await txn.insert("flavors", {"type": "BIS", "product_id": id});
    await txn.insert("flavors", {"type": "Chocolate Branco", "product_id": id});
  });

  await db.transaction((txn) async {
    final id = await txn
        .insert("products", {"name": "Chup-Chup Alcóolico", "price": 5.0});
    await txn.insert("flavors", {"type": "Vinho", "product_id": id});
    await txn.insert("flavors", {"type": "Licor", "product_id": id});
    await txn.insert("flavors", {"type": "Vodka", "product_id": id});
    await txn.insert("flavors", {"type": "Caipirinha", "product_id": id});
  });
}

void insertFeedstock() async {
  final db = await DB.openDatabase();
  await db.transaction((txn) async {
    await txn.insert("feedstocks", {
      "name": "Suco de baunilha de limão",
      "price": 1.0,
      "brand": "MID",
      "unit": "PC"
    });
    await txn.insert("feedstocks",
        {"name": "Limonada suiça", "price": 1, "brand": "MID", "unit": "PC"});
    await txn.insert("feedstocks", {
      "name": "Suco de morango",
      "price": 1.35,
      "brand": "TANG",
      "unit": "PC"
    });
    await txn.insert("feedstocks", {
      "name": "Suco de maracujá",
      "price": 1.35,
      "brand": "TANG",
      "unit": "PC"
    });
    await txn.insert("feedstocks",
        {"name": "Suco de uva", "price": 1.35, "brand": "TANG", "unit": "PC"});
    await txn.insert("feedstocks",
        {"name": "Chocolate", "price": 8, "brand": "NESTLÉ", "unit": "PC"});
    await txn.insert("feedstocks", {
      "name": "Leite condensado",
      "price": 4.25,
      "brand": "NESTLÉ",
      "unit": "PT"
    });
    await txn.insert("feedstocks",
        {"name": "BIS", "price": 6.25, "brand": "BIS", "unit": "CX"});
    await txn.insert("feedstocks",
        {"name": "Leite", "price": 3, "brand": "IV", "unit": "LT"});
    await txn.insert("feedstocks",
        {"name": "Açucar", "price": 18.95, "brand": "Bruçucar", "unit": "ML"});
    await txn.insert("feedstocks", {
      "name": "Barra de chocolate",
      "price": 28.95,
      "brand": "NESTLÉ",
      "unit": "ML"
    });
    await txn.insert("feedstocks", {
      "name": "Leite condensado",
      "price": 7.2,
      "brand": "CEMIL",
      "unit": "CX"
    });
    await txn.insert("feedstocks", {
      "name": "Vinho tinto suave",
      "price": 12.8,
      "brand": "",
      "unit": "UND"
    });
    await txn.insert("feedstocks",
        {"name": "Caipirinha", "price": 13, "brand": "", "unit": "UND"});
    await txn.insert("feedstocks",
        {"name": "Licor", "price": 18, "brand": "", "unit": "UND"});
    await txn.insert("feedstocks",
        {"name": "Vodka", "price": 14, "brand": "", "unit": "UND"});
    await txn.insert("feedstocks",
        {"name": "Suco de abacaxi", "price": 1, "brand": "MID", "unit": "PC"});
  });
}
