import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../theme/app_theme.dart';
import 'login_signup_screen.dart';
import '../admin/admin_dashboard_screen.dart';
import '../student/student_menu_screen.dart';

import '../../viewmodels/menu_viewmodel.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncCafeteria();
    });
  }

  void _syncCafeteria() {
    final authVM = context.read<AuthViewModel>();
    if (authVM.currentUser != null) {
      context.read<MenuViewModel>().setCafeteria(authVM.currentUser!.cafeteria);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    // Sync cafeteria whenever user changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authViewModel.currentUser != null) {
        context.read<MenuViewModel>().setCafeteria(authViewModel.currentUser!.cafeteria);
      }
    });

    // 1. If loading, show a premium centered progress/splash
    if (authViewModel.isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primary, AppTheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.restaurant_rounded,
                  size: 64,
                  color: AppTheme.primary,
                ),
              ).animate(onPlay: (controller) => controller.repeat())
                .shimmer(duration: 1200.ms, color: AppTheme.secondary.withOpacity(0.3))
                .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), curve: Curves.easeInOut),
              const SizedBox(height: 32),
              const Text(
                'CAMPUS EATS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.5),
              const SizedBox(height: 12),
              SizedBox(
                width: 40,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
              ).animate().fadeIn(delay: 800.ms),
            ],
          ),
        ),
      );
    }

    // 2. If no user is logged in, show the Login/Signup Screen
    if (authViewModel.currentUser == null) {
      return const LoginSignupScreen();
    }

    // 3. If user is logged in, route based on their role
    if (authViewModel.currentUser!.isAdmin) {
      return const AdminDashboardScreen();
    } else {
      return const StudentMenuScreen();
    }
  }
}
