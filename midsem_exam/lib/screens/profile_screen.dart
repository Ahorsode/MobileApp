import 'package:flutter/material.dart';
import '../models/student.dart';
import 'task_list_screen.dart';

/// ProfileScreen - displays the student's profile information.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Hardcoded student data displayed on this screen
    final Student student = Student(
      name: 'Ahorsode Benjamin Delali',
      studentId: '226IT02000268',
      programme: 'BSc. Information Technology',
      level: 300,
    );

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
                student.name[0].toUpperCase(),
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
            // Edit Profile button - static display only, no functionality required
            ElevatedButton(
              onPressed: () {},
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
