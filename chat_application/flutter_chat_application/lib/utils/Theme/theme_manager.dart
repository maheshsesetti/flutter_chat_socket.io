import 'package:flutter/material.dart';

class ThemeManage {
  static ThemeManage? _instance;
  ThemeData? _themeData;

  ThemeManage._internal() {
    _themeData = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: "OpenSans",
      primaryColor: const Color(0xFF075E54),
      iconTheme: const IconThemeData(color: Colors.white),
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.white, size: 20),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF075E54)),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        headlineMedium: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300),
        headlineSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        bodySmall: TextStyle(fontSize: 12),
      ),
    );
  }

  factory ThemeManage() {
    _instance ??= ThemeManage._internal();
    return _instance!;
  }
  void setTheme(ThemeData themeData) {
    _themeData = themeData;
  }

  ThemeData get theme => _themeData!;
}
