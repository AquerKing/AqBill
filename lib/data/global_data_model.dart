import 'dart:convert';
import 'dart:io';

import 'package:bill/data/transaction_model.dart';
import 'package:bill/extension/date_getter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:path_provider/path_provider.dart';

/// 全局数据模型
class GlobalDataModel extends ChangeNotifier {
  static final GlobalDataModel _instance = GlobalDataModel._internal();
  factory GlobalDataModel() => _instance;
  GlobalDataModel._internal();

  // static const String _dataPath = '.aqbill/';
  static const Map<String, String> _dataFileManifest = {
    'UserData': 'user_data.json',
    'UserConfig': 'user_config.json',
    'AppData': 'app_data.json',
  };

  /// 配置项Json表
  final Map<String, Map<String, dynamic>> _globalJson =
      <String, Map<String, dynamic>>{
        'UserConfig': {
          'app.lang': 'en-US',
          'currency.sign': '¥',
          'user.name': 'User',
          'user.join_time': DateGetter.getTodaysFormattedDateString(),
          'app.theme': 'light',
        },
        'UserData': {
          'earn.current': 0,
          'earn.target': 0,
          'cost.current': 0,
          'budget.init': 200000,
        },
        'AppData': {'app.last_run': 202009, 'data.last_archived_year': 2020},
      };

  // 生命周期观察者
  final _appLifecycleObserver = _AppLifecycleObserver();

  void initLifecycleListener() {
    WidgetsBinding.instance.addObserver(_appLifecycleObserver);
  }

