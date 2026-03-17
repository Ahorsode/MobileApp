import 'package:flutter/material.dart';
import '../models/student.dart';
import 'task_list_screen.dart';

/// Screen that displays the student's profile details.
class ProfileScreen extends StatelessWidget {
  final Student student = Student(
    name: 'John Doe',
    studentId: '12345678',
    programme: 'BSc. Computer Science',
    level: 300,
  );

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Student's initial in a CircleAvatar
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Text(
                student.name[0],
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            // Student information in a Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${student.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            // Edit Profile button (non-functional)
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 10),
            // Navigation to Task List screen
            ElevatedButton(
              onPressed: () {
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
