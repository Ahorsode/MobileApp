import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../database/expense_database.dart';
import 'add_expense_screen.dart';
import 'package:intl/intl.dart';
import '../models/category.dart';

class ExpenseDetailScreen extends StatelessWidget {
  final Expense expense;

  const ExpenseDetailScreen({super.key, required this.expense});

  Future<void> _deleteExpense(BuildContext context) async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ExpenseDatabase.instance.deleteExpense(expense.id!);
      if (context.mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  Future<void> _editExpense(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(),
        // In a real app, you'd pass the expense to edit
      ),
    );
    if (result == true) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMMM dd, yyyy');
    final categoryIcon = ExpenseCategory.categoryIcons[expense.category] ?? Icons.category;

    return Scaffold(
      appBar: AppBar(
        title: Text(expense.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editExpense(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteExpense(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Amount',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'GHS ${expense.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Details Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDetailRow(
                      context,
                      Icons.category,
                      'Category',
                      expense.category,
                      iconWidget: Hero(
                        tag: 'expense-icon-${expense.id}',
                        child: Icon(categoryIcon, size: 20, color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    const Divider(),
                    _buildDetailRow(
                      context,
                      Icons.calendar_today,
                      'Date',
                      dateFormat.format(expense.date),
                    ),
                    if (expense.notes != null) ...[
                      const Divider(),
                      _buildDetailRow(
                        context,
                        Icons.note,
                        'Notes',
                        expense.notes!,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData leadingIcon, String label, String value, {Widget? iconWidget}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(leadingIcon, size: 22, color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (iconWidget != null) ...[
                      iconWidget,
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
