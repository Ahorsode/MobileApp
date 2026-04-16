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
      backgroundColor: Colors.grey.shade100, // Slightly off-white background to make cards pop
      body: CustomScrollView(
        slivers: [
          // Sleek Sliver App Bar
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
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
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Campus Eats',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=2070&auto=format&fit=crop', // Stock premium food image
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Search & Filter Bar (Sticky via SliverToBoxAdapter or StickyHeader, but keeping it simple with SliverList)
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'What are you craving?',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    onChanged: (val) => menuVM.setSearchQuery(val),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((cat) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: ChoiceChip(
                            label: Text(
                              cat,
                              style: TextStyle(
                                fontWeight: menuVM.selectedCategory == cat ? FontWeight.bold : FontWeight.normal,
                                color: menuVM.selectedCategory == cat ? Colors.white : Colors.black87,
                              ),
                            ),
                            selected: menuVM.selectedCategory == cat,
                            selectedColor: Theme.of(context).primaryColor,
                            backgroundColor: Colors.grey.shade200,
                            onSelected: (selected) {
                              if (selected) menuVM.setCategory(cat);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Menu Stream Items
          StreamBuilder<List<MenuItem>>(
            stream: menuVM.menuStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(child: Text("Error: ${snapshot.error}")),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyState(context, "No menu items available.");
              }

              // Apply Filters
              final items = menuVM.filterItems(snapshot.data!);
              if (items.isEmpty) {
                return _buildEmptyState(context, "No items match your search/filter.");
              }

              final groupedItems = menuVM.groupItemsByCategory(items);

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    String category = groupedItems.keys.elementAt(index);
                    List<MenuItem> categoryItems = groupedItems[category]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                          child: Text(
                            category, 
                            style: const TextStyle(
                              fontSize: 22, 
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        // Grid of modern cards
                        GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75, // Taller cards
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: categoryItems.length,
                          itemBuilder: (context, itemIndex) {
                            var item = categoryItems[itemIndex];
                            bool isOutOfStock = item.stock <= 0;

                            return Card(
                              clipBehavior: Clip.antiAlias,
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Top Image Half
                                  Expanded(
                                    flex: 3,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.network(
                                          item.imageUrl, 
                                          fit: BoxFit.cover,
                                          errorBuilder: (ctx, err, stk) => Container(
                                            color: Colors.grey.shade200,
                                            child: const Icon(Icons.fastfood, size: 50, color: Colors.grey),
                                          ),
                                        ),
                                        if (isOutOfStock)
                                          Container(
                                            color: Colors.black.withOpacity(0.6),
                                            child: const Center(
                                              child: Text('SOLD OUT', 
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  // Bottom Detail Half
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                              ),
                                              const SizedBox(height: 4),
                                              if (item.ratingCount > 0)
                                                Row(
                                                  children: [
                                                    const Icon(Icons.star, size: 14, color: Colors.amber),
                                                    Text(
                                                      ' ${item.averageRating.toStringAsFixed(1)} (${item.ratingCount})', 
                                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '\$${item.price.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w900, 
                                                  fontSize: 16,
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: isOutOfStock ? Colors.grey.shade300 : Theme.of(context).primaryColor.withOpacity(0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: IconButton(
                                                  icon: Icon(Icons.add, size: 20),
                                                  color: isOutOfStock ? Colors.grey.shade500 : Theme.of(context).primaryColor,
                                                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                                  padding: EdgeInsets.zero,
                                                  onPressed: isOutOfStock ? null : () {
                                                    context.read<CartViewModel>().addItem(item);
                                                    ScaffoldMessenger.of(context).clearSnackBars();
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text('${item.name} added to cart!'), 
                                                        duration: const Duration(seconds: 1),
                                                        behavior: SnackBarBehavior.floating,
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        // Add some space at the bottom of the last category
                        if (index == groupedItems.length - 1)
                          const SizedBox(height: 80),
                      ],
                    );
                  },
                  childCount: groupedItems.keys.length,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Consumer<CartViewModel>(
        builder: (context, cartVM, child) {
          if (cartVM.itemCount == 0) return const SizedBox.shrink(); // Hide if empty
          return FloatingActionButton.extended(
            onPressed: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            label: Text('${cartVM.itemCount} Items • \$${cartVM.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 4,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fastfood_outlined, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(fontSize: 18, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
