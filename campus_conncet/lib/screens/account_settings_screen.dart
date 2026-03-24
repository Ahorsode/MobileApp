import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class AccountSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthViewModel>(context);
    final user = authVm.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Profile Information'),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Display Name'),
            subtitle: Text(user?.displayName ?? 'Not set'),
            trailing: Icon(Icons.edit, size: 20),
            onTap: () {
              // Implementation for updating display name
            },
          ),
          ListTile(
            leading: Icon(Icons.email_outlined),
            title: Text('Email'),
            subtitle: Text(user?.email ?? 'Not available'),
            onTap: null, // Email usually cannot be changed easily without re-auth
          ),
          Divider(),
          _buildSectionHeader('Security'),
          ListTile(
            leading: Icon(Icons.lock_outline),
            title: Text('Change Password'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Implementation for changing password
            },
          ),
          ListTile(
            leading: Icon(Icons.shield_outlined),
            title: Text('Two-Factor Authentication'),
            trailing: Switch(value: false, onChanged: (val) {}),
          ),
          Divider(),
          _buildSectionHeader('Danger Zone', color: Colors.red),
          ListTile(
            leading: Icon(Icons.delete_forever, color: Colors.red),
            title: Text('Delete Account', style: TextStyle(color: Colors.red)),
            onTap: () {
              _showDeleteAccountDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: color ?? Colors.blue,
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account?'),
        content: Text('This action is permanent and cannot be undone. All your data will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implementation for account deletion
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
