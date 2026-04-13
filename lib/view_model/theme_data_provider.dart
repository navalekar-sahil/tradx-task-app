import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode;

  ThemeProvider(this._themeMode);

  ThemeMode get themeMode => _themeMode;

  void setTheme(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', mode.name);
  }

  static Future<ThemeMode> loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedTheme = prefs.getString('theme');

    if (savedTheme != null) {
      return ThemeMode.values.firstWhere(
            (e) => e.name == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }
    return ThemeMode.system;
  }
}