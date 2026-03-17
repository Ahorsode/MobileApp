import 'package:flutter/material.dart';
import '../models/task.dart';

/// TaskListScreen - displays a list of student tasks and allows adding new ones.
/// This is a [StatefulWidget] so that state changes (new tasks, completions)
/// trigger a UI rebuild via [setState].
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Initial hardcoded list of at least 3 tasks (as required by Part B)
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

  // Controllers to capture user input from the dialog TextFields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();

  // Holds the date the user selects via the date picker
  DateTime? _selectedDate;

  /// Formats a [DateTime] as 'dd/mm/yyyy' with leading zeros using string interpolation.
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  /// Opens a dialog that lets the user enter a task title, course code,
  /// and select a due date. When 'Save' is tapped, a new [Task] is created
  /// and added to [_tasks] using [setState] to update the UI.
  void _showAddTaskDialog() {
    // Clear controllers and date before showing dialog
    _titleController.clear();
    _courseController.clear();
    _selectedDate = null;

    showDialog(
      context: context,
      builder: (context) {
        // StatefulBuilder is used so the date selection updates inside the dialog
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add New Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // TextField for entering the task title
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Task Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // TextField for entering the course code
                  TextField(
                    controller: _courseController,
                    decoration: const InputDecoration(
                      labelText: 'Course Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Row showing selected date and a button to open the date picker
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
                          // Open the material date picker
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          // Update the dialog's local state to show new date
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
                // Cancel closes the dialog without saving
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                // Save creates a new Task and adds it to the list with setState
                ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.isNotEmpty &&
                        _courseController.text.isNotEmpty &&
                        _selectedDate != null) {
                      // setState notifies Flutter to rebuild the list with the new task
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
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              // Strike-through completed task titles
              title: Text(
                task.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: task.isComplete ? TextDecoration.lineThrough : null,
                  color: task.isComplete ? Colors.grey : Colors.black,
                ),
              ),
              // Format date as dd/mm/yyyy using string interpolation with leading zeros
              subtitle: Text(
                '${task.courseCode} - Due: ${_formatDate(task.dueDate)}',
              ),
              // Checkbox toggles the isComplete field using setState to update the UI
              trailing: Checkbox(
                value: task.isComplete,
                onChanged: (value) {
                  // setState ensures the UI reflects the toggled isComplete status
                  setState(() {
                    task.isComplete = value ?? false;
                  });
                },
              ),
            ),
          );
        },
      ),
      // FAB button opens the Add Task dialog
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Colors.blueAccent,
        tooltip: 'Add Task',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
