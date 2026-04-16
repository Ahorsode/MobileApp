import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../services/menu_service.dart';

class MenuViewModel extends ChangeNotifier {
  final MenuService _menuService = MenuService();

  Stream<List<MenuItem>> get menuStream => _menuService.getMenuItemsStream();

  // Helper method to group items by category
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
