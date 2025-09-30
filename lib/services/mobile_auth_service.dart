import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class MobileAuthService {
  static final MobileAuthService _instance = MobileAuthService._internal();
  factory MobileAuthService() => _instance;
  MobileAuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to listen to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user
  User? get currentUser => _auth.currentUser;

  // User role detection based on email patterns
  String detectUserRole(String email) {
    final emailLower = email.toLowerCase();
    
    // Admin emails
    if (emailLower.contains('admin') || 
        emailLower.contains('@neuroguard.com') ||
        emailLower.contains('@hospital.admin')) {
      return 'admin';
    }
    
    // Clinician/Doctor emails
    if (emailLower.contains('dr.') || 
        emailLower.contains('doctor') ||
        emailLower.contains('@clinic.') ||
        emailLower.contains('@hospital.') ||
        emailLower.contains('@medical.') ||
        emailLower.contains('@healthcare.') ||
        emailLower.contains('@neurology.') ||
        emailLower.contains('@epilepsy.')) {
      return 'clinician';
    }
    
    // Caregiver emails (family members, nurses, etc.)
    if (emailLower.contains('caregiver') ||
        emailLower.contains('nurse') ||
        emailLower.contains('family') ||
        emailLower.contains('@care.') ||
        emailLower.contains('@support.')) {
      return 'caregiver';
    }
    
    // Default to patient
    return 'patient';
  }

  // Sign up with email and password
  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
    String? role,
  }) async {
    try {
      // Create user with Firebase Auth
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) {
        throw Exception('Failed to create user');
      }

      // Update display name
      await user.updateDisplayName(name);

      // Detect role if not provided
      final detectedRole = role ?? detectUserRole(email);

      // Create user document in Firestore
      final userData = {
        'uid': user.uid,
        'name': name,
        'email': email,
        'role': detectedRole,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
        'isActive': true,
      };

      // Add role-specific fields
      if (detectedRole == 'caregiver') {
        userData['patients'] = <String>[];
      } else if (detectedRole == 'clinician') {
        userData['patients'] = <String>[];
        userData['specialization'] = 'Neurology';
        userData['licenseNumber'] = '';
      } else if (detectedRole == 'admin') {
        userData['permissions'] = <String>['all'];
      }

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userData, SetOptions(merge: true));

      return {
        'success': true,
        'user': userData,
        'message': 'Account created successfully! Role detected: ${detectedRole.toUpperCase()}',
      };
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred during sign up';
      switch (e.code) {
        case 'weak-password':
          message = 'Password is too weak. Please choose a stronger password.';
          break;
        case 'email-already-in-use':
          message = 'An account already exists with this email address.';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;
        default:
          message = e.message ?? 'An error occurred during sign up';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
      };
    }
  }

  // Sign in with email and password
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) {
        throw Exception('Failed to sign in');
      }

      // Update last login timestamp
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({'lastLogin': FieldValue.serverTimestamp()});

      // Get user data from Firestore
      final DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        return {
          'success': true,
          'user': userData,
          'message': 'Signed in successfully!',
        };
      } else {
        // If user document doesn't exist, create it with detected role
        final detectedRole = detectUserRole(email);
        final userData = {
          'uid': user.uid,
          'name': user.displayName ?? 'User',
          'email': email,
          'role': detectedRole,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
          'isActive': true,
        };

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userData, SetOptions(merge: true));

        return {
          'success': true,
          'user': userData,
          'message': 'Signed in successfully! Role detected: ${detectedRole.toUpperCase()}',
        };
      }
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred during sign in';
      switch (e.code) {
        case 'user-not-found':
          message = 'No account found with this email address.';
          break;
        case 'wrong-password':
          message = 'Incorrect password. Please try again.';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;
        case 'user-disabled':
          message = 'This account has been disabled.';
          break;
        default:
          message = e.message ?? 'An error occurred during sign in';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
      };
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out: $e');
      }
    }
  }

  // Reset password
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {
        'success': true,
        'message': 'Password reset email sent. Please check your inbox.',
      };
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred while sending reset email';
      switch (e.code) {
        case 'user-not-found':
          message = 'No account found with this email address.';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;
        default:
          message = e.message ?? 'An error occurred while sending reset email';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
      };
    }
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user data: $e');
      }
      return null;
    }
  }
}
