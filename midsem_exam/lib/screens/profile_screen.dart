import 'package:flutter/material.dart';
import '../models/student.dart';
import 'task_list_screen.dart';

/// ProfileScreen - displays the student's profile information.
/// Converted to [StatefulWidget] so that edits to the profile update the UI.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Student object holding the displayed profile data
  Student student = Student(
    name: 'Ahorsode Benjamin Delali',
    studentId: '226IT02000268',
    programme: 'BSc. Information Technology',
    level: 300,
  );

  // Controllers for the Edit Profile dialog fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _programmeController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();

  /// Opens a dialog that lets the user edit their profile details.
  /// On 'Save', a new [Student] is created with the updated fields and
  /// [setState] is called so the UI rebuilds with the new information.
  void _showEditProfileDialog() {
    // Pre-fill fields with current student data
    _nameController.text = student.name;
    _idController.text = student.studentId;
    _programmeController.text = student.programme;
    _levelController.text = student.level.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Field for editing student name
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                // Field for editing student ID
                TextField(
                  controller: _idController,
                  decoration: const InputDecoration(
                    labelText: 'Student ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                // Field for editing programme
                TextField(
                  controller: _programmeController,
                  decoration: const InputDecoration(
                    labelText: 'Programme',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                // Field for editing academic level
                TextField(
                  controller: _levelController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Level (e.g. 300)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            // Cancel closes dialog without changes
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            // Save updates the student object and rebuilds the UI
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Create a new Student with the edited values
                  student = Student(
                    name: _nameController.text,
                    studentId: _idController.text,
                    programme: _programmeController.text,
                    level: int.tryParse(_levelController.text) ?? student.level,
                  );
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // CircleAvatar displays the first letter of the student's name
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Text(
                student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            // Card widget displays student details: name, ID, programme, level
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${student.name}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    Text('ID: ${student.studentId}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Programme: ${student.programme}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Level: ${student.level}', style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Edit Profile button - opens a dialog to update student details
            ElevatedButton(
              onPressed: _showEditProfileDialog,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 10),
            // View Tasks button - navigates to the TaskListScreen
            ElevatedButton(
              onPressed: () {
                // Navigate to TaskListScreen when the button is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TaskListScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('View Tasks'),
            ),
          ],
        ),
      ),
    );
  }
}
