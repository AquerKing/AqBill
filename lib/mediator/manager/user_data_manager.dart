import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:bill/data/global_data_model.dart';
import 'package:bill/data/transaction_model.dart';
import 'package:bill/extension/date_getter.dart';
import 'package:bill/extension/zip_utils.dart';
import 'package:bill/mediator/manager/database_agent.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:path_provider/path_provider.dart';

class UserDataManager {
  UserDataManager._internal();
  static final UserDataManager _instance = UserDataManager._internal();
  factory UserDataManager() => _instance;

  static const String backupStoragePath = 'backup/';
  static const String archiveStoragePath = 'archive/';

  Future<void> checkBackupFolder() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    if (!await directory.exists()) {
      directory.create(recursive: true);
    }

    final Directory backupFolder = Directory(
      '${directory.path}/$backupStoragePath',
    );
    if (!await backupFolder.exists()) {
      if (!await backupFolder.parent.exists()) {
        await backupFolder.parent.create(recursive: true);
      }
    }
    await backupFolder.create();

    final Directory archiveFolder = Directory(
      '${directory.path}/$archiveStoragePath',
    );
    if (!await archiveFolder.exists()) {
      if (!await archiveFolder.exists()) {
        await archiveFolder.parent.create(recursive: true);
      }
    }
    await archiveFolder.create();
  }

  /// 创建指定年份的归档文件
  Future<void> createYearArchive(int year) async {
    List<Map<String, dynamic>> records = await DatabaseAgent().fetchByDate(
      '${year}0000',
    );

    if (records.isEmpty) {
      return;
    }

    final Map<String, dynamic> archiveMetadata = {
      'year': year,
      'create_time': DateGetter.getTodaysDateNumber(),
      'records_count': records.length,
    };

    Map<String, String> contentToBeArchived = {
      'meta.json': json.encode(archiveMetadata),
      'data.json': json.encode(records),
    };

    final Archive archive = Archive();
    await ZipUtils.writeToArchive(archive, contentToBeArchived);

    final zipBytes = ZipEncoder().encode(archive);
    final Directory directory = await getApplicationDocumentsDirectory();
    final File archiveFile = File(
      "${directory.path}/$archiveStoragePath/archive_$year.zip",
    );
    if (!await archiveFile.exists()) {
      archiveFile.create();
      await archiveFile.writeAsBytes(zipBytes);
      logger.info('Records archived. (Year: $year)');
    } else {
      logger.info('Records has been archived. Skipped. (Year: $year)');
    }
  }

  /// 创建用户数据的完整备份
  Future<void> backupUserData() async {
    final Directory applicationDataDirectory =
        await getApplicationDocumentsDirectory();
    final Directory archiveDirectory = Directory(
      '${applicationDataDirectory.path}/$archiveStoragePath',
    );
    final int dateNumber = DateGetter.getTodaysDateNumber();
    final File backupArchiveFile = File(
      '${applicationDataDirectory.path}/$backupStoragePath/backup_$dateNumber.zip',
    );
    if (!await backupArchiveFile.exists()) {
      backupArchiveFile.create();
    }
    final backupArchive = Archive();
    Map<String, String> backupContent = {};

    // 备份用户数据和配置
    backupContent.addEntries(
      <String, String>{
            'user_data.json': GlobalDataModel().getJson('UserData'),
            'user_config.json': GlobalDataModel().getJson('UserConfig'),
          }
          as Iterable<MapEntry<String, String>>,
    );

    // 获取所有未归档的记录
    List<Map<String, dynamic>> nonArchivedRecords =
        await DatabaseAgent().fetchAllRecords();
    backupContent.addEntries(
      <String, String>{'data.json': json.encode(nonArchivedRecords)}
          as Iterable<MapEntry<String, String>>,
    );

    // 获取所有归档记录
    // TODO

    // 写入备份文件
    ZipUtils.writeToArchive(backupArchive, backupContent);
    final zipBytes = ZipEncoder().encode(backupArchive);
    await backupArchiveFile.writeAsBytes(zipBytes);
  }

  Future<void> checkLastRunTime() async {
    int lastRunTime = GlobalDataModel().get('AppData', 'app.last_run');
    int nowTime = DateGetter.getTodaysYMNumber();
    if (nowTime < lastRunTime) {
      logger.error('Something went wrong, the launch time was impossible.');
    } else {
      int lastRunYear = lastRunTime ~/ 100, nowYear = nowTime ~/ 100;
      int lastRunMonth = lastRunTime % 100, nowMonth = nowTime % 100;

      // 备份三年以前的数据
      for (
        int i = GlobalDataModel().get('AppData', 'data.last_archived_year') + 1;
        i <= nowYear - 3;
        ++i
      ) {
        await createYearArchive(i);
        await DatabaseAgent().deleteYearTransaction(i);
      }
      GlobalDataModel().set('AppData', 'data.last_archived_year', nowYear - 3);

      // 检查是否为同一个月
      if (lastRunYear == nowYear && lastRunMonth == nowMonth) {
        return;
      } else {
        GlobalDataModel().resetMonthData();
      }
    }
    GlobalDataModel().set('AppData', 'app.last_run', nowTime);
    GlobalDataModel().saveFile('AppData');
  }
}
