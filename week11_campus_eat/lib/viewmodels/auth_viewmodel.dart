import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthViewModel() {
    // Check initial auth state
    _authService.userStream.listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        await fetchUserData(firebaseUser.uid);
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  // Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
  }

  // Fetch user data from Firestore
  Future<void> fetchUserData(String uid) async {
    _currentUser = await _authService.getUserData(uid);
    notifyListeners();
  }

  // Sign Up
  Future<bool> signUp(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _currentUser = await _authService.signUp(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  // Sign In
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.signIn(email, password);
      // Data will be fetched via the listener in the constructor
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  // Sign In as Guest
  Future<bool> signInAsGuest() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.signInAnonymously();
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
