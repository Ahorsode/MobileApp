import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../services/menu_service.dart';
import '../../models/menu_item.dart';
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
    const AdminOrdersScreen(),
    const AdminMenuScreen(),
  ];

  final MenuService _menuService = MenuService();

  @override
  Widget build(BuildContext context) {
    final authVM = context.read<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authVM.signOut(),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Column(
        children: [
          // Advanced Feature E: Low Stock Alerts Banner (Global across Admin Panel)
          StreamBuilder<List<MenuItem>>(
            stream: _menuService.getMenuItemsStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final lowStockItems = snapshot.data!.where((item) => item.stock < 5).toList();
                
                if (lowStockItems.isNotEmpty) {
                  // Simulate an alert logging to the console
                  print("⚠️ STOCK ALERT: ${lowStockItems.map((i) => "${i.name} (${i.stock})").join(', ')}");

                  // UI Banner
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.red.shade100,
                    width: double.infinity,
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Low Stock: ${lowStockItems.length} items require your attention!',
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),
          
          Expanded(child: _screens[_currentIndex]),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Manage Menu'),
        ],
      ),
    );
  }
}
