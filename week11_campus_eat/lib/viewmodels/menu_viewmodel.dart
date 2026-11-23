import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../services/menu_service.dart';

class MenuViewModel extends ChangeNotifier {
  final MenuService _menuService = MenuService();

  // Advanced Feature C: Search & Filter State
  String _searchQuery = '';
  String _selectedCategory = 'All';
  RangeValues _priceRange = const RangeValues(0, 100);
  String _selectedCafeteria = 'Oyibi';

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  RangeValues get priceRange => _priceRange;
  String get selectedCafeteria => _selectedCafeteria;

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setPriceRange(RangeValues range) {
    _priceRange = range;
    notifyListeners();
  }

  void setCafeteria(String cafeteria) {
    _selectedCafeteria = cafeteria;
    notifyListeners();
  }

  // Base Stream
  Stream<List<MenuItem>> get menuStream => _menuService.getMenuItemsStream();

  // Helper method to filter items dynamically
  List<MenuItem> filterItems(List<MenuItem> items) {
    return items.where((item) {
      // 1. Cafeteria Filter
      final matchesCafeteria = item.cafeteria == _selectedCafeteria;

      // 2. Category Filter
      final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
      
      // 3. Search Filter
      final matchesSearch = item.name.toLowerCase().contains(_searchQuery);

      // 4. Price Filter
      final matchesPrice = item.price >= _priceRange.start && item.price <= _priceRange.end;

      return matchesCafeteria && matchesCategory && matchesSearch && matchesPrice;
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
