import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

/// Screen that displays a list of student tasks.
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Hardcoded list of tasks for Part B
    final List<Task> tasks = [
      Task(
        title: 'Submit Flutter Midsem',
        courseCode: 'CS301',
        dueDate: DateTime.now().add(const Duration(days: 1)),
      ),
      Task(
        title: 'Database Project',
        courseCode: 'CS302',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        isComplete: true,
      ),
      Task(
        title: 'Networking Assignment',
        courseCode: 'CS303',
        dueDate: DateTime.now().add(const Duration(days: 5)),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${task.courseCode} - Due: ${DateFormat('dd/mm/yyyy').format(task.dueDate)}'),
              trailing: Checkbox(
                value: task.isComplete,
                onChanged: (value) {
                  // Functionality for Part C
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
