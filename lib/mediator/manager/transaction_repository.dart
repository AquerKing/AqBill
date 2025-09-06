import 'dart:core';

import 'package:bill/extension/date_getter.dart';
import 'package:flutter/material.dart';

import 'package:bill/data/transaction_model.dart';
import 'package:bill/mediator/manager/database_agent.dart';

class TransactionRepository extends ChangeNotifier {
  TransactionRepository._internal();
  static final TransactionRepository _instance =
      TransactionRepository._internal();
  factory TransactionRepository() => _instance;

  // final LruCache<String, List<TransactionModel>> _lruCache =
  //     LruCache<String, List<TransactionModel>>(maxSize: 64);

  List<TransactionModel> _todaysRecords = [];

  List<TransactionModel> periodicRecords = [];
  int periodNumber = DateGetter.getTodayDateNumber();

  int get count {
    return _todaysRecords.length;
  }

  List<TransactionModel> get records {
    return _todaysRecords;
  }

  Future<void> updateTodaysRecords() async {
    List<Map<String, dynamic>> rawRecords = await fetchByDate(
      DateGetter.getTodaysDateString(),
    );

    _todaysRecords =
        rawRecords.map((element) {
          return TransactionModel.fromMap(element);
        }).toList();

    notifyListeners();
  }

  Future<void> updatePeridicRecords() async {
    if (DateGetter.getTodayDateNumber() == periodNumber) {
      periodicRecords = _todaysRecords;
    }
    else {
      periodicRecords = await fetchByPeriod(periodNumber);
    }
    notifyListeners();
  }

  Future<void> updateRecords() async {
    await updateTodaysRecords();
    updatePeridicRecords();
  }

  Future<List<TransactionModel>> fetchTodaysRecords() async {
    List<Map<String, dynamic>> rawRecords = await fetchByDate(
      DateGetter.getTodaysDateString(),
    );

    return rawRecords.map((element) {
      return TransactionModel.fromMap(element);
    }).toList();
  }

  /// 获取指定日期的交易记录
  Future<List<Map<String, dynamic>>> fetchByDate(String dateString) async {
    // if (_lruCache.containsKey(dateString)) {
    //   return _lruCache.get(dateString)!;
    // }

    return await DatabaseAgent().fetchByDate(dateString);
  }

  /// 获取指定日期段的交易记录
  Future<void> updateByPeriod(int period) async {
    List<Map<String, dynamic>> rawRecords = await DatabaseAgent().fetchByDate(
      period.toString(),
    );

    if (rawRecords.isEmpty) {
      periodicRecords = [];
      notifyListeners();
      return;
    }

    List<TransactionModel> records =
        rawRecords.map((element) {
          return TransactionModel.fromMap(element);
        }).toList();

    periodicRecords = records;
    notifyListeners();
  }

  /// 获取指定日期段的交易记录
  Future<List<TransactionModel>> fetchByPeriod(int period) async {
    List<Map<String, dynamic>> rawRecords = await DatabaseAgent().fetchByDate(
      period.toString(),
    );

    if (rawRecords.isEmpty) {
      return [];
    }

    List<TransactionModel> records =
        rawRecords.map((element) {
          return TransactionModel.fromMap(element);
        }).toList();

    return records;
  }

  List<TransactionModel> fetchByCategory() {
    notifyListeners();
    return [];
  }
}
