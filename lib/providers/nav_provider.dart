import 'package:flutter/material.dart';

class NavProvider extends ChangeNotifier {
  int _activeIndex = 0;

  int get activeIndex => _activeIndex;

  void setIndex(int index) {
    if (_activeIndex == index) return;
    _activeIndex = index;
    notifyListeners();
  }
}