import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../models/cart_item.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeOrder(String userId, OrderModel order) async {
    await _firestore.runTransaction((transaction) async {
      Map<String, DocumentReference> itemRefs = {};
      Map<String, DocumentSnapshot> snapshots = {};

      for (CartItem cartItem in order.items) {
        DocumentReference ref = _firestore.collection('menu').doc(cartItem.menuItemId);
        DocumentSnapshot snapshot = await transaction.get(ref);

        if (!snapshot.exists) {
          throw Exception("Item '${cartItem.name}' no longer exists.");
        }

        int currentStock = snapshot.get('stock');
        if (currentStock < cartItem.quantity) {
          throw Exception("Item '${cartItem.name}' is out of stock (Requested: ${cartItem.quantity}, Available: $currentStock).");
        }

        itemRefs[cartItem.menuItemId] = ref;
        snapshots[cartItem.menuItemId] = snapshot;
      }

      for (CartItem cartItem in order.items) {
        int currentStock = snapshots[cartItem.menuItemId]!.get('stock');
        transaction.update(itemRefs[cartItem.menuItemId]!, {
          'stock': currentStock - cartItem.quantity,
        });
      }

      DocumentReference orderRef = _firestore.collection('orders').doc();
      Map<String, dynamic> orderData = order.toMap();
      orderData['userId'] = userId; // Store the user ID reliably
      transaction.set(orderRef, orderData);

      DocumentReference userRef = _firestore.collection('users').doc(userId);
      transaction.update(userRef, {
        'totalOrders': FieldValue.increment(1)
      });
    });
  }

  // Admin: Stream all orders globally
  Stream<List<OrderModel>> getAllOrdersStream() {
    return _firestore
        .collection('orders')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => OrderModel.fromMap(doc.data(), doc.id)).toList());
  }

  // Student: Stream their own orders
  Stream<List<OrderModel>> getUserOrdersStream(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => OrderModel.fromMap(doc.data(), doc.id)).toList());
  }

  // Admin: Update Status
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _firestore.collection('orders').doc(orderId).update({'status': newStatus});
  }

  // Advanced Feature D: Submit an atomic rating for a completed order
  Future<void> submitOrderRating(String orderId, int rating, String review) async {
    await _firestore.runTransaction((transaction) async {
      DocumentReference orderRef = _firestore.collection('orders').doc(orderId);
      DocumentSnapshot orderSnap = await transaction.get(orderRef);

      if (!orderSnap.exists) throw Exception("Order not found.");
      if (orderSnap.get('status') != 'completed') throw Exception("Order must be completed before rating.");
      
      try {
        if (orderSnap.get('rating') != null) throw Exception("Order already rated.");
      } catch (e) {
        // Field might not exist, which is fine
      }

      // 1. Read all associated menu items
      List<dynamic> itemsData = orderSnap.get('items');
      List<String> menuItemIds = itemsData.map((item) => item['menuItemId'].toString()).toSet().toList(); // Unique items
      
      Map<String, DocumentReference> menuRefs = {};
      Map<String, DocumentSnapshot> menuSnaps = {};

      for (String itemId in menuItemIds) {
        DocumentReference ref = _firestore.collection('menu').doc(itemId);
        DocumentSnapshot snap = await transaction.get(ref);
        if (snap.exists) {
          menuRefs[itemId] = ref;
          menuSnaps[itemId] = snap;
        }
      }

      // 2. Write updates
      transaction.update(orderRef, {
        'rating': rating,
        'review': review,
      });

      for (String itemId in menuRefs.keys) {
        DocumentSnapshot snap = menuSnaps[itemId]!;
        int currentCount = 0;
        double currentAverage = 0.0;
        
        try { currentCount = snap.get('ratingCount') ?? 0; } catch (_) {}
        try { currentAverage = (snap.get('averageRating') ?? 0.0).toDouble(); } catch (_) {}

        // Mathematical recalculation of average rating
        double newTotalScore = (currentAverage * currentCount) + rating;
        int newCount = currentCount + 1;
        double newAverage = newTotalScore / newCount;

        transaction.update(menuRefs[itemId]!, {
          'ratingCount': newCount,
          'averageRating': newAverage,
        });
      }
    });
  }
}
