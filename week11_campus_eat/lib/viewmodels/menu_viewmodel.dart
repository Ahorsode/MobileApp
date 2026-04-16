import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../services/menu_service.dart';

class MenuViewModel extends ChangeNotifier {
  final MenuService _menuService = MenuService();

  // Advanced Feature C: Search & Filter State
  String _searchQuery = '';
  String _selectedCategory = 'All';

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Base Stream
  Stream<List<MenuItem>> get menuStream => _menuService.getMenuItemsStream();

  // Helper method to filter items dynamically based on current search and category state
  List<MenuItem> filterItems(List<MenuItem> items) {
    return items.where((item) {
      // 1. Stock validation (Optional: can hide totally out-of-stock items, or keep them and disable button)
      // We will show them but label them Out of Stock in UI later.
      
      // 2. Category Filter
      final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
      
      // 3. Search Filter
      final matchesSearch = item.name.toLowerCase().contains(_searchQuery);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Helper method to group items by category for UI sectioning
  Map<String, List<MenuItem>> groupItemsByCategory(List<MenuItem> items) {
    Map<String, List<MenuItem>> grouped = {};
    for (var item in items) {
      if (!grouped.containsKey(item.category)) {
        grouped[item.category] = [];
      }
      grouped[item.category]!.add(item);
    }
    return grouped;
  }
}
