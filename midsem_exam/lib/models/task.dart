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

  /// Convert a [Task] into a JSON map.
  Map<String, dynamic> toJson() => {
        'title': title,
        'courseCode': courseCode,
        'dueDate': dueDate.toIso8601String(),
        'isComplete': isComplete,
      };

  /// Create a [Task] from a JSON map.
  factory Task.fromJson(Map<String, dynamic> json) => Task(
        title: json['title'],
        courseCode: json['courseCode'],
        dueDate: DateTime.parse(json['dueDate']),
        isComplete: json['isComplete'] ?? false,
      );
}

