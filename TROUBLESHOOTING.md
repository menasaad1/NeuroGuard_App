# Firebase Authentication Troubleshooting Guide

## Common Compilation Issues and Solutions

### Issue 1: PromiseJsImpl Type Not Found

**Error:**
```
Type 'PromiseJsImpl' not found.
external PromiseJsImpl<void> applyActionCode(AuthJsImpl auth, String oobCode);
```

**Solution:**
This is a known issue with Firebase Auth Web package compatibility. Here are the solutions:

#### Option A: Use Compatible Package Versions
Update your `pubspec.yaml` with these specific versions:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.15.1
  firebase_auth: ^4.7.3
  cloud_firestore: ^4.8.4
  provider: ^6.1.1
  js: ^0.6.7
```

#### Option B: Clean and Rebuild
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

#### Option C: Use Mobile-Only Build
If you're only targeting mobile platforms, you can avoid web compilation issues by building for specific platforms:

```bash
# For Android only
flutter build apk

# For iOS only  
flutter build ios
```

### Issue 2: Firebase Configuration Not Found

**Error:**
```
FirebaseOptions not found
```

**Solution:**
1. Make sure you have created a Firebase project
2. Download the configuration files:
   - `google-services.json` for Android (place in `android/app/`)
   - `GoogleService-Info.plist` for iOS (place in `ios/Runner/`)
3. Update `lib/firebase_options.dart` with your actual Firebase configuration

### Issue 3: Authentication Not Working

**Common Issues:**
- Email/Password authentication not enabled in Firebase Console
- Firestore security rules blocking access
- Network connectivity issues

**Solution:**
1. Go to Firebase Console → Authentication → Sign-in method
2. Enable "Email/Password" authentication
3. Check Firestore security rules
4. Test with a simple email/password combination

## Step-by-Step Setup

### 1. Create Firebase Project
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Create project (if not done via console)
firebase projects:create neuroguard-app
```

### 2. Configure Flutter App
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your Flutter app
flutterfire configure
```

### 3. Alternative Manual Setup
If FlutterFire CLI doesn't work, manually configure:

1. **Firebase Console Setup:**
   - Create project at https://console.firebase.google.com/
   - Enable Authentication (Email/Password)
   - Enable Firestore Database
   - Add Android app with package name: `com.example.nngapp`
   - Add iOS app with bundle ID: `com.example.nngapp`

2. **Download Configuration Files:**
   - Download `google-services.json` → place in `android/app/`
   - Download `GoogleService-Info.plist` → place in `ios/Runner/`

3. **Update firebase_options.dart:**
   Replace placeholder values with your actual Firebase configuration.

### 4. Test the Setup
```bash
# Clean and rebuild
flutter clean
flutter pub get

# Test on Android
flutter run -d android

# Test on iOS (if on macOS)
flutter run -d ios
```

## Alternative Implementation (If Issues Persist)

If you continue to have compilation issues, you can use a simplified authentication approach:

### Option 1: Use SimpleAuthService
The project includes `lib/services/simple_auth_service.dart` which is a simplified version that avoids some web compilation issues.

### Option 2: Mock Authentication for Development
You can temporarily use the existing mock authentication system while setting up Firebase:

```dart
// In lib/state/app_state.dart, temporarily comment out Firebase integration
// and use the existing mock system for development
```

### Option 3: Platform-Specific Builds
Build only for the platforms you need:

```bash
# Android only
flutter build apk --release

# iOS only (macOS required)
flutter build ios --release
```

## Testing Authentication

### Test Email Patterns for Role Detection:

1. **Admin Role:**
   - `admin@neuroguard.com`
   - `user@hospital.admin`

2. **Clinician Role:**
   - `dr.smith@clinic.com`
   - `doctor@hospital.com`
   - `specialist@medical.com`

3. **Caregiver Role:**
   - `nurse@care.com`
   - `caregiver@support.com`

4. **Patient Role:**
   - `patient@example.com`
   - `user@gmail.com`

### Test Authentication Flow:
1. Sign up with different email patterns
2. Verify role detection works correctly
3. Test sign in with created accounts
4. Test password reset functionality

## Security Rules for Firestore

Add these rules to your Firestore database:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read and write their own user document
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Allow authenticated users to read other users' basic info
    match /users/{userId} {
      allow read: if request.auth != null;
    }
  }
}
```

## Getting Help

### Check Logs
```bash
# Run with verbose logging
flutter run --verbose

# Check Firebase logs
firebase functions:log
```

### Common Commands
```bash
# Clean everything
flutter clean
flutter pub get
flutter pub upgrade

# Check dependencies
flutter doctor
flutter pub deps

# Build for specific platform
flutter build apk --debug
flutter build ios --debug
```

### Resources
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)

## Success Indicators

Your setup is working correctly when:
1. ✅ App compiles without errors
2. ✅ Firebase project is created and configured
3. ✅ Authentication is enabled in Firebase Console
4. ✅ Firestore database is created
5. ✅ You can sign up with different email patterns
6. ✅ Role detection works automatically
7. ✅ Sign in/sign out works properly
8. ✅ Password reset emails are sent

If you're still having issues, try the simplified approach or focus on mobile platforms first, then add web support later.
