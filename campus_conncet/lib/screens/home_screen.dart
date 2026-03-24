import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/quote_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'event_list_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quoteVm = Provider.of<QuoteViewModel>(context);
    final authVm = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Campus Connect'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfileScreen()),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade800,
              Colors.white,
            ],
            stops: [0.0, 0.8],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome back, ${authVm.user?.email?.split('@')[0] ?? 'Student'}!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              SizedBox(height: 24),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.format_quote, color: Theme.of(context).primaryColor),
                          SizedBox(width: 8),
                          Text(
                            'Daily Inspiration',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      if (quoteVm.isLoading)
                        CircularProgressIndicator()
                      else if (quoteVm.errorMessage != null)
                        Text('Failed to load quote. Tap to retry.')
                      else
                        Column(
                          children: [
                            Text(
                              '"${quoteVm.currentQuote?.text}"',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '- ${quoteVm.currentQuote?.author}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: () => quoteVm.loadRandomQuote(),
                        icon: Icon(Icons.refresh),
                        label: Text('New Quote'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              _buildFeatureCard(
                context,
                title: 'Campus Events',
                description: 'Stay updated with what\'s happening on campus.',
                icon: Icons.event,
                color: Colors.blue,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EventListScreen()),
                ),
              ),
              SizedBox(height: 16),
              _buildFeatureCard(
                context,
                title: 'My Profile',
                description: 'Manage your account and preferences.',
                icon: Icons.account_circle,
                color: Colors.green,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfileScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
