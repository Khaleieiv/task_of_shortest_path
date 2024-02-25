import 'package:flutter/material.dart';

mixin LoadingStateNotifier on ChangeNotifier {
  bool _isCalculationInProgress = false;
  bool _isPostInProgress = false;

  bool get isCalculationInProgress => _isCalculationInProgress;
  bool get isPostInProgress => _isPostInProgress;

  void setLoading({required String loadingType, required bool value}) {
    if ((loadingType == 'calculation' && _isCalculationInProgress == value) ||
        (loadingType == 'post' && _isPostInProgress == value)) return;

    switch (loadingType) {
      case 'calculation':
        _isCalculationInProgress = value;
        break;
      case 'post':
        _isPostInProgress = value;
        break;
    }
    notifyListeners();
  }
}

