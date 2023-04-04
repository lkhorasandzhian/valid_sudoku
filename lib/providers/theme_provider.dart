import 'package:flutter/material.dart';
import 'package:valid_sudoku/resources/themes.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkTheme = false;
  var _themeMode = AppThemes.lightTheme;

  bool get isDarkTheme => _isDarkTheme;
  ThemeData get themeMode => _themeMode;

  void changeTheme() {
    _isDarkTheme = !_isDarkTheme;
    _themeMode = _themeMode == AppThemes.lightTheme ? AppThemes.darkTheme : AppThemes.lightTheme;
    notifyListeners();
  }
}
