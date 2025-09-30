# Firebase Authentication Setup Guide

This guide will help you set up Firebase Authentication for the NeuroGuard app with professional email recognition.

## Prerequisites

1. A Google account
2. Flutter development environment set up
3. Android Studio or VS Code with Flutter extensions

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter project name: `neuroguard-app` (or your preferred name)
4. Enable Google Analytics (optional)
5. Click "Create project"

## Step 2: Enable Authentication

1. In your Firebase project, go to "Authentication" in the left sidebar
2. Click "Get started"
3. Go to "Sign-in method" tab
4. Enable "Email/Password" authentication
5. Click "Save"

## Step 3: Set up Firestore Database

1. Go to "Firestore Database" in the left sidebar
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select a location for your database
5. Click "Done"

## Step 4: Configure Flutter App

### For Android:

1. In Firebase Console, click "Add app" and select Android
2. Enter package name: `com.example.nngapp`
3. Download `google-services.json` file
4. Place it in `android/app/` directory

### For iOS:

1. In Firebase Console, click "Add app" and select iOS
2. Enter bundle ID: `com.example.nngapp`
3. Download `GoogleService-Info.plist` file
4. Place it in `ios/Runner/` directory

### For Web:

1. In Firebase Console, click "Add app" and select Web
2. Register your app with a nickname
3. Copy the Firebase configuration

## Step 5: Update Firebase Configuration

Update the `lib/firebase_options.dart` file with your actual Firebase configuration:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'your-actual-web-api-key',
  appId: 'your-actual-web-app-id',
  messagingSenderId: 'your-actual-sender-id',
  projectId: 'your-actual-project-id',
  authDomain: 'your-actual-project-id.firebaseapp.com',
  storageBucket: 'your-actual-project-id.appspot.com',
);

static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'your-actual-android-api-key',
  appId: 'your-actual-android-app-id',
  messagingSenderId: 'your-actual-sender-id',
  projectId: 'your-actual-project-id',
  storageBucket: 'your-actual-project-id.appspot.com',
);

static const FirebaseOptions ios = FirebaseOptions(
  apiKey: 'your-actual-ios-api-key',
  appId: 'your-actual-ios-app-id',
  messagingSenderId: 'your-actual-sender-id',
  projectId: 'your-actual-project-id',
  storageBucket: 'your-actual-project-id.appspot.com',
  iosBundleId: 'com.example.nngapp',
);
```

## Step 6: Install Dependencies

Run the following command to install the required packages:

```bash
flutter pub get
```

## Step 7: Test the Authentication

1. Run the app: `flutter run`
2. Try signing up with different email patterns to test role detection:
   - `admin@neuroguard.com` → Admin role
   - `dr.smith@clinic.com` → Clinician role
   - `nurse@care.com` → Caregiver role
   - `patient@example.com` → Patient role

## Email Role Detection Rules

The app automatically detects user roles based on email patterns:

### Admin Emails:
- Contains "admin"
- @neuroguard.com
- @hospital.admin

### Clinician/Doctor Emails:
- Contains "dr."
- Contains "doctor"
- @clinic.*
- @hospital.*
- @medical.*
- @healthcare.*
- @neurology.*
- @epilepsy.*

### Caregiver Emails:
- Contains "caregiver"
- Contains "nurse"
- Contains "family"
- @care.*
- @support.*

### Patient Emails:
- All other email patterns default to patient role

## Security Rules for Firestore

Add these security rules to your Firestore database:

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

## Features Implemented

✅ **Firebase Authentication Integration**
- Email/password sign up and sign in
- Automatic role detection based on email patterns
- Password reset functionality
- Secure user session management

✅ **Professional Email Recognition**
- Smart role detection for different user types
- Support for medical domain patterns
- Admin, clinician, caregiver, and patient roles

✅ **Firestore Integration**
- User data storage and retrieval
- Real-time user state management
- Secure data access patterns

✅ **Enhanced UI/UX**
- Professional sign-up form with role information
- Password reset dialog
- Better error handling and user feedback
- Loading states and validation

## Troubleshooting

### Common Issues:

1. **Firebase not initialized**: Make sure you've added the configuration files and updated `firebase_options.dart`

2. **Authentication errors**: Check that Email/Password authentication is enabled in Firebase Console

3. **Build errors**: Ensure all dependencies are installed with `flutter pub get`

4. **Permission denied**: Check Firestore security rules and ensure they allow authenticated users

### Getting Help:

- Check Firebase documentation: https://firebase.google.com/docs
- Flutter Firebase documentation: https://firebase.flutter.dev/
- Firebase Console: https://console.firebase.google.com/

## Next Steps

1. Set up Firebase project and configure authentication
2. Update the `firebase_options.dart` with your actual configuration
3. Test the authentication flow
4. Customize the role detection patterns if needed
5. Set up additional Firebase services (Cloud Messaging, Analytics, etc.)

Your NeuroGuard app now has professional Firebase Authentication with smart email recognition! 🚀
