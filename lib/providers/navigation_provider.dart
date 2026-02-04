import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setTab(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  // Helper methods for semantic navigation
  void goToHome() => setTab(0);
  void goToCategories() => setTab(1);
  void goToWishlist() => setTab(2);
  void goToCart() => setTab(3);
  void goToProfile() => setTab(4);
}
