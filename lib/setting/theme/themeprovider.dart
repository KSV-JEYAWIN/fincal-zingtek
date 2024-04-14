import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeType { light, dark }

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = ThemeData.light();
  ThemeType _themeType = ThemeType.light;

  ThemeData get themeData => _themeData;

  ThemeType get themeType => _themeType;

  ThemeProvider() {
    _loadThemeType();
  }

  Future<void> _loadThemeType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? themeTypeString = prefs.getString('themeType');
    if (themeTypeString != null) {
      _themeType = ThemeType.values.firstWhere(
          (type) => type.toString() == 'ThemeType.' + themeTypeString);
      setTheme(_themeType);
    }
  }

  Future<void> setTheme(ThemeType themeType) async {
    _themeType = themeType;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeType', themeType.toString().split('.').last);

    if (themeType == ThemeType.light) {
      _themeData = ThemeData.light();
    } else {
      _themeData = ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: Colors.white,
            ),
      );
    }
    notifyListeners();
  }
}
