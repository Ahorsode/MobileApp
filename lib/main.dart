import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({required this.title, super.key});

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.indigo, // Professional University Blue
      ),
      child: Row(
        // Removed Icon and IconButton widgets here
        children: [
          Expanded(child: title),
        ],
      ),
    );
  }
}

class MyScaffold extends StatelessWidget {
  const MyScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey,
      child: Column(
        children: [
          MyAppBar(
            title: const Text(
              'PERSONAL PROFESSIONAL PORTFOLIO APP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const Text(
                  "Professional Summary",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(thickness: 1),
                const SizedBox(height: 10),
                const Text(
                  "I am Josephine Mends-Wilson, a level 300 Computer Science student. This portfolio showcases my academic progress and technical projects developed during my undergraduate studies.",
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Academic Projects",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(thickness: 1),
                _projectItem("Web app Development", "Mini Website project."),
                _projectItem("Database Systems", "Church database system."),
    
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _projectItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(description, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(child: MyScaffold()),
    ),
  );
}