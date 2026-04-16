import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../../viewmodels/checkout_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
               context.read<CartViewModel>().clearCart();
            },
            tooltip: 'Clear Cart',
          ),
        ],
      ),
      body: Consumer<CartViewModel>(
        builder: (context, cartVM, child) {
          if (!cartVM.isLoaded || cartVM.items.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartVM.items.length,
                  itemBuilder: (context, index) {
                    final item = cartVM.items[index];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => cartVM.updateQuantity(item.id, item.quantity - 1),
                          ),
                          Text('${item.quantity}'),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => cartVM.updateQuantity(item.id, item.quantity + 1),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 1, blurRadius: 5)
                  ]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total: \$${cartVM.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Consumer<CheckoutViewModel>(
                      builder: (context, checkoutVM, child) {
                        return ElevatedButton(
                          onPressed: checkoutVM.isLoading || cartVM.items.isEmpty
                              ? null
                              : () async {
                                  final authVM = context.read<AuthViewModel>();
                                  if (authVM.user == null) return;
                                  
                                  bool success = await checkoutVM.processCheckout(authVM.user!.uid, cartVM.items, cartVM.totalAmount);
                                  
                                  if (success && context.mounted) {
                                    cartVM.clearCart();
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order placed successfully!')));
                                    Navigator.pop(context);
                                  } else if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(checkoutVM.errorMessage), backgroundColor: Colors.red));
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                          child: checkoutVM.isLoading 
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Text('Checkout'),
                        );
                      }
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
