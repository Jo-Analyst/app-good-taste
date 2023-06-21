import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DB {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, "icecream.db"),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE juices(id integer PRIMARY KEY, name TEXT, brand TEXT, price REAL)", 
          // juice - Suco
          // brand - marca
        );
      },
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
