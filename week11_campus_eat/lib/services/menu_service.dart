import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_item.dart';

class MenuService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Real-time stream of all menu items that are in stock
  Stream<List<MenuItem>> getMenuItemsStream() {
    return _firestore
        .collection('menu')
        .where('stock', isGreaterThan: 0)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MenuItem.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}
