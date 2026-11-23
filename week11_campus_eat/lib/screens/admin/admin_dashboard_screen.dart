import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../services/menu_service.dart';
import '../../models/menu_item.dart';
import '../../theme/app_theme.dart';
import 'admin_menu_screen.dart';
import 'admin_orders_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    AdminOrdersScreen(),
    const AdminMenuScreen(),
  ];

  final MenuService _menuService = MenuService();

  @override
  Widget build(BuildContext context) {
    final authVM = context.read<AuthViewModel>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Admin Console', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primary, AppTheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome_rounded),
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Seeding Ghanaian Menu...'), behavior: SnackBarBehavior.floating),
              );
              await _menuService.seedGhanaianMenu(force: true);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Menu Seeded Successfully!'), 
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              }
            },
            tooltip: 'Seed Ghanaian Menu',
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => authVM.signOut(),
            tooltip: 'Sign Out',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<List<MenuItem>>(
            stream: _menuService.getMenuItemsStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final lowStockItems = snapshot.data!.where((item) => item.stock < 5).toList();
                
                if (lowStockItems.isNotEmpty) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.red.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.red.shade400, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${lowStockItems.length} items are low on stock!',
                            style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() => _currentIndex = 1);
                          },
                          child: Text('VIEW', style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w900, fontSize: 12)),
                        ),
                      ],
                    ),
                  ).animate().shake(delay: 500.ms);
                }
              }
              return const SizedBox.shrink();
            },
          ),
          
          Expanded(
            child: AnimatedSwitcher(
              duration: 300.ms,
              child: _screens[_currentIndex],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: Colors.grey.shade400,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.receipt_long_rounded),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.receipt_long_rounded),
              ),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.restaurant_menu_rounded),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.restaurant_menu_rounded),
              ),
              label: 'Menu',
            ),
          ],
        ),
      ),
    );
  }
}
