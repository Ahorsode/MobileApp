import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/expense.dart';

class ExpenseDatabase {
  // Singleton pattern - only one instance of database
  static final ExpenseDatabase instance = ExpenseDatabase._init();
  static Database? _database;

  ExpenseDatabase._init();

  // Get database (creates if doesn't exist)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expenses.db');
    return _database!;
  }

  // Initialize database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Create table when database is first created
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE expenses (
      id $idType,
      title $textType,
      amount $doubleType,
      category $textType,
      date $textType,
      notes TEXT
    )
    ''');
  }

  // CREATE: Insert new expense
  Future<Expense> createExpense(Expense expense) async {
    final db = await instance.database;
    final id = await db.insert('expenses', expense.toMap());
    return expense.copyWith(id: id);
  }

  // READ: Get all expenses
  Future<List<Expense>> getAllExpenses() async {
    final db = await instance.database;
    final result = await db.query('expenses', orderBy: 'date DESC');
    return result.map((json) => Expense.fromMap(json)).toList();
  }

  // READ: Get single expense by ID
  Future<Expense> getExpense(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
    return Expense.fromMap(result.first);
  }

  // READ: Get expenses by date range
  Future<List<Expense>> getExpensesByDateRange(
    DateTime start, 
    DateTime end
  ) async {
    final db = await instance.database;
    final result = await db.query(
      'expenses',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date DESC',
    );
    return result.map((json) => Expense.fromMap(json)).toList();
  }

  // UPDATE: Update existing expense
  Future<int> updateExpense(Expense expense) async {
    final db = await instance.database;
    return db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  // DELETE: Delete expense by ID
  Future<int> deleteExpense(int id) async {
    final db = await instance.database;
    return db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CLOSE: Close database connection
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

// Helper extension for copyWith
extension ExpenseCopy on Expense {
  Expense copyWith({
    int? id,
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    String? notes,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }
}
