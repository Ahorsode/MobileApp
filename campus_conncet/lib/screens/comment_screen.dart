import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../viewmodels/event_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';


class CommentScreen extends StatefulWidget {
  final Event event;
  CommentScreen({required this.event});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _commentController = TextEditingController();
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    final eventVm = Provider.of<EventViewModel>(context);
    final user = Provider.of<AuthViewModel>(context).user;

    // We filter the current event from the list to get updated comments
    final updatedEvent = eventVm.events.firstWhere((e) => e.id == widget.event.id, orElse: () => widget.event);

    return Scaffold(
      appBar: AppBar(title: Text('Comments')),
      body: Column(
        children: [
          Expanded(
            child: updatedEvent.comments.isEmpty
                ? Center(child: Text('No comments yet. Be the first!'))
                : ListView.builder(
                    itemCount: updatedEvent.comments.length,
                    itemBuilder: (context, index) {
                      final comment = updatedEvent.comments[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(comment.userName.substring(0, 1).toUpperCase()),
                        ),
                        title: Text(comment.userName, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(comment.text),
                        trailing: Text(
                          _formatTime(comment.timestamp),
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      );
                    },
                  ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                _isSending
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                      )
                    : IconButton(
                        icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
                        onPressed: () async {
                          if (user == null || _commentController.text.trim().isEmpty) return;

                          setState(() => _isSending = true);
                          final comment = Comment(
                            userId: user.uid,
                            userName: user.email?.split('@')[0] ?? 'User',
                            text: _commentController.text,
                            timestamp: DateTime.now(),
                          );
                          await eventVm.addComment(widget.event.id, comment);
                          _commentController.clear();
                          setState(() => _isSending = false);
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return 'just now';
  }
}
