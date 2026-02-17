import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'package:intl/intl.dart';
import '../models/category.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback onTap;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Format date
    final dateFormat = DateFormat('MMM dd, yyyy');
    final formattedDate = dateFormat.format(expense.date);

    // Get category icon
    final categoryIcon = ExpenseCategory.categoryIcons[expense.category] ?? Icons.category;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: Hero(
          tag: 'expense-icon-${expense.id}',
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: Icon(
              categoryIcon,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        title: Text(
          expense.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('$formattedDate • ${expense.category}'),
        trailing: Text(
          'GHS ${expense.amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
