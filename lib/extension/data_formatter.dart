import 'package:bill/data/global_data_model.dart';
import 'package:flutter/widgets.dart';

abstract class DataFormatter {
  static String getAmountLocaleString(int amount) {
    bool isNegative = amount < 0;
    String integer = (amount ~/ 100).abs().toString();
    String fraction =
        amount.abs() < 100
            ? amount.abs().toString()
            : (amount.abs() % 100).toString();
    fraction = fraction.padLeft(2, '0');
    String amountString = '$integer.$fraction';
    amountString = formatAmountStringByLocale(amountString);
    return '${isNegative ? '-' : ''}${GlobalDataModel().get('UserConfig', 'currency.sign')}$amountString';
  }

  static String convertAmountToString(int amount) {
    bool isNegative = amount < 0;
    String integer = (amount ~/ 100).abs().toString();
    String fraction =
        amount < 100 ? amount.toString() : (amount % 100).toString();

    fraction = fraction.padLeft(2, '0');

    return '${isNegative ? '-' : ''}$integer.$fraction';
  }

  /// 按照地区习惯格式化Amount字符串
  /// 目前支持如下：
  ///   - 'zh': 中国
  ///   - 'en': 美国
  static String formatAmountStringByLocale(
    String amountString, {
    String locale = 'en',
  }) {
    bool isNegative = amountString[0] == '-';
    if (isNegative) {
      amountString = amountString.substring(1);
    }
    List<String> results = amountString.split('.');
    int interval = 3;

    switch (locale) {
      case 'en':
        interval = 3;
        break;
      case 'zh':
        interval = 4;
        break;
    }

    if (results.length != 2) {
      return amountString;
    }

    String reversed = results[0].split('').reversed.join('');
    String added = '';
    int count = 1;
    for (String ch in reversed.characters) {
      if (count % (interval + 1) == 0) {
        added += ',';
        count = 1;
      }
      added += ch;
      ++count;
    }

    String res =
        '${isNegative ? '-' : ''}${added.split('').reversed.join('')}.${results[1]}';
    return res;
  }

  static formatDate(int date) {
    String dateString = date.toString();
    return '${dateString.substring(0, 4)}/${dateString.substring(4, 6)}/${dateString.substring(6, 8)}';
  }
}
