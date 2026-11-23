import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream of auth state changes
  Stream<User?> get userStream => _auth.authStateChanges();

  // Sign Up with Email and Password
  Future<UserModel?> signUp(String email, String password, String cafeteria) async {
    try {
      print('DEBUG: Attempting to create user with email: $email');
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        print('DEBUG: User created successfully. UID: ${user.uid}. Creating Firestore document...');
        // Create a corresponding document in Firestore
        UserModel newUser = UserModel(
          uid: user.uid,
          email: email,
          isAdmin: email == 'admin@gmail.com', // Set as admin if email matches
          totalOrders: 0,
          isGuest: false,
          cafeteria: cafeteria,
        );

        await _db.collection('users').doc(user.uid).set(newUser.toMap());
        print('DEBUG: Firestore document created successfully.');
        return newUser;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print('DEBUG: FirebaseAuthException during signUp: ${e.code} - ${e.message}');
      throw Exception(_mapFirebaseError(e.code));
    } on FirebaseException catch (e) {
      print('DEBUG: FirebaseException (Firestore) during signUp: ${e.code} - ${e.message}');
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      print('DEBUG: Unexpected error during signUp: $e');
      throw Exception('An unexpected error occurred.');
    }
  }

  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  // Log In with Email and Password
  Future<UserModel?> signIn(String email, String password) async {
    try {
      print('DEBUG: Attempting login for: $email');
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (result.user != null) {
        print('DEBUG: Auth successful. Fetching Firestore data for: ${result.user!.uid}');
        return await getUserData(result.user!.uid);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print('DEBUG: FirebaseAuthException during signIn: ${e.code} - ${e.message}');
      throw Exception(_mapFirebaseError(e.code));
    } catch (e) {
      print('DEBUG: Unexpected error during signIn: $e');
      throw Exception('An unexpected error occurred.');
    }
  }

  // Continue as Guest (Anonymous Login)
  Future<UserModel?> signInAnonymously() async {
    try {
      print('DEBUG: Attempting anonymous sign-in...');
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;

      if (user != null) {
        print('DEBUG: Anonymous sign-in successful. Creating guest document...');
        UserModel guestUser = UserModel(
          uid: user.uid,
          email: 'Guest',
          isAdmin: false,
          totalOrders: 0,
          isGuest: true,
        );
        await _db.collection('users').doc(user.uid).set(guestUser.toMap());
        print('DEBUG: Guest document created.');
        return guestUser;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print('DEBUG: FirebaseAuthException during signInAnonymously: ${e.code} - ${e.message}');
      throw Exception(_mapFirebaseError(e.code));
    } on FirebaseException catch (e) {
      print('DEBUG: FirebaseException (Firestore) during signInAnonymously: ${e.code} - ${e.message}');
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      print('DEBUG: Unexpected error during signInAnonymously: $e');
      throw Exception('An unexpected error occurred.');
    }
  }

  // Seed Admin User (Creates if not exists)
  Future<void> seedAdminUser() async {
    const adminEmail = 'admin@gmail.com';
    const adminPassword = 'admin123';

    try {
      print('DEBUG: Seeding Admin user...');
      // 1. Try to sign in to see if user exists
      UserCredential result;
      try {
        result = await _auth.signInWithEmailAndPassword(
          email: adminEmail,
          password: adminPassword,
        );
        print('DEBUG: Admin user already exists. Checking Firestore document...');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
          // 2. Create user if not found
          print('DEBUG: Admin user not found. Creating account...');
          result = await _auth.createUserWithEmailAndPassword(
            email: adminEmail,
            password: adminPassword,
          );
        } else {
          rethrow;
        }
      }

      User? user = result.user;
      if (user != null) {
        // 3. Ensure Firestore document has isAdmin: true
        DocumentSnapshot doc = await _db.collection('users').doc(user.uid).get();
        if (!doc.exists || (doc.data() as Map<String, dynamic>)['isAdmin'] != true) {
          print('DEBUG: Updating Firestore for Admin user...');
          UserModel adminUser = UserModel(
            uid: user.uid,
            email: adminEmail,
            isAdmin: true,
            totalOrders: 0,
            isGuest: false,
          );
          await _db.collection('users').doc(user.uid).set(adminUser.toMap());
        }
        print('DEBUG: Admin seed completed successfully.');
      }
    } catch (e) {
      print('DEBUG: Error seeding admin user: $e');
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
