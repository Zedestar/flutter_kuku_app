import 'package:flutter/material.dart';

class DarkLightModeProvider with ChangeNotifier {
  bool _isLightMode = true;

  void toggleTheme() {
    _isLightMode = !_isLightMode;
    print("toggle theme was executed successfuly $_isLightMode");
    notifyListeners();
  }

  bool get gettingThemeChanger {
    return _isLightMode;
  }
}
