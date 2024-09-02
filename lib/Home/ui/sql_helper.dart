import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

class SqlHelper {
  static Future<void> createTables(sql.Database database) async {
    return await database.execute("""
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        isFav INTEGER
      )
    """);
  }

  // Creating a database
  static Future<sql.Database> db() async {
    return sql.openDatabase(join(await getDatabasesPath(), 'demo.db'),
        version: 1, onCreate: (database, int version) async {
      await createTables(database);
    });
  }

  static Future<int> createItem(String title, String? description) async {
    final db = await SqlHelper.db();

    final data = {'title': title, 'description': description};
    final id = await db.insert(
      'items',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SqlHelper.db();
    return db.query('items', orderBy: 'id');
  }

  // Get item by id
  static Future<List<Map<String, dynamic>>> getItemById(int id) async {
    final db = await SqlHelper.db();
    return db.query('items', where: 'id = ?', whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getItemByisFav() async {
    final db = await SqlHelper.db();
    return db.query(
      'items',
      where: 'isFav = ?',
      whereArgs: [1],
    );
  }

  // Updating the item
  static Future<int> updateItem(
      int id, String title, String? description, int? isFav) async {
    final db = await SqlHelper.db();

    final data = {
      'title': title,
      'description': description,
      'isFav': isFav,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('items', data, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  // Deleting the item from the database
  static Future<void> deleteItem(int id) async {
    final db = await SqlHelper.db();

    try {
      await db.delete('items', where: 'id = ?', whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting item : $err");
    }
  }
}
