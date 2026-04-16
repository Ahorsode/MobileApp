import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('Not logged in')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 24),
            ListTile(
              title: const Text('Email'),
              subtitle: Text(user.email),
              leading: const Icon(Icons.email),
            ),
            ListTile(
              title: const Text('Role'),
              subtitle: Text(user.isAdmin ? 'Admin' : 'Student'),
              leading: const Icon(Icons.security),
            ),
            ListTile(
              title: const Text('Total Orders'),
              subtitle: Text(user.totalOrders.toString()),
              leading: const Icon(Icons.shopping_bag),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                context.read<AuthViewModel>().signOut();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Logout', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