  // 销毁时移除监听（避免内存泄漏）
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_appLifecycleObserver);
    super.dispose();
  }

  void insertRecord(TransactionModel model) {
    int nowTime = DateGetter.getTodaysYMNumber();
    if (nowTime != model.date ~/ 100) {
      return;
    }

    if (model.isExpense) {
      _globalJson['UserData']!['cost.current'] += model.amount;
    } else {
      _globalJson['UserData']!['earn.current'] += model.amount;
    }

    saveFile('UserData');
    notifyListeners();
  }

  void revertRecord(TransactionModel model) {
    DateTime today = DateTime.now();
    if (model.date ~/ 100 != today.year * 100 + today.month) {
      return;
    }

    if (model.isExpense) {
      _globalJson['UserData']!['cost.current'] -= model.amount;
    } else {
      _globalJson['UserData']!['earn.current'] -= model.amount;
    }

    saveFile('UserData');
    notifyListeners();
  }

  void updateRecord(TransactionModel model, TransactionModel oldModel) {
    int amount = model.amount;
    int oldAmount = oldModel.amount;

    if (model.isExpense && oldModel.isExpense) {
      _globalJson['UserData']!['cost.current'] += amount - oldAmount;
    } else if (model.isExpense) {
      _globalJson['UserData']!['cost.current'] += amount;
      _globalJson['UserData']!['earn.current'] -= oldAmount;
    } else if (oldModel.isExpense) {
      _globalJson['UserData']!['earn.current'] += amount;
      _globalJson['UserData']!['cost.current'] -= oldAmount;
    } else {
      _globalJson['UserData']!['earn.current'] += amount - oldAmount;
    }

    saveFile('UserData');
    notifyListeners();
  }

  /// 获取指定配置、指定字段值
  T? get<T>(String alias, String field) {
    if (!_dataFileManifest.containsKey(alias)) {
      return null;
    }
    if (!_globalJson[alias]!.containsKey(field)) {
      return null;
    }
    final value = _globalJson[alias]![field];
    return value is T ? value : null;
  }

  /// 设置指定配置、指定字段的值
  bool set<T>(String alias, String field, dynamic value) {
    if (!_dataFileManifest.containsKey(alias)) {
      return false;
    }
    if (!_globalJson[alias]!.containsKey(field)) {
      return false;
    }
    if (value is! T) {
      return false;
    }
    _globalJson[alias]![field] = value;
    saveFile(alias);

    notifyListeners();
    return true;
  }

  void resetMonthData() {
    _globalJson['UserData']!['earn.current'] = 0;
    _globalJson['UserData']!['cost.current'] = 0;
    notifyListeners();
  }

  Future<void> _ensureFilesExist() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    if (!await directory.exists()) {
      directory.create(recursive: true);
    }

    _dataFileManifest.forEach((key, value) async {
      final File file = File('${directory.path}/$value');
      if (!await file.exists()) {
        if (!await file.parent.exists()) {
          await file.parent.create(recursive: true);
        }
      }

      await file.create();
    });
  }

  Future<void> loadFromFiles() async {
    await _ensureFilesExist();

    final directory = await getApplicationDocumentsDirectory();

    String rawContent = '';
    Map<String, dynamic> jsonMap = {};

    // 读取 UserData
    File targetFile = File(
      '${directory.path}/${_dataFileManifest['UserData']}',
    );
    rawContent = await targetFile.readAsString();
    if (rawContent.isEmpty) {
      return;
    }
    jsonMap = json.decode(rawContent);
    _globalJson['UserData']!.addAll(jsonMap);

    // 读取 UserConfig
    targetFile = File('${directory.path}/${_dataFileManifest['UserConfig']}');
    rawContent = await targetFile.readAsString();
    if (rawContent.isEmpty) {
      return;
    }
    jsonMap = json.decode(rawContent);
    _globalJson['UserConfig']!.addAll(jsonMap);

    // 读取 AppData
    targetFile = File('${directory.path}/${_dataFileManifest['AppData']}');
    rawContent = await targetFile.readAsString();
    if (rawContent.isEmpty) {
      return;
    }
    jsonMap = json.decode(rawContent);
    _globalJson['AppData']!.addAll(jsonMap);

    notifyListeners();
  }

  Future<void> saveToFiles() async {
    _ensureFilesExist();

    final directory = await getApplicationDocumentsDirectory();

    // 写入 UserData
    File targetFile = File(
      '${directory.path}/${_dataFileManifest['UserData']}',
    );
    targetFile.writeAsString(json.encode(_globalJson['UserData']), flush: true);

    // 写入 UserConfig
    targetFile = File('${directory.path}/${_dataFileManifest['UserConfig']}');
    targetFile.writeAsString(
      json.encode(_globalJson['UserConfig']),
      flush: true,
    );
  }

  Future<void> _ensureFileExists(String alias) async {
    if (!_dataFileManifest.containsKey(alias)) {
      return;
    }

    final Directory directory = await getApplicationDocumentsDirectory();
    if (!await directory.exists()) {
      directory.create(recursive: true);
    }

    final File file = File('${directory.path}/${_dataFileManifest[alias]}');
    if (!await file.exists()) {
      if (!await file.parent.exists()) {
        await file.parent.create(recursive: true);
      }
    }

    await file.create();
  }

  /// 将指定配置项写入对应文件
  Future<void> saveFile(String alias) async {
    if (!_dataFileManifest.containsKey(alias)) {
      logger.error('Cannot save unknown configure-\'$alias\'.');
      return;
    }

    await _ensureFileExists(alias);

    final directory = await getApplicationDocumentsDirectory();

    File targetFile = File('${directory.path}/${_dataFileManifest[alias]}');
    targetFile.writeAsString(json.encode(_globalJson[alias]), flush: true);
  }

  void checkLastRunTime() {
    final int todayYMNumber = DateGetter.getTodaysYMNumber();
    if (todayYMNumber != _globalJson['AppData']!['app.last_run']) {
      resetMonthData();
      _globalJson['AppData']!['app.last_run'] = todayYMNumber;
      GlobalDataModel().saveFile('AppData');
    }
  }

  /// 从映射文件中读取指定配置项
  Future<void> readFile(String alias) async {
    if (!_dataFileManifest.containsKey(alias)) {
      logger.error('Cannot read unknown configure-\'$alias\'.');
      return;
    }

    await _ensureFileExists(alias);

    final directory = await getApplicationDocumentsDirectory();
    File targetFile = File('${directory.path}/${_dataFileManifest[alias]}');
    String rawContent = await targetFile.readAsString();
    if (rawContent.isEmpty) {
      return;
    }
    Map<String, dynamic> jsonMap = json.decode(rawContent);
    _globalJson[alias]!.addAll(jsonMap);
  }

  void notifyListenersManually() {
    notifyListeners();
  }

  Future<void> clearTodaysTransactions() async {
    _globalJson['UserData']!['cost.current'] = 0;
    _globalJson['UserData']!['earn.current'] = 0;
    saveFile('UserData');

    notifyListeners();
  }

  String getJson(String alias) {
    if (!_dataFileManifest.containsKey(alias)) {
      return '';
    }

    return json.encode(_globalJson[alias]!);
  }
}

class _AppLifecycleObserver with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 当应用进入后台（paused）或即将销毁（detached）时保存数据
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      GlobalDataModel().saveToFiles(); // 调用保存方法
    }
  }
}
