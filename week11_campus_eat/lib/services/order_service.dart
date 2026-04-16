import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../models/cart_item.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeOrder(String userId, OrderModel order) async {
    // A Firestore transaction ensures atomic operations: 
    // it will secure the stock decrement and order creation as a single unit or fail if stock is insufficient.
    await _firestore.runTransaction((transaction) async {
      Map<String, DocumentReference> itemRefs = {};
      Map<String, DocumentSnapshot> snapshots = {};

      // 1. Read step: Must perform all reads before any writes.
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

      // 2. Write step: Update the stock for each item.
      for (CartItem cartItem in order.items) {
        int currentStock = snapshots[cartItem.menuItemId]!.get('stock');
        transaction.update(itemRefs[cartItem.menuItemId]!, {
          'stock': currentStock - cartItem.quantity,
        });
      }

      // 3. Write step: Create the order record.
      DocumentReference orderRef = _firestore.collection('orders').doc();
      Map<String, dynamic> orderData = order.toMap();
      orderData['userId'] = userId;
      transaction.set(orderRef, orderData);

      // 4. Write step: Increment user's total order count.
      DocumentReference userRef = _firestore.collection('users').doc(userId);
      transaction.update(userRef, {
        'totalOrders': FieldValue.increment(1)
      });
    });
  }
}
