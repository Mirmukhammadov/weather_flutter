import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String globalVariable = 'Tashkent';

  void updateGlobalVariable(String newValue) {
    print('Updating globalVariable to: $newValue');
    globalVariable = newValue;
    notifyListeners();
  }

  // Singleton pattern
  static final AppState _instance = AppState._internal();

  factory AppState() {
    return _instance;
  }

  AppState._internal();
}
