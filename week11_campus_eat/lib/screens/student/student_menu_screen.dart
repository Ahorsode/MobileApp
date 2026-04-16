import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/menu_viewmodel.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../../models/menu_item.dart';
import 'cart_screen.dart';
import 'order_history_screen.dart';

class StudentMenuScreen extends StatelessWidget {
  const StudentMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = context.read<AuthViewModel>();
    final menuVM = context.watch<MenuViewModel>();
    
    final categories = ['All', 'Breakfast', 'Lunch', 'Snacks'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Eats Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
              );
            },
            tooltip: 'Order History',
          ),
          IconButton(
             icon: const Icon(Icons.logout),
            onPressed: () => authVM.signOut(),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Column(
        children: [
          // Advanced Feature C: Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for food...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (val) => menuVM.setSearchQuery(val),
            ),
          ),
          
          // Advanced Feature C: Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: categories.map((cat) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: menuVM.selectedCategory == cat,
                    onSelected: (selected) {
                      if (selected) menuVM.setCategory(cat);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          
          const Divider(),

          // Menu List
          Expanded(
            child: StreamBuilder<List<MenuItem>>(
              stream: menuVM.menuStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No menu items available."));
                }

                // Apply Filters
                final items = menuVM.filterItems(snapshot.data!);
                if (items.isEmpty) {
                  return const Center(child: Text("No items match your search/filter."));
                }

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
                            bool isOutOfStock = item.stock <= 0;

                            return ListTile(
                              leading: Image.network(item.imageUrl, width: 60, height: 60, fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, size: 50),
                              ),
                              title: Text(item.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('\$${item.price.toStringAsFixed(2)} | Stock: ${item.stock}'),
                                  if (item.ratingCount > 0)
                                    Row(
                                      children: [
                                        const Icon(Icons.star, size: 14, color: Colors.amber),
                                        Text(' ${item.averageRating.toStringAsFixed(1)} (${item.ratingCount})', style: const TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.add_shopping_cart),
                                color: isOutOfStock ? Colors.grey : Theme.of(context).primaryColor,
                                onPressed: isOutOfStock ? null : () {
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
          ),
        ],
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
