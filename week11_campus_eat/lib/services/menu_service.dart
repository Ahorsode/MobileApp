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

  // Seeding local Ghanaian dishes
  Future<void> seedGhanaianMenu({bool force = false}) async {
    if (!force) {
      final snapshot = await _firestore.collection('menu').get();
      if (snapshot.docs.isNotEmpty) return; // Don't seed if already has items
    }

    final List<Map<String, dynamic>> ghanaianDishes = [
      {
        'name': 'Ghanaian Jollof Rice',
        'description': 'The world-famous spicy tomato-based rice served with fried chicken and shito.',
        'price': 25.0,
        'imageUrl': 'https://images.unsplash.com/photo-1644609297072-f1947e446665?q=80&w=2000',
        'category': 'Lunch',
        'stock': 50,
        'ratingCount': 0,
        'averageRating': 0.0,
      },
      {
        'name': 'Waakye Special',
        'description': 'Authentic rice and beans cooked with sorghum leaves, served with gari, spaghetti, and egg.',
        'price': 20.0,
        'imageUrl': 'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?q=80&w=2000',
        'category': 'Lunch',
        'stock': 30,
        'ratingCount': 0,
        'averageRating': 0.0,
      },
      {
        'name': 'Banku with Tilapia',
        'description': 'Fermented corn and cassava dough served with large grilled tilapia and fresh pepper sauce.',
        'price': 45.0,
        'imageUrl': 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?q=80&w=2000',
        'category': 'Lunch',
        'stock': 15,
        'ratingCount': 0,
        'averageRating': 0.0,
      },
      {
        'name': 'Red Red',
        'description': 'Hearty bean stew cooked in red palm oil, served with golden fried ripe plantains.',
        'price': 15.0,
        'imageUrl': 'https://images.unsplash.com/photo-1605666807892-9c17031952a9?q=80&w=2000',
        'category': 'Lunch',
        'stock': 40,
        'ratingCount': 0,
        'averageRating': 0.0,
      },
      {
        'name': 'Kelewele',
        'description': 'Spicy deep-fried plantain cubes seasoned with ginger, cloves, and chili.',
        'price': 10.0,
        'imageUrl': 'https://images.unsplash.com/photo-1628191139360-4083564d03fd?q=80&w=2000',
        'category': 'Snacks',
        'stock': 60,
        'ratingCount': 0,
        'averageRating': 0.0,
      },
      {
        'name': 'Hausa Koko & Koose',
        'description': 'Spicy millet porridge served with deep-fried spicy bean cakes.',
        'price': 8.0,
        'imageUrl': 'https://images.unsplash.com/photo-1598214886806-c87b84b7078b?q=80&w=2000',
        'category': 'Breakfast',
        'stock': 25,
        'ratingCount': 0,
        'averageRating': 0.0,
      },
      {
        'name': 'Kenkey with Fish',
        'description': 'Fermented corn-dough dumpling served with spicy pepper sauce, onions, and fried fish.',
        'price': 18.0,
        'imageUrl': 'https://images.unsplash.com/photo-1610450949065-2f2297447600?q=80&w=2000',
        'category': 'Lunch',
        'stock': 35,
        'ratingCount': 0,
        'averageRating': 0.0,
      },
    ];

    for (var dish in ghanaianDishes) {
      await _firestore.collection('menu').add(dish);
    }
  }
}
