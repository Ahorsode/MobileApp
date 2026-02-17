import 'package:flutter/material.dart';


class FacultyScreen extends StatelessWidget {
  const FacultyScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Directory'),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text('Professor ${index + 1}'),
              subtitle: const Text('Computer Science Department'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Could navigate to faculty detail
              },
            ),
          );
        },
      ),
    );
  }
}
