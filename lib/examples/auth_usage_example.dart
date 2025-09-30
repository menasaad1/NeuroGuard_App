// Example usage of Firebase Authentication Service
// This file demonstrates how to use the FirebaseAuthService

import '../services/firebase_auth_service.dart';

class AuthUsageExample {
  final FirebaseAuthService _authService = FirebaseAuthService();

  // Example: Sign up a new user
  Future<void> signUpExample() async {
    final result = await _authService.signUp(
      name: 'Dr. Ahmed Hassan',
      email: 'dr.ahmed@neurology.clinic.com',
      password: 'securePassword123',
      role: 'clinician', // Optional - will be auto-detected from email
    );

    if (result['success']) {
      print('User created successfully!');
      print('User data: ${result['user']}');
      print('Message: ${result['message']}');
    } else {
      print('Sign up failed: ${result['message']}');
    }
  }

  // Example: Sign in an existing user
  Future<void> signInExample() async {
    final result = await _authService.signIn(
      email: 'dr.ahmed@neurology.clinic.com',
      password: 'securePassword123',
    );

    if (result['success']) {
      print('Signed in successfully!');
      print('User data: ${result['user']}');
    } else {
      print('Sign in failed: ${result['message']}');
    }
  }

  // Example: Reset password
  Future<void> resetPasswordExample() async {
    final result = await _authService.resetPassword('user@example.com');
    
    if (result['success']) {
      print('Password reset email sent!');
    } else {
      print('Reset failed: ${result['message']}');
    }
  }

  // Example: Update user profile
  Future<void> updateProfileExample() async {
    final result = await _authService.updateProfile(
      name: 'Dr. Ahmed Hassan (Updated)',
      email: 'ahmed.hassan@neurology.clinic.com',
    );

    if (result['success']) {
      print('Profile updated successfully!');
    } else {
      print('Update failed: ${result['message']}');
    }
  }

  // Example: Get current user data
  Future<void> getCurrentUserExample() async {
    final user = _authService.currentUser;
    if (user != null) {
      final userData = await _authService.getUserData(user.uid);
      print('Current user data: $userData');
    } else {
      print('No user signed in');
    }
  }

  // Example: Sign out
  Future<void> signOutExample() async {
    await _authService.signOut();
    print('User signed out');
  }

  // Example: Listen to auth state changes
  void listenToAuthChanges() {
    _authService.authStateChanges.listen((user) {
      if (user != null) {
        print('User signed in: ${user.email}');
      } else {
        print('User signed out');
      }
    });
  }
}

// Email role detection examples:
void emailRoleDetectionExamples() {
  final authService = FirebaseAuthService();
  
  // These will be detected as different roles:
  print('Admin: ${authService.detectUserRole('admin@neuroguard.com')}');
  print('Admin: ${authService.detectUserRole('user@hospital.admin')}');
  
  print('Clinician: ${authService.detectUserRole('dr.smith@clinic.com')}');
  print('Clinician: ${authService.detectUserRole('doctor@hospital.com')}');
  print('Clinician: ${authService.detectUserRole('specialist@medical.com')}');
  
  print('Caregiver: ${authService.detectUserRole('nurse@care.com')}');
  print('Caregiver: ${authService.detectUserRole('caregiver@support.com')}');
  
  print('Patient: ${authService.detectUserRole('patient@example.com')}');
  print('Patient: ${authService.detectUserRole('user@gmail.com')}');
}
