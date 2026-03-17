import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';

void main() async {
  // Ensure Flutter bindings are initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (Part D requirement)
  // Note: For real apps, you'd need google-services.json/GoogleService-Info.plist
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Midsem Exam App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      // Set LoginScreen as the home of the app (Part D requirement)
      home: LoginScreen(),
    );
  }
}
