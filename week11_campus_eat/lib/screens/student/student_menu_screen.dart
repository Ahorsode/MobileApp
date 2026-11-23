import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/menu_viewmodel.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../../models/menu_item.dart';
import '../../theme/app_theme.dart';
import 'cart_screen.dart';
import 'order_history_screen.dart';
import '../profile/profile_screen.dart';

class StudentMenuScreen extends StatelessWidget {
  const StudentMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = context.read<AuthViewModel>();
    final menuVM = context.watch<MenuViewModel>();
    final theme = Theme.of(context);
    
    final categories = ['All', 'Breakfast', 'Lunch', 'Snacks'];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Premium Sliver App Bar
          SliverAppBar(
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            stretch: true,
            backgroundColor: AppTheme.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Text(
                        (authVM.currentUser?.name.isNotEmpty == true 
                            ? authVM.currentUser!.name[0] 
                            : (authVM.currentUser?.email.isNotEmpty == true ? authVM.currentUser!.email[0] : 'U')).toUpperCase(),
                        style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
              title: Text(
                'Campus Eats',
                style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=2070&auto=format&fit=crop',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          AppTheme.primary.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildSyncIndicator(),
                        const SizedBox(height: 12),
                        ClipRRect(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: AppTheme.glassDecoration(),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on_rounded, color: AppTheme.primary),
                                const SizedBox(width: 12),
                                Text(
                                  'Delivering to ${context.watch<AuthViewModel>().currentUser?.cafeteria ?? 'Loading...'}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Modern Search & Filter
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fresh food for you',
                    style: theme.textTheme.displayLarge?.copyWith(fontSize: 24),
                  ).animate().fadeIn().slideX(begin: -0.2),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search for dishes...',
                            prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primary),
                            fillColor: Colors.white,
                          ),
                          onChanged: (val) => menuVM.setSearchQuery(val),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => _showFilterSheet(context, menuVM),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.tune_rounded, color: Colors.white),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.95, 0.95)),
                  const SizedBox(height: 24),
                  
                  // Cafeteria Selector
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['Oyibi', 'Techiman', 'Kumasi'].map((loc) {
                        final isSel = menuVM.selectedCafeteria == loc;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: ChoiceChip(
                            label: Text(loc),
                            selected: isSel,
                            onSelected: (_) => menuVM.setCafeteria(loc),
                            selectedColor: AppTheme.primary,
                            labelStyle: TextStyle(color: isSel ? Colors.white : AppTheme.textPrimary),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: categories.map((cat) {
                        final isSelected = menuVM.selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: GestureDetector(
                            onTap: () => menuVM.setCategory(cat),
                            child: AnimatedContainer(
                              duration: 300.ms,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? AppTheme.primary : Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  if (isSelected)
                                    BoxShadow(
                                      color: AppTheme.primary.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    )
                                  else
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    )
                                ],
                              ),
                              child: Text(
                                cat,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: isSelected ? Colors.white : AppTheme.textPrimary,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Menu Content
          StreamBuilder<List<MenuItem>>(
            stream: menuVM.menuStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyState(context, "No dishes found");
              }

              final items = menuVM.filterItems(snapshot.data!);
              if (items.isEmpty) return _buildEmptyState(context, "No matches found");

              final groupedItems = menuVM.groupItemsByCategory(items);

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      String category = groupedItems.keys.elementAt(index);
                      List<MenuItem> categoryItems = groupedItems[category]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 32, bottom: 16),
                            child: Row(
                              children: [
                                Text(category, style: theme.textTheme.titleLarge),
                                const SizedBox(width: 8),
                                Container(
                                  width: 40,
                                  height: 2,
                                  color: AppTheme.primary.withOpacity(0.3),
                                ),
                              ],
                            ),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: categoryItems.length,
                            itemBuilder: (context, itemIndex) {
                              final item = categoryItems[itemIndex];
                              return _buildMenuCard(context, item, theme);
                            },
                          ),
                        ],
                      ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.1);
                    },
                    childCount: groupedItems.keys.length,
                  ),
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: _buildFloatingCart(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showFilterSheet(BuildContext context, MenuViewModel menuVM) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Filter by Price', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  RangeSlider(
                    values: menuVM.priceRange,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    activeColor: AppTheme.primary,
                    inactiveColor: Colors.grey.shade200,
                    labels: RangeLabels(
                      '\$${menuVM.priceRange.start.round()}',
                      '\$${menuVM.priceRange.end.round()}',
                    ),
                    onChanged: (values) {
                      setModalState(() => menuVM.setPriceRange(values));
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$0', style: TextStyle(color: Colors.grey.shade600)),
                      Text('\$100', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Apply Filters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMenuCard(BuildContext context, MenuItem item, ThemeData theme) {
    bool isOutOfStock = item.stock <= 0;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.premiumShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(color: Colors.grey.shade100, child: const Icon(Icons.fastfood, color: Colors.grey)),
                  ),
                  if (isOutOfStock)
                    Container(
                      color: Colors.black.withOpacity(0.6),
                      child: const Center(child: Text('SOLD OUT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 14, color: AppTheme.secondary),
                          Text(
                            ' ${item.averageRating.toStringAsFixed(1)}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
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
                          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: theme.textTheme.titleLarge?.copyWith(color: AppTheme.primary, fontSize: 18),
                        ),
                        GestureDetector(
                          onTap: isOutOfStock ? null : () {
                            context.read<CartViewModel>().addItem(item);
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${item.name} added to cart!'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: AppTheme.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                duration: 1.seconds,
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isOutOfStock ? Colors.grey.shade200 : AppTheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.add_rounded,
                              color: isOutOfStock ? Colors.grey : Colors.white,
                              size: 20,
                            ),
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
      ),
    );
  }

  Widget _buildFloatingCart(BuildContext context) {
    return Consumer<CartViewModel>(
      builder: (context, cartVM, child) {
        if (cartVM.itemCount == 0) return const SizedBox.shrink();
        return FloatingActionButton.extended(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen())),
          backgroundColor: AppTheme.primary,
          elevation: 8,
          label: Row(
            children: [
              const Icon(Icons.shopping_bag_rounded, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                '${cartVM.itemCount} Items • \$${cartVM.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white70),
            ],
          ),
        ).animate().slideY(begin: 1, duration: 400.ms, curve: Curves.easeOutBack);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_rounded, size: 80, color: Colors.grey.shade200),
            const SizedBox(height: 16),
            Text(message, style: TextStyle(color: Colors.grey.shade400, fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncIndicator() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('offline_orders').listenable(),
      builder: (context, Box box, widget) {
        if (box.isEmpty) return const SizedBox.shrink();
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.amber.shade700,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.sync_problem_rounded, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                '${box.length} order(s) pending sync',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
        ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2000.ms);
      },
    );
  }
}
