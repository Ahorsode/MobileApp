class Expense {
  int? id;           // null because new expenses don't have ID yet
  String title;
  double amount;
  String category;
  DateTime date;
  String? notes;     // optional field

  // Constructor
  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.notes,
  });

  // Convert Expense object to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(), // Convert DateTime to String
      'notes': notes,
    };
  }

  // Convert Map from database to Expense object
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      category: map['category'],
      date: DateTime.parse(map['date']),
      notes: map['notes'],
    );
  }

  // For debugging
  @override
  String toString() {
    return 'Expense(id: $id, title: $title, amount: $amount, category: $category, date: $date)';
  }
}
