import 'package:path/path.dart' as storage;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class DataBase {
  static Future<Database> openTransactionDataBase() async {
    // getting the path of storage location on device
    final dbPath = await sql.getDatabasesPath();

    // opening the databse
    return sql.openDatabase(
      storage.join(dbPath, 'expenses.db'),
      version: 1,
      onCreate: (db, version) => db.execute(
          'CREATE TABLE expenses(id TEXT PRIMARY KEY,title TEXT,amount REAL,date TEXT)'),
    );
  }

  static Future<void> addTransaction(
      String table, Map<String, dynamic> arguments) async {
    final db = await DataBase.openTransactionDataBase();
    db.insert(table, arguments,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DataBase.openTransactionDataBase();
    return db.query(table);
  }

  static Future<void> deleteTransaction(String id) async {
    final db = await DataBase.openTransactionDataBase();
    await db.delete('expenses', where: 'id=?', whereArgs: [id]);
  }

  static Future<Database> openSavingsDatabase() async {
    final savingsDBPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      storage.join(savingsDBPath, 'saving.db'),
      version: 1,
      onCreate: (db, version) => db.execute(
          'CREATE TABLE saving(id TEXT PRIMARY KEY,savingFor TEXT,targetAmount REAL,amountSaved REAL,amountToBeSaved REAL,startingDate TEXT,endingDate TEXT)'),
    );
  }

  static Future<void> addSavingScheme(
      String table, Map<String, dynamic> arguments) async {
    final db = await DataBase.openSavingsDatabase();
    db.insert(table, arguments,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getSavingsData(String table) async {
    final db = await DataBase.openSavingsDatabase();

    return (await db.query(table));
  }

  static Future<void> deleteSavingPlan(String id) async {
    final db = await DataBase.openSavingsDatabase();
    await db.delete('saving', where: 'id=?', whereArgs: [id]);
  }
}
