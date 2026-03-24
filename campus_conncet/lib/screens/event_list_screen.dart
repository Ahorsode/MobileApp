import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/event_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'add_event_screen.dart';
import 'comment_screen.dart';

class EventListScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventViewModel>(context, listen: false).listenToEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventVm = Provider.of<EventViewModel>(context);
    final userId = Provider.of<AuthViewModel>(context, listen: false).user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(title: Text('Campus Events')),
      body: eventVm.isLoading
          ? Center(child: CircularProgressIndicator())
          : eventVm.errorMessage != null
              ? Center(child: Text(eventVm.errorMessage!))
              : eventVm.events.isEmpty
                  ? Center(child: Text('No events found. Add one!'))
                  : ListView.builder(
                      itemCount: eventVm.events.length,
                      itemBuilder: (context, index) {
                        final event = eventVm.events[index];
                        final isOwnedByMe = event.createdBy == userId;

                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (event.imageUrl.isNotEmpty)
                                Image.network(
                                  event.imageUrl,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(height: 100, color: Colors.grey[300], child: Icon(Icons.broken_image)),
                                ),
                              ListTile(
                                title: Text(event.title, style: TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('${event.description}\n${_formatDate(event.date)}'),
                                trailing: isOwnedByMe
                                    ? IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _confirmDelete(context, eventVm, event.id),
                                      )
                                    : null,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        event.likes.contains(userId) ? Icons.favorite : Icons.favorite_border,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => eventVm.toggleLike(event.id, userId),
                                    ),
                                    Text('${event.likes.length} likes'),
                                    SizedBox(width: 16),
                                    IconButton(
                                      icon: Icon(Icons.comment_outlined),
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CommentScreen(event: event),
                                        ),
                                      ),
                                    ),
                                    Text('${event.comments.length} comments'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddEventScreen()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, EventViewModel vm, String eventId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Event'),
        content: Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              vm.deleteEvent(eventId);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}
