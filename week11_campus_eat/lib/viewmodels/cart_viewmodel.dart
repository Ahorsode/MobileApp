import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';
import '../services/cart_service.dart';

class CartViewModel extends ChangeNotifier {
  final CartService _cartService = CartService();
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;
  List<CartItem> get items => _isLoaded ? _cartService.getItems() : [];
  double get totalAmount => _isLoaded ? _cartService.getTotal() : 0.0;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  Future<void> init() async {
    await _cartService.init();
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> addItem(MenuItem menuItem) async {
    final cartItem = CartItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Temp unique ID
      menuItemId: menuItem.id,
      name: menuItem.name,
      price: menuItem.price,
      quantity: 1,
    );
    await _cartService.addToCart(cartItem);
    notifyListeners();
  }

  Future<void> updateQuantity(String id, int quantity) async {
    await _cartService.updateQuantity(id, quantity);
    notifyListeners();
  }

  Future<void> removeItem(String id) async {
    await _cartService.removeFromCart(id);
    notifyListeners();
  }

  Future<void> clearCart() async {
    await _cartService.clearCart();
    notifyListeners();
  }
}
