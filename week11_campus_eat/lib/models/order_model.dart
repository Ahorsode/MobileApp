import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item.dart';

class OrderModel {
  final String id;
  final String userId; 
  final List<CartItem> items;
  final double totalAmount;
  final String status; // pending, preparing, ready, completed
  final DateTime timestamp;
  final int? rating;
  final String? review;

  OrderModel({
    required this.id,
    this.userId = '', 
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.timestamp,
    this.rating,
    this.review,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String docId) {
    return OrderModel(
      id: docId,
      userId: map['userId'] ?? '',
      items: (map['items'] as List)
          .map((item) => CartItem(
                id: '', // Not needed for history
                menuItemId: item['menuItemId'] ?? '',
                name: item['name'] ?? '',
                price: (item['price'] ?? 0.0).toDouble(),
                quantity: item['quantity'] ?? 1,
              ))
          .toList(),
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'pending',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      rating: map['rating'],
      review: map['review'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'timestamp': FieldValue.serverTimestamp(),
      'rating': rating,
      'review': review,
    };
  }
}
