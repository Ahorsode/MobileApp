import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'account_settings_screen.dart';
import 'notifications_screen.dart';
import 'help_support_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthViewModel>(context);
    final user = authVm.user;

    return Scaffold(
      appBar: AppBar(title: Text('My Profile')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Text(
                  user?.email?.substring(0, 1).toUpperCase() ?? 'U',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                ),
              ),
              SizedBox(height: 24),
              Text(
                user?.email ?? 'Student Account',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                user?.displayName ?? 'Valley View University Student',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 48),
              _buildProfileOption(
                context,
                icon: Icons.settings,
                title: 'Account Settings',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AccountSettingsScreen()),
                ),
              ),
              _buildProfileOption(
                context,
                icon: Icons.notifications,
                title: 'Notifications',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NotificationsScreen()),
                ),
              ),
              _buildProfileOption(
                context,
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HelpSupportScreen()),
                ),
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await authVm.signOut();
                    if (context.mounted) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                  },
                  icon: Icon(Icons.logout, color: Colors.red),
                  label: Text('Logout', style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
