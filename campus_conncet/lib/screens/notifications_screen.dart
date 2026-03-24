import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _eventReminders = true;
  bool _announcements = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView(
        children: [
          _buildNotificationSwitch(
            title: 'Push Notifications',
            subtitle: 'Receive real-time alerts on your device',
            value: _pushNotifications,
            onChanged: (val) => setState(() => _pushNotifications = val),
          ),
          _buildNotificationSwitch(
            title: 'Email Notifications',
            subtitle: 'Weekly digests and important updates',
            value: _emailNotifications,
            onChanged: (val) => setState(() => _emailNotifications = val),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Specific Alerts',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          _buildNotificationSwitch(
            title: 'Event Reminders',
            subtitle: 'Alerts for events you\'re interested in',
            value: _eventReminders,
            onChanged: (val) => setState(() => _eventReminders = val),
          ),
          _buildNotificationSwitch(
            title: 'Campus Announcements',
            subtitle: 'Important news from the university',
            value: _announcements,
            onChanged: (val) => setState(() => _announcements = val),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      secondary: Icon(
        title.contains('Push') ? Icons.notifications_active : 
        title.contains('Email') ? Icons.email : 
        title.contains('Reminders') ? Icons.event : Icons.campaign,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
