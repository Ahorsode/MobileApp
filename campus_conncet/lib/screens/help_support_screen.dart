import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
      ),
      body: ListView(
        children: [
          _buildSupportHeader(),
          _buildSupportSection(
            context,
            icon: Icons.question_answer_outlined,
            title: 'Frequently Asked Questions',
            onTap: () {
              // Navigate to FAQ page or expand section
            },
          ),
          _buildSupportSection(
            context,
            icon: Icons.mail_outline,
            title: 'Contact Support',
            onTap: () {
              // Implementation for contacting support
            },
          ),
          _buildSupportSection(
            context,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {
              // Open privacy policy link
            },
          ),
          _buildSupportSection(
            context,
            icon: Icons.info_outline,
            title: 'Terms of Service',
            onTap: () {
              // Open terms of service link
            },
          ),
          Divider(),
          _buildAppInfoSection(),
        ],
      ),
    );
  }

  Widget _buildSupportHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Icon(Icons.help_outline, size: 64, color: Colors.blue),
          SizedBox(height: 16),
          Text(
            'How can we help you?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Find answers to common questions or reach out to our team.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildAppInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Campus Connect',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Version 1.0.0',
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
          SizedBox(height: 8),
          Text(
            'Valley View University INFT 425 Project',
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
