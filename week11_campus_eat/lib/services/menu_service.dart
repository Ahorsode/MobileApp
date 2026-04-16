import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_item.dart';

class MenuService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Student: Stream of all menu items (in stock or out of stock doesn't strictly matter for Student if we filter elsewhere, but previously was > 0)
  Stream<List<MenuItem>> getMenuItemsStream() {
    return _firestore
        .collection('menu')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MenuItem.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Admin: CRUD operations for Menu
  Future<void> addMenuItem(MenuItem item) async {
    await _firestore.collection('menu').add(item.toMap());
  }

  Future<void> updateMenuItem(MenuItem item) async {
    await _firestore.collection('menu').doc(item.id).update(item.toMap());
  }

  Future<void> deleteMenuItem(String id) async {
    await _firestore.collection('menu').doc(id).delete();
  }

  Future<void> updateStock(String id, int newStock) async {
    await _firestore.collection('menu').doc(id).update({'stock': newStock});
  }
}
