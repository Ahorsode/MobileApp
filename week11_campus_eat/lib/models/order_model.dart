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
  final String cafeteria;
  final bool isSynced;

  OrderModel({
    required this.id,
    this.userId = '', 
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.timestamp,
    this.rating,
    this.review,
    this.cafeteria = 'Oyibi',
    this.isSynced = true,
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
                imageUrl: item['imageUrl'] ?? '',
              ))
          .toList().cast<CartItem>(),
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'pending',
      timestamp: map['timestamp'] != null 
          ? (map['timestamp'] as Timestamp).toDate() 
          : DateTime.now(),
      rating: map['rating'],
      review: map['review'],
      cafeteria: map['cafeteria'] ?? 'Oyibi',
      isSynced: map['isSynced'] ?? true,
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
      'cafeteria': cafeteria,
      'isSynced': isSynced,
    };
  }
}
