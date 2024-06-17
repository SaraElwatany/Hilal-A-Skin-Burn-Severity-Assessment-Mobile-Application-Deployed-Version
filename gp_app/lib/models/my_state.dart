import 'package:flutter/material.dart';

class MyState with ChangeNotifier {
  // Global Variable for User ID from Login Screen
  String userId = '0';
  // Global Variable for Burn ID from Image Capturing Screen
  String burnId = '0';
  // Global Variable for the prediction of the associated burn
  String latestPrediction = '';

  void updateUserId(String newValue) {
    userId = newValue;
    notifyListeners();
  }

  void updateBurnId(String newValue) {
    burnId = newValue;
    notifyListeners();
  }

  void updatePrediction(String newValue) {
    latestPrediction = newValue;
    notifyListeners();
  }
}
