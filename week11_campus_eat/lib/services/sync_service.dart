import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import '../models/order_model.dart';
import '../models/cart_item.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Box? _offlineBox;

  Future<void> init() async {
    _offlineBox = await Hive.openBox('offline_orders');
    _checkConnectivityAndSync();
    Connectivity().onConnectivityChanged.listen((results) {
      if (results.any((r) => r != ConnectivityResult.none)) {
        syncOrders();
      }
    });
  }

  void _checkConnectivityAndSync() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.any((r) => r != ConnectivityResult.none)) {
      syncOrders();
    }
  }

  Future<void> queueOrder(String userId, List<CartItem> items, double totalAmount, String cafeteria) async {
    final orderData = {
      'userId': userId,
      'items': items.map((i) => i.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': 'pending',
      'timestamp': DateTime.now().toIso8601String(),
      'cafeteria': cafeteria,
      'isSynced': false,
    };
    await _offlineBox?.add(orderData);
    print("📦 Order queued offline");
  }

  Future<void> syncOrders() async {
    if (_offlineBox == null || _offlineBox!.isEmpty) return;

    print("🔄 Syncing ${_offlineBox!.length} offline orders...");
    
    final List<int> syncedIndices = [];

    for (int i = 0; i < _offlineBox!.length; i++) {
      final orderMap = Map<String, dynamic>.from(_offlineBox!.getAt(i));
      
      try {
        // 1. Submit to Firestore
        final docRef = _firestore.collection('orders').doc();
        await docRef.set({
          ...orderMap,
          'timestamp': FieldValue.serverTimestamp(),
          'isSynced': true,
        });

        // 2. Update Stock (Simulated - in real app would be a transaction)
        for (var item in (orderMap['items'] as List)) {
          final menuDoc = _firestore.collection('menu').doc(item['menuItemId']);
          await _firestore.runTransaction((transaction) async {
            final snapshot = await transaction.get(menuDoc);
            if (snapshot.exists) {
              int currentStock = snapshot.data()?['stock'] ?? 0;
              transaction.update(menuDoc, {'stock': currentStock - (item['quantity'] as int)});
            }
          });
        }

        syncedIndices.add(i);
        print("✅ Order ${docRef.id} synced successfully");
      } catch (e) {
        print("❌ Failed to sync order at index $i: $e");
      }
    }

    // Remove synced orders from Hive
    for (var index in syncedIndices.reversed) {
      await _offlineBox!.deleteAt(index);
    }
  }

  List<OrderModel> getOfflineOrders() {
    if (_offlineBox == null) return [];
    return _offlineBox!.values.map((map) {
      final orderMap = Map<String, dynamic>.from(map);
      return OrderModel(
        id: 'offline_${DateTime.now().millisecondsSinceEpoch}',
        userId: orderMap['userId'],
        items: (orderMap['items'] as List).map((i) => CartItem.fromMap(Map<String, dynamic>.from(i))).toList(),
        totalAmount: (orderMap['totalAmount'] ?? 0.0).toDouble(),
        status: 'Syncing...',
        timestamp: DateTime.parse(orderMap['timestamp']),
        cafeteria: orderMap['cafeteria'],
        isSynced: false,
      );
    }).toList();
  }
}
