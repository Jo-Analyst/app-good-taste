import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DB {
  static Future<sql.Database> openDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, "goodtaste.db"),
      onCreate: (db, version) {
        // brand - marca
        // flavors - sabores
        // raw_materials - matérias-primas

        db.execute(
          "CREATE TABLE feedstocks (id INTEGER PRIMARY KEY, name TEXT NOT NULL, brand TEXT NULL, price REAL NOT NULL, unit TEXT NOT NULL)",
        );
        db.execute(
          'CREATE TABLE products (id INTEGER PRIMARY KEY, name TEXT NOT NULL, price REAL)',
        );
        db.execute(
          'CREATE TABLE flavors (id INTEGER PRIMARY KEY, type TEXT NOT NULL, product_id INTEGER, FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE)',
        );

        db.execute(
          'CREATE TABLE productions (id INTEGER PRIMARY KEY, quantity INTEGER NOT NULL, value_entry REAL, value_leave REAL NOT NULL, value_profit REAL, price_product, date TEXT, flavor_id INTEGER, FOREIGN KEY (flavor_id) REFERENCES flavors(id) ON DELETE SET NULL)',
        );

        db.execute(
          'CREATE TABLE items_productions (id INTEGER PRIMARY KEY, price_feedstock REAL, feedstock_id INTEGER, production_id INTEGER, FOREIGN KEY (feedstock_id) REFERENCES feedstocks(id) ON DELETE SET NULL, FOREIGN KEY (production_id) REFERENCES productions(id) ON DELETE CASCADE)',
        );
      },
      version: 1,
    );
  }
}
