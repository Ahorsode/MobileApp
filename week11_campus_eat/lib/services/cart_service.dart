import 'package:hive_flutter/hive_flutter.dart';
import '../models/cart_item.dart';

class CartService {
  static const String boxName = 'cartBox';

  Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CartItemAdapter());
    }
    await Hive.openBox<CartItem>(boxName);
  }

  Box<CartItem> get _box => Hive.box<CartItem>(boxName);

  List<CartItem> getItems() {
    return _box.values.toList();
  }

  Future<void> addToCart(CartItem item) async {
    // Check if item already exists in cart
    final existingItems = _box.values.where((i) => i.menuItemId == item.menuItemId);
    if (existingItems.isNotEmpty) {
      final existingItem = existingItems.first;
      existingItem.quantity += 1;
      await existingItem.save();
    } else {
      await _box.add(item);
    }
  }

  Future<void> updateQuantity(String id, int quantity) async {
    final item = _box.get(id);
    if (item != null) {
      if (quantity <= 0) {
        await item.delete();
      } else {
        item.quantity = quantity;
        await item.save();
      }
    }
  }

  Future<void> removeFromCart(String id) async {
    await _box.delete(id);
  }

  Future<void> clearCart() async {
    await _box.clear();
  }

  double getTotal() {
    return _box.values.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }
}
