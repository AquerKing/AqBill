import 'dart:convert';
import 'dart:io';

import 'package:bill/data/category_model.dart';
import 'package:bill/data/transaction_model.dart';
import 'package:bill/manager/category_manager.dart';
import 'package:bill/manager/transcation_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseAgent {
  DatabaseAgent._internal();
  static final DatabaseAgent _instance = DatabaseAgent._internal();
  factory DatabaseAgent() => _instance;

  final String _transactionDatabaseName = 'trans_data.db';
  final String _transactionTableName = 'trans';
  final String _categoryTableName = 'category';
  final int _databaseVersion = 1;

  Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    if (!await directory.exists()) {
      directory.create(recursive: true);
    }
    String path = '${directory.path}/data/$_transactionDatabaseName';
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    // await db.execute('''
    //     CREATE TABLE IF NOT EXISTS $_categoryTableName (
    //       id INTEGER PRIMARY KEY,
    //       model TEXT NOT NULL UNIQUE
    //     )
    //   ''');

    await db.execute('''
        CREATE TABLE IF NOT EXISTS $_transactionTableName (
          id INTEGER PRIMARY KEY,
          category INTEGER NOT NULL,
          amount INTEGER NOT NULL,
          date INTEGER NOT NULL,
          comment TEXT
        )
      ''');

    // The following code is temporarily deprecrated.
    // ----------------------------------------------
    // FOREIGN KEY (category) REFERENCES $_categoryTableName (id)

    // Iterable categories = CategoryManager().categories;
    // for (CategoryModel model in categories) {
    //   await db.insert(_categoryTableName, {
    //     'id': model.id,
    //     'model': json.encode(model.toMap()),
    //   });
    // }
  }

  Future<int> insertTransaction(TransactionModel record) async {
    Database db = await _instance.database;
    return await db.insert(_transactionTableName, record.toMap());
  }

  Future<void> deleteTransaction(TransactionModel record) async {
    Database db = await _instance.database;
    await db.delete(
      _transactionTableName,
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final Database db = await _instance.database;
    List<Map<String, dynamic>> categories = await db.query(_categoryTableName);
    return categories;
  }

  Future<List<Map<String, dynamic>>> fetchByDate(String date) async {
    Database db = await _instance.database;
    List<Map<String, dynamic>> records = await db.query(
      _transactionTableName,
      where: 'date = ?',
      whereArgs: [TranscationRepository().getCurrentDateString()],
    );
    return records;
  }
}
