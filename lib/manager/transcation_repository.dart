import 'dart:core';

import 'package:flutter/material.dart';

import 'package:bill/data/transaction_model.dart';
import 'package:bill/extension/lru_cache.dart';
import 'package:bill/manager/database_agent.dart';

class TranscationRepository extends ChangeNotifier {
  TranscationRepository._internal();
  static final TranscationRepository _instance =
      TranscationRepository._internal();
  factory TranscationRepository() => _instance;

  // final LruCache<String, List<TransactionModel>> _lruCache =
  //     LruCache<String, List<TransactionModel>>(maxSize: 64);

  List<TransactionModel> _records = [];

  int get count {
    return _records.length;
  }

  List<TransactionModel> get records {
    return _records;
  }

  Future<void> updateTodaysRecords() async {
    List<Map<String, dynamic>> rawRecords = await fetchByDate(
      getCurrentDateString(),
    );

    _records =
        rawRecords.map((element) {
          return TransactionModel.fromMap(element);
        }).toList();

    notifyListeners();
  }

  Future<List<TransactionModel>> fetchTodaysRecords() async {
    List<Map<String, dynamic>> rawRecords = await fetchByDate(
      getCurrentDateString(),
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
  List<TransactionModel> fetchByPeriod({String? start, String? end}) {
    notifyListeners();
    return [];
  }

  List<TransactionModel> fetchByCategory() {
    notifyListeners();
    return [];
  }

  String getCurrentDateString() {
    DateTime dateTime = DateTime.now();
    String year = dateTime.year.toString().padLeft(4, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String day = dateTime.day.toString().padLeft(2, '0');
    return "$year$month$day";
  }
}
