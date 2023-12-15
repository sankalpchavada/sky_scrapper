import 'package:flutter/material.dart';
import 'package:weather_app/models/theme_model.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeDetails themeDetails = ThemeDetails(isDark: false);

  void Changetheme() {
    themeDetails.isDark = !themeDetails.isDark;
    notifyListeners();
  }
}
