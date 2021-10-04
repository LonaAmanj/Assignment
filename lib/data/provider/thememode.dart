import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyThemeMode extends ChangeNotifier {
  ThemeMode _thememode = ThemeMode.light;

  change() {
    if (_thememode == ThemeMode.light) {
      _thememode = ThemeMode.dark;
    } else if (_thememode == ThemeMode.dark) {
      _thememode = ThemeMode.light;
    }

    notifyListeners();
  }

  get thememode => _thememode;
}
