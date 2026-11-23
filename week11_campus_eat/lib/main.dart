import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/menu_viewmodel.dart';
import 'viewmodels/cart_viewmodel.dart';
import 'viewmodels/checkout_viewmodel.dart';
import 'services/auth_service.dart';
import 'services/menu_service.dart';
import 'screens/auth/auth_wrapper.dart';
import 'theme/app_theme.dart';

import 'services/notification_service.dart';
import 'services/sync_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Hive
  await Hive.initFlutter();

  // Initialize Services
  await NotificationService().init();
  await SyncService().init();
  
  // Seed Admin user and Menu if not exists
  final authService = FirebaseAuthService();
  await authService.seedAdminUser();
  final menuService = MenuService();
  await menuService.seedGhanaianMenu();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => MenuViewModel()),
        ChangeNotifierProxyProvider<AuthViewModel, CartViewModel>(
          create: (_) => CartViewModel()..init(),
          update: (_, auth, cart) => cart!..updateUser(auth.currentUser?.uid),
        ),
        ChangeNotifierProvider(create: (_) => CheckoutViewModel()),
      ],
      child: const CampusEatsApp(),
    ),
  );
}

class CampusEatsApp extends StatelessWidget {
  const CampusEatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Eats',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(),
    );
  }
}
