import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DB {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, "icecream.db"),
      onCreate: (db, version) {
        // return db.execute(
        //   "CREATE TABLE products (id INTEGER PRIMARY KEY, name TEXT NOT NULL, brand TEXT NULL, price REAL NOT NULL)",
        //   // brand - marca
        //   // flavors - sabores
        // );
        db.execute(
          "CREATE TABLE products (id INTEGER PRIMARY KEY, name TEXT NOT NULL, brand TEXT NULL, price REAL NOT NULL)",
        );
        db.execute(
          'CREATE TABLE flavors (id INTEGER PRIMARY KEY, type TEXT NOT NULL)',
        );

        db.execute('CREATE TABLE productions (id INTEGER PRIMARY KEY, quantity INTEGER NOT NULL, date_production TEXT)');
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DB.database();
    await db.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DB.database();
    return db.query(table);
  }
}
