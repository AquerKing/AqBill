import 'package:flutter/material.dart';

final List<String> supportLanguage = ['en-US', 'zh-CN'];
final Map<String, String> languageDisplayName = {
  'en-US': 'English',
  'zh-CN': '简体中文',
};

class LocaleProvider extends ChangeNotifier {
  static final LocaleProvider _instance = LocaleProvider._internal();
  factory LocaleProvider() => _instance;
  LocaleProvider._internal();

  Locale currentLocale = Locale('en', 'US');

  void changeLocale(String localeString) {
    List<String> res = localeString.split('-');
    if (res.length != 2) {
      return;
    }
    currentLocale = Locale(res[0], res[1]);

    notifyListeners();
  }
}
