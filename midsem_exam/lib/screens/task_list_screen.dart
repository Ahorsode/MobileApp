import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

/// TaskListScreen - displays a list of student tasks and handles persistence.
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // List of tasks
  List<Task> _tasks = [];
  bool _isLoading = true;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Load tasks on startup (Part C requirement)
  }

  /// Load tasks from SharedPreferences. Falls back to hardcoded list if empty.
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('tasks');

    if (tasksJson != null) {
      final List<dynamic> decoded = jsonDecode(tasksJson);
      setState(() {
        _tasks = decoded.map((item) => Task.fromJson(item)).toList();
        _isLoading = false;
      });
    } else {
      // Fallback to hardcoded list as per requirements
      setState(() {
        _tasks = [
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
        _isLoading = false;
      });
      _saveTasks();
    }
  }

  /// Save tasks to SharedPreferences (Part C requirement)
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_tasks.map((t) => t.toJson()).toList());
    await prefs.setString('tasks', encoded);
  }

  /// Formats a [DateTime] as 'dd/mm/yyyy' with leading zeros.
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  /// Opens a dialog to add a new task.
  void _showAddTaskDialog() {
    _titleController.clear();
    _courseController.clear();
    _selectedDate = null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add New Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Task Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _courseController,
                    decoration: const InputDecoration(
                      labelText: 'Course Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'No date chosen'
                            : _formatDate(_selectedDate!),
                        style: TextStyle(
                          color: _selectedDate == null ? Colors.grey : Colors.black,
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        icon: const Icon(Icons.calendar_today, size: 16),
                        label: const Text('Pick Date'),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null) {
                            setDialogState(() {
                              _selectedDate = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.isNotEmpty &&
                        _courseController.text.isNotEmpty &&
                        _selectedDate != null) {
                      setState(() {
                        _tasks.add(Task(
                          title: _titleController.text,
                          courseCode: _courseController.text,
                          dueDate: _selectedDate!,
                        ));
                      });
                      _saveTasks(); // Save after adding (Part C)
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: task.isComplete ? TextDecoration.lineThrough : null,
                        color: task.isComplete ? Colors.grey : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      '${task.courseCode} - Due: ${_formatDate(task.dueDate)}',
                    ),
                    trailing: Checkbox(
                      value: task.isComplete,
                      onChanged: (value) {
                        setState(() {
                          task.isComplete = value ?? false;
                        });
                        _saveTasks(); // Save after toggle (Part C)
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Colors.blueAccent,
        tooltip: 'Add Task',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
