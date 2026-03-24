import 'package:flutter/material.dart';
import '../services/event_service.dart';
import '../models/event.dart';

class EventViewModel extends ChangeNotifier {
  final EventService _eventService = EventService();
  List<Event> _events = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void listenToEvents() {
    _eventService.getEvents().listen((eventList) {
      _events = eventList;
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    }, onError: (error) {
      _isLoading = false;
      _errorMessage = error.toString();
      notifyListeners();
    });
  }

  Future<void> addEvent(Event event) async {
    try {
      await _eventService.addEvent(event);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleLike(String eventId, String userId) async {
    await _eventService.toggleLike(eventId, userId);
  }

  Future<void> addComment(String eventId, Comment comment) async {
    await _eventService.addComment(eventId, comment);
  }

  Future<void> deleteEvent(String eventId) async {
    await _eventService.deleteEvent(eventId);
  }
}
