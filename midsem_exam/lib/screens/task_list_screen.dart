import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

/// Screen that displays a list of student tasks and allows adding new ones.
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // List of tasks (initially with hardcoded data)
  final List<Task> _tasks = [
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

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  DateTime? _selectedDate;

  /// Shows a date picker and updates [_selectedDate].
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
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
                    decoration: const InputDecoration(labelText: 'Task Title'),
                  ),
                  TextField(
                    controller: _courseController,
                    decoration: const InputDecoration(labelText: 'Course Code'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(_selectedDate == null ? 'No date chosen' : DateFormat('dd/MM/yyyy').format(_selectedDate!)),
                      const Spacer(),
                      TextButton(
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
                        child: const Text('Pick Date'),
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
                    if (_titleController.text.isNotEmpty && _courseController.text.isNotEmpty && _selectedDate != null) {
                      setState(() {
                        _tasks.add(Task(
                          title: _titleController.text,
                          courseCode: _courseController.text,
                          dueDate: _selectedDate!,
                        ));
                      });
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
      ),
      body: ListView.builder(
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
                ),
              ),
              subtitle: Text('${task.courseCode} - Due: ${DateFormat('dd/MM/yyyy').format(task.dueDate)}'),
              trailing: Checkbox(
                value: task.isComplete,
                onChanged: (value) {
                  setState(() {
                    task.isComplete = value ?? false;
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
