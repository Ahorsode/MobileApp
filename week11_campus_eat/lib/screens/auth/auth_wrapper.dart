import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'login_signup_screen.dart';
import '../admin/admin_dashboard_screen.dart';
import '../student/student_menu_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    // 1. If loading, show a centered progress indicator
    if (authViewModel.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
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
