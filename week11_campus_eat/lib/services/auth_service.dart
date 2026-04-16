import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream of auth state changes
  Stream<User?> get userStream => _auth.authStateChanges();

  // Sign Up with Email and Password
  Future<UserModel?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        // Create a corresponding document in Firestore
        UserModel newUser = UserModel(
          uid: user.uid,
          email: email,
          isAdmin: false, // Default to false
          totalOrders: 0, // Default to 0
          isGuest: false,
        );

        await _db.collection('users').doc(user.uid).set(newUser.toMap());
        return newUser;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e.code));
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  // Log In with Email and Password
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e.code));
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  // Continue as Guest (Anonymous Login)
  Future<void> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;

      if (user != null) {
        UserModel guestUser = UserModel(
          uid: user.uid,
          email: 'Guest',
          isAdmin: false,
          totalOrders: 0,
          isGuest: true,
        );
        await _db.collection('users').doc(user.uid).set(guestUser.toMap());
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e.code));
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password provided.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'invalid-credential':
        return 'Invalid credentials. Please verify your email and password.';
      case 'weak-password':
        return 'The password provided is too weak (min. 6 characters).';
      default:
        return 'Authentication failed: $code';
    }
  }

  // Log Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Fetch User Role and Data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
