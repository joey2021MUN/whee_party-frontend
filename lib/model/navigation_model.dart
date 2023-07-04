import 'package:flutter/widgets.dart';

class NavigationModel extends ChangeNotifier {
  int _currentNavigationIndex = 0;

  int get currentNavigationIndex => _currentNavigationIndex;

  void navigateToPage(int index) {
    _currentNavigationIndex = index;
    notifyListeners();
  }
}