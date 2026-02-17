import 'package:flutter/material.dart';
class ExpenseCategory {
  static const List<String> categories = [
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Bills & Utilities',
    'Healthcare',
    'Education',
    'Other',
  ];

  static const Map<String, IconData> categoryIcons = {
    'Food & Dining': Icons.restaurant,
    'Transportation': Icons.directions_car,
    'Shopping': Icons.shopping_bag,
    'Entertainment': Icons.movie,
    'Bills & Utilities': Icons.receipt,
    'Healthcare': Icons.medical_services,
    'Education': Icons.school,
    'Other': Icons.category,
  };
}
