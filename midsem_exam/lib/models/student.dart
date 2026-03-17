/// Represents a Student with their profile details.
class Student {
  final String name;
  final String studentId;
  final String programme;
  final int level;

  /// Constructor for a [Student] with required parameters.
  Student({
    required this.name,
    required this.studentId,
    required this.programme,
    required this.level,
  });
}
