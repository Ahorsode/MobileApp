/// Represents a Task in the task manager.
class Task {
  final String title;
  final String courseCode;
  final DateTime dueDate;
  bool isComplete;

  /// Constructor for a [Task] with required parameters.
  /// [isComplete] defaults to false if not provided.
  Task({
    required this.title,
    required this.courseCode,
    required this.dueDate,
    this.isComplete = false,
  });
}
