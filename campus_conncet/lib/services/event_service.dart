import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class EventService {
  final CollectionReference _eventsCollection =
      FirebaseFirestore.instance.collection('events');

  Stream<List<Event>> getEvents() {
    return _eventsCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Event.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> addEvent(Event event) async {
    await _eventsCollection.doc(event.id).set(event.toMap());
  }

  Future<void> toggleLike(String eventId, String userId) async {
    final docRef = _eventsCollection.doc(eventId);
    final doc = await docRef.get();
    if (!doc.exists) return;
    final data = doc.data() as Map<String, dynamic>?;
    List<String> likes = List<String>.from(data?['likes'] ?? []);
    if (likes.contains(userId)) {
      likes.remove(userId);
    } else {
      likes.add(userId);
    }
    await docRef.update({'likes': likes});
  }

  Future<void> addComment(String eventId, Comment comment) async {
    final docRef = _eventsCollection.doc(eventId);
    await docRef.update({
      'comments': FieldValue.arrayUnion([comment.toMap()])
    });
  }

  Future<void> deleteEvent(String eventId) async {
    await _eventsCollection.doc(eventId).delete();
  }
}
