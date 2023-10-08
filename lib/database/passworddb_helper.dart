//passworddb_helper.dart
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE passwords(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        networkName TEXT,
        usernameOrEmail TEXT,
        password TEXT,
        description TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'password.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // creating new entry
  static Future<int> createEntry(String? networkName, String? usernameOrEmail,
      String? password, String? description) async {
    final db = await SQLHelper.db();

    final data = {
      'networkName': networkName,
      'usernameOrEmail': usernameOrEmail,
      'password': password,
      'description': description
    };
    final id = await db.insert('passwords', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // retrieve entries
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('passwords', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('passwords', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateEntry(int id, String? networkName,
      String? usernameOrEmail, String? password, String? description) async {
    final db = await SQLHelper.db();

    final data = {
      'networkName': networkName,
      'usernameOrEmail': usernameOrEmail,
      'password': password,
      'description': description,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('passwords', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteEntry(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("passwords", where: "id = ?", whereArgs: [id]);
    } catch (error) {
      debugPrint("Entry deletion failed. Try again: $error");
    }
  }
}
