import 'package:flutter/material.dart';

mixin LoadingStateNotifier on ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoadingState({required bool value}) {
    if (_isLoading == value) return;

    _isLoading = value;
    notifyListeners();
  }
}
