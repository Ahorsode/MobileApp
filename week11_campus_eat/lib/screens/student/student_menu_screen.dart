import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/menu_viewmodel.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../../models/menu_item.dart';
import 'cart_screen.dart';

class StudentMenuScreen extends StatelessWidget {
  const StudentMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = context.read<AuthViewModel>();
    final menuVM = context.read<MenuViewModel>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Eats Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authVM.signOut(),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: StreamBuilder<List<MenuItem>>(
        stream: menuVM.menuStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No menu items available currently."));
          }

          final items = snapshot.data!;
          final groupedItems = menuVM.groupItemsByCategory(items);

          return ListView.builder(
            itemCount: groupedItems.keys.length,
            itemBuilder: (context, index) {
              String category = groupedItems.keys.elementAt(index);
              List<MenuItem> categoryItems = groupedItems[category]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      category, 
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categoryItems.length,
                    itemBuilder: (context, itemIndex) {
                      var item = categoryItems[itemIndex];
                      return ListTile(
                        leading: Image.network(item.imageUrl, width: 60, height: 60, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, size: 50),
                        ),
                        title: Text(item.name),
                        subtitle: Text('\$${item.price.toStringAsFixed(2)} | Stock: ${item.stock}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: () {
                            context.read<CartViewModel>().addItem(item);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${item.name} added to cart!'), duration: const Duration(seconds: 1)),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const Divider(),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: Consumer<CartViewModel>(
        builder: (context, cartVM, child) {
          return FloatingActionButton.extended(
            onPressed: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            icon: const Icon(Icons.shopping_cart),
            label: Text('${cartVM.itemCount} Items'),
            backgroundColor: Theme.of(context).primaryColor,
          );
        },
      ),
    );
  }
}
