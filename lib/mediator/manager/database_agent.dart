import 'dart:io';

import 'package:bill/data/transaction_model.dart';
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

  Future<void> deleteYearTransaction(int year) async {
    Database db = await _instance.database;
    await db.delete(
      _transactionTableName,
      where: 'date >= ? AND date <= ?',
      whereArgs: [int.parse('${year}0101'), int.parse('${year}1231')],
    );
  }

  Future<void> modifyTransaction(int id, TransactionModel record) async {
    Database db = await _instance.database;
    await db.update(
      _transactionTableName,
      record.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> queryTransactionCountByDate(String date) async {
    return (await fetchByDate(date)).length;
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final Database db = await _instance.database;
    List<Map<String, dynamic>> categories = await db.query(_categoryTableName);
    return categories;
  }

  Future<List<Map<String, dynamic>>> fetchByDate(String date) async {
    String year = date.substring(0, 4),
        month = date.substring(4, 6),
        day = date.substring(6, 8);

    Database db = await _instance.database;
    List<Map<String, dynamic>> records = [];
    if (month != '00' && day != '00') {
      records = await db.query(
        _transactionTableName,
        where: 'date = ?',
        whereArgs: [int.parse(date)],
      );
    } else if (month == '00') {
      records = await db.query(
        _transactionTableName,
        where: 'date >= ? AND date <= ?',
        whereArgs: [int.parse('${year}0101'), int.parse('${year}1231')],
      );
    } else {
      records = await db.query(
        _transactionTableName,
        where: 'date >= ? AND date <= ?',
        whereArgs: [int.parse('$year${month}01'), int.parse('$year${month}31')],
      );
    }
    return records;
  }

  Future<List<Map<String, dynamic>>> fetchAllRecords() async {
    final Database db = await _instance.database;

    return await db.query(_transactionDatabaseName);
  }

  /// 获取给定时间区间的所有记录
  ///
  /// `dateStart`: 起始日期，格式应当为八位数字字符串 \
  /// `dateEnd`: 终止日期
  // Future<List<Map<String, dynamic>>> fetchByPeriod(
  //   String dateStart,
  //   String dateEnd,
  // ) async {
  //   String year = date.substring(0, 4),
  //       month = date.substring(4, 6),
  //       day = date.substring(6, 8);

  //   Database db = await _instance.database;
  //   List<Map<String, dynamic>> records = [];
  //   if (month != '00' && day != '00') {
  //     records = await db.query(
  //       _transactionTableName,
  //       where: 'date = ?',
  //       whereArgs: [int.parse(date)],
  //     );
  //   } else if (month == '00') {
  //     records = await db.query(
  //       _transactionTableName,
  //       where: 'date >= ? AND date <= ?',
  //       whereArgs: [int.parse('${year}0101'), int.parse('${year}1231')],
  //     );
  //   } else {
  //     records = await db.query(
  //       _transactionTableName,
  //       where: 'date >= ? AND date <= ?',
  //       whereArgs: [int.parse('$year${month}01'), int.parse('$year${month}31')],
  //     );
  //   }
  //   return records;
  // }
}
