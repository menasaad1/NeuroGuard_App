import 'package:flutter/material.dart';

class MockAuthService {
  static final MockAuthService _instance = MockAuthService._internal();
  factory MockAuthService() => _instance;
  MockAuthService._internal();

  // Mock current user
  Map<String, dynamic>? _currentUser;

  // Mock auth state changes stream
  Stream<Map<String, dynamic>?> get authStateChanges async* {
    yield _currentUser;
  }

  // Sign in with email and password (mock)
  Future<Map<String, dynamic>?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock users for testing
    final mockUsers = {
      'admin@neuroguard.com': {
        'uid': 'admin_001',
        'name': 'مدير النظام',
        'email': 'admin@neuroguard.com',
        'role': 'admin',
        'isActive': true,
      },
      'doctor@neuroguard.com': {
        'uid': 'doctor_001',
        'name': 'د. أحمد محمد',
        'email': 'doctor@neuroguard.com',
        'role': 'clinician',
        'isActive': true,
      },
      'caregiver@neuroguard.com': {
        'uid': 'caregiver_001',
        'name': 'فاطمة أحمد',
        'email': 'caregiver@neuroguard.com',
        'role': 'caregiver',
        'isActive': true,
      },
      'patient@neuroguard.com': {
        'uid': 'patient_001',
        'name': 'سارة محمد',
        'email': 'patient@neuroguard.com',
        'role': 'patient',
        'isActive': true,
      },
    };

    // Check if user exists
    if (mockUsers.containsKey(email) && password == 'password123') {
      _currentUser = mockUsers[email];
      return _currentUser;
    }

    throw 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
  }

  // Sign up with email and password (mock)
  Future<Map<String, dynamic>?> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Validate input
    if (name.length < 2) {
      throw 'الاسم يجب أن يكون حرفين على الأقل';
    }
    if (!email.contains('@')) {
      throw 'البريد الإلكتروني غير صحيح';
    }
    if (password.length < 6) {
      throw 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }

    // Create new user
    final newUser = {
      'uid': 'user_${DateTime.now().millisecondsSinceEpoch}',
      'name': name,
      'email': email,
      'role': role,
      'isActive': true,
      'createdAt': DateTime.now().toIso8601String(),
    };

    _currentUser = newUser;
    return newUser;
  }

  // Sign out
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentUser;
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? name,
    String? email,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (_currentUser != null) {
      if (name != null) _currentUser!['name'] = name;
      if (email != null) _currentUser!['email'] = email;
      _currentUser!['updatedAt'] = DateTime.now().toIso8601String();
    }
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (currentPassword != 'password123') {
      throw 'كلمة المرور الحالية غير صحيحة';
    }
    
    if (newPassword.length < 6) {
      throw 'كلمة المرور الجديدة يجب أن تكون 6 أحرف على الأقل';
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!email.contains('@')) {
      throw 'البريد الإلكتروني غير صحيح';
    }
    
    // In a real app, this would send an email
    print('Password reset email sent to: $email');
  }

  // Delete user account
  Future<void> deleteAccount(String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (password != 'password123') {
      throw 'كلمة المرور غير صحيحة';
    }
    
    _currentUser = null;
  }

  // Check if user has specific role
  Future<bool> hasRole(String role) async {
    return _currentUser?['role'] == role;
  }

  // Get all users (admin only)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return [
      {
        'uid': 'admin_001',
        'name': 'مدير النظام',
        'email': 'admin@neuroguard.com',
        'role': 'admin',
        'createdAt': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
      },
      {
        'uid': 'doctor_001',
        'name': 'د. أحمد محمد',
        'email': 'doctor@neuroguard.com',
        'role': 'clinician',
        'createdAt': DateTime.now().subtract(const Duration(days: 20)).toIso8601String(),
      },
      {
        'uid': 'caregiver_001',
        'name': 'فاطمة أحمد',
        'email': 'caregiver@neuroguard.com',
        'role': 'caregiver',
        'createdAt': DateTime.now().subtract(const Duration(days: 15)).toIso8601String(),
      },
      {
        'uid': 'patient_001',
        'name': 'سارة محمد',
        'email': 'patient@neuroguard.com',
        'role': 'patient',
        'createdAt': DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
      },
    ];
  }

  // Update user role (admin only)
  Future<void> updateUserRole(String uid, String newRole) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (_currentUser?['role'] != 'admin') {
      throw 'غير مسموح لك بتحديث أدوار المستخدمين';
    }
    
    print('User $uid role updated to $newRole');
  }
}
