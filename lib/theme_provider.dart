import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode;

  ThemeProvider(bool isDarkTheme) : _themeMode = isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  ThemeData getTheme() => _themeMode == ThemeMode.dark ? darkTheme : lightTheme;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
  );
}