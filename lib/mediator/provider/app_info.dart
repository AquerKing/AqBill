import 'package:package_info_plus/package_info_plus.dart';

class AppData {
  static void loadPackageInfo(PackageInfo info) {
    buildNumber = info.buildNumber;
    version = info.version;
  }

  static String applicationName = 'AqBill';
  static String buildNumber = '1';
  static String version = '1.0.0';
  static String developer = 'AquerKing';
  static String email = 'aquerking@126.com';
  static String copyright = '© 2025 All Rights Reserved';
  static List<String> contributors = [];
  static String website = 'https://gitee.com/AquerKing/aq-bill.git';
}
