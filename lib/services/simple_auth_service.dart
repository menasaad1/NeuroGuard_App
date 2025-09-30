import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SimpleAuthService {
  static final SimpleAuthService _instance = SimpleAuthService._internal();
  factory SimpleAuthService() => _instance;
  SimpleAuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<Map<String, dynamic>?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Get user data from Firestore
        final userData = await _getUserData(userCredential.user!.uid);
        return userData;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';
    }
  }

  // Sign up with email and password
  Future<Map<String, dynamic>?> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Update display name
        await userCredential.user!.updateDisplayName(name);

        // Create user document in Firestore
        final userData = {
          'uid': userCredential.user!.uid,
          'name': name,
          'email': email,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
          'isActive': true,
        };

        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userData);

        return userData;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'حدث خطأ أثناء تسجيل الخروج. يرجى المحاولة مرة أخرى.';
    }
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> _getUserData(String uid) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'uid': uid,
          'name': data['name'] ?? '',
          'email': data['email'] ?? '',
          'role': data['role'] ?? 'patient',
          'isActive': data['isActive'] ?? true,
        };
      }
      return null;
    } catch (e) {
      throw 'حدث خطأ في جلب بيانات المستخدم. يرجى المحاولة مرة أخرى.';
    }
  }

  // Public method to get user data
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    return await _getUserData(uid);
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? name,
    String? email,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw 'المستخدم غير مسجل الدخول';

      if (name != null) {
        await user.updateDisplayName(name);
      }

      if (email != null) {
        await user.updateEmail(email);
      }

      // Update Firestore document
      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (email != null) updateData['email'] = email;
      updateData['updatedAt'] = FieldValue.serverTimestamp();

      if (updateData.isNotEmpty) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .update(updateData);
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw 'المستخدم غير مسجل الدخول';

      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'حدث خطأ في إرسال رابط إعادة تعيين كلمة المرور. يرجى المحاولة مرة أخرى.';
    }
  }

  // Delete user account
  Future<void> deleteAccount(String password) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw 'المستخدم غير مسجل الدخول';

      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      // Delete user document from Firestore
      await _firestore.collection('users').doc(user.uid).delete();

      // Delete user account
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  // Handle Firebase Auth exceptions and return Arabic error messages
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'لا يوجد مستخدم بهذا البريد الإلكتروني.';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة.';
      case 'email-already-in-use':
        return 'هذا البريد الإلكتروني مستخدم بالفعل.';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً. يجب أن تكون 6 أحرف على الأقل.';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح.';
      case 'user-disabled':
        return 'تم تعطيل هذا الحساب. يرجى التواصل مع الدعم الفني.';
      case 'too-many-requests':
        return 'تم تجاوز عدد المحاولات المسموح. يرجى المحاولة لاحقاً.';
      case 'operation-not-allowed':
        return 'هذه العملية غير مسموحة.';
      case 'invalid-credential':
        return 'بيانات الاعتماد غير صحيحة.';
      case 'requires-recent-login':
        return 'يجب تسجيل الدخول مرة أخرى لإكمال هذه العملية.';
      default:
        return 'حدث خطأ في المصادقة: ${e.message}';
    }
  }

  // Check if user has specific role
  Future<bool> hasRole(String role) async {
    try {
      final userData = await _getUserData(_auth.currentUser?.uid ?? '');
      return userData?['role'] == role;
    } catch (e) {
      return false;
    }
  }

  // Get all users (admin only)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'uid': doc.id,
          'name': data['name'] ?? '',
          'email': data['email'] ?? '',
          'role': data['role'] ?? 'patient',
          'createdAt': data['createdAt'],
        };
      }).toList();
    } catch (e) {
      throw 'حدث خطأ في جلب قائمة المستخدمين.';
    }
  }

  // Update user role (admin only)
  Future<void> updateUserRole(String uid, String newRole) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .update({
        'role': newRole,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'حدث خطأ في تحديث دور المستخدم.';
    }
  }
}
