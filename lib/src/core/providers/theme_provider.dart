import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  String _currentTheme;

  String get currentTheme => _currentTheme;

  ThemeProvider() {
    getTheme();
  }

  void getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentTheme = (prefs.getString('theme') ?? 'light');
    _currentTheme = currentTheme;
    notifyListeners();
  }

  void changeTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_currentTheme == 'light') {
      _currentTheme = 'dark';
      await prefs.setString('theme', _currentTheme);
    } else {
      _currentTheme = 'light';
      await prefs.setString('theme', _currentTheme);
    }
    notifyListeners();
  }
}
