import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../theme/app_theme.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true;

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  String _selectedCafeteria = 'Oyibi';

  void _submit() async {
    final authViewModel = context.read<AuthViewModel>();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorSnackBar('Please fill in all fields');
      return;
    }

    try {
      if (_isLogin) {
        await authViewModel.signIn(email, password);
      } else {
        await authViewModel.signUp(email, password, _selectedCafeteria);
      }
    } catch (e) {
      if (mounted) _showErrorSnackBar(e.toString());
    }
  }

  void _loginAsGuest() async {
    final authViewModel = context.read<AuthViewModel>();
    bool success = await authViewModel.signInAsGuest();
    
    if (!success && mounted) {
      _showErrorSnackBar(authViewModel.errorMessage ?? 'Could not login as guest');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = context.watch<AuthViewModel>().isLoading;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Decorative background elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primary.withOpacity(0.05),
              ),
            ),
          ).animate().scale(duration: 1000.ms, curve: Curves.easeOutBack),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Animated Logo
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.restaurant_menu,
                          size: 60,
                          color: AppTheme.primary,
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .scale(delay: 200.ms, duration: 400.ms, curve: Curves.easeOutBack),
                    ),
                    const SizedBox(height: 24),
                    
                    // Title
                    Text(
                      'Campus Eats',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displayLarge,
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                    
                    const SizedBox(height: 8),
                    Text(
                      _isLogin ? 'Welcome back! Your food is waiting.' : 'Join the campus food revolution.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
                    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
                    
                    const SizedBox(height: 48),

                    // Inputs with animations
                    Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'Email Address',
                            prefixIcon: Icon(Icons.alternate_email_rounded),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline_rounded),
                          ),
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _submit(),
                        ),
                        if (!_isLogin) ...[
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedCafeteria,
                            decoration: const InputDecoration(
                              hintText: 'Select Cafeteria',
                              prefixIcon: Icon(Icons.location_on_outlined),
                            ),
                            items: ['Oyibi', 'Techiman', 'Kumasi'].map((loc) {
                              return DropdownMenuItem(value: loc, child: Text(loc));
                            }).toList(),
                            onChanged: (val) => setState(() => _selectedCafeteria = val!),
                          ),
                        ],
                      ],
                    ).animate().fadeIn(delay: 800.ms).slideX(begin: -0.1),
                    
                    const SizedBox(height: 32),

                    // Action Buttons
                    if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      ElevatedButton(
                        onPressed: _submit,
                        child: Text(_isLogin ? 'Sign In' : 'Create Account'),
                      ).animate().fadeIn(delay: 1000.ms).scale(),
                      
                      const SizedBox(height: 16),
                      
                      // Toggle Login / Signup
                      TextButton(
                        onPressed: () => setState(() => _isLogin = !_isLogin),
                        child: RichText(
                          text: TextSpan(
                            style: theme.textTheme.bodyMedium,
                            children: [
                              TextSpan(text: _isLogin ? "New here? " : "Joined already? "),
                              TextSpan(
                                text: _isLogin ? "Create Account" : "Sign In",
                                style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: 1200.ms),
                    ],

                    const SizedBox(height: 24),
                    
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade200, thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('OR', style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade200, thickness: 1)),
                      ],
                    ).animate().fadeIn(delay: 1400.ms),
                    
                    const SizedBox(height: 24),

                    // Guest Login
                    OutlinedButton.icon(
                      onPressed: isLoading ? null : _loginAsGuest,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        side: BorderSide(color: Colors.grey.shade200, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: Icon(Icons.person_outline_rounded, color: AppTheme.textSecondary),
                      label: Text(
                        'Continue as Guest',
                        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ).animate().fadeIn(delay: 1600.ms),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
