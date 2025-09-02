import 'package:bill/data/bill_themes.dart';
import 'package:bill/data/global_data_model.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  static final ThemeProvider _instance = ThemeProvider._internal();
  factory ThemeProvider() => _instance;
  ThemeProvider._internal();

  Map<String, dynamic> theme = themes['light']!;

  void updateFromConfig() {
    theme = themes[GlobalDataModel().get('UserConfig', 'app.theme')]!;

    notifyListeners();
  }

  void changeTheme(String themeName) {
    if (themes.containsKey(themeName)) {
      theme = themes[themeName]!;
      notifyListeners();
    }
  }
}
