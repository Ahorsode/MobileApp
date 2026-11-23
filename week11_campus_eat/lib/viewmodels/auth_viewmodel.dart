import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../services/notification_service.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final NotificationService _notificationService = NotificationService();
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthViewModel() {
    _authService.userStream.listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        _currentUser = await _authService.getUserData(firebaseUser.uid);
        if (_currentUser != null) {
          String? token = await _notificationService.getToken();
          if (token != null && token != _currentUser!.fcmToken) {
            await _authService.updateUserData(_currentUser!.uid, {'fcmToken': token});
            _currentUser = _currentUser!.copyWith(fcmToken: token);
          }
          _notificationService.monitorOrders(_currentUser!.uid, _currentUser!.isAdmin, _currentUser!.cafeteria);
        }
      } else {
        _currentUser = null;
      }
      notifyListeners();
    });
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
  }

  // Fetch user data from Firestore
  Future<void> fetchUserData(String uid) async {
    final fetchedUser = await _authService.getUserData(uid);
    if (fetchedUser != null) {
      _currentUser = fetchedUser;
      notifyListeners();
    }
  }

  // Sign Up
  Future<bool> signUp(String email, String password, String cafeteria) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _currentUser = await _authService.signUp(email, password, cafeteria);
      notifyListeners();
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
      final user = await _authService.signIn(email, password);
      if (user == null) {
        throw Exception("User data not found returning from database.");
      }
      _currentUser = user;
      notifyListeners();
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
      final user = await _authService.signInAnonymously();
      if (user == null) {
        throw Exception("Failed to initialize Guest Mode session.");
      }
      _currentUser = user;
      notifyListeners();
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

  // Update Profile
  Future<bool> updateProfile({String? name, String? phoneNumber, String? cafeteria}) async {
    if (_currentUser == null) return false;
    
    _setLoading(true);
    try {
      final Map<String, dynamic> updates = {};
      if (name != null) updates['name'] = name;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
      if (cafeteria != null) updates['cafeteria'] = cafeteria;

      if (updates.isNotEmpty) {
        await _authService.updateUserData(_currentUser!.uid, updates);
        _currentUser = _currentUser!.copyWith(
          name: name,
          phoneNumber: phoneNumber,
          cafeteria: cafeteria,
        );
        notifyListeners();
      }
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }
}
