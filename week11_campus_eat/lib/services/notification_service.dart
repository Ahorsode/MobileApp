import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Request permissions
    await _fcm.requestPermission();

    // Init local notifications
    const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(android: androidInit);
    await _localNotifications.initialize(initSettings);

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showNotification(
          message.notification!.title ?? 'New Message',
          message.notification!.body ?? '',
        );
      }
    });
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'campus_eats_channel',
      'Campus Eats Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails details = NotificationDetails(android: androidDetails);
    await _localNotifications.show(
      DateTime.now().millisecond,
      title,
      body,
      details,
    );
  }

  void monitorOrders(String userId, bool isAdmin, String cafeteria) {
    FirebaseFirestore.instance
        .collection('orders')
        .where(isAdmin ? 'cafeteria' : 'userId', isEqualTo: isAdmin ? cafeteria : userId)
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added && isAdmin) {
          // New order for admin
          showNotification(
            'New Order Placed!',
            'A student just ordered from $cafeteria.',
          );
        } else if (change.type == DocumentChangeType.modified) {
          final data = change.doc.data();
          if (data != null && data['status'] == 'ready' && !isAdmin) {
            // Order ready for student
            showNotification(
              'Order Ready!',
              'Your order at $cafeteria is ready for pickup!',
            );
          }
        }
      }
    });
  }

  Future<String?> getToken() async {
    return await _fcm.getToken();
  }
}
