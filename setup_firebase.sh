#!/bin/bash

# Firebase Setup Script for NeuroGuard App
# This script helps set up Firebase Authentication

echo "🔥 Firebase Setup Script for NeuroGuard App"
echo "============================================="

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    exit 1
fi

echo "✅ Flutter is installed"

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "📦 Installing Firebase CLI..."
    npm install -g firebase-tools
    if [ $? -eq 0 ]; then
        echo "✅ Firebase CLI installed successfully"
    else
        echo "❌ Failed to install Firebase CLI. Please install manually."
        exit 1
    fi
else
    echo "✅ Firebase CLI is already installed"
fi

# Check if FlutterFire CLI is installed
if ! command -v flutterfire &> /dev/null; then
    echo "📦 Installing FlutterFire CLI..."
    dart pub global activate flutterfire_cli
    if [ $? -eq 0 ]; then
        echo "✅ FlutterFire CLI installed successfully"
    else
        echo "❌ Failed to install FlutterFire CLI. Please install manually."
        exit 1
    fi
else
    echo "✅ FlutterFire CLI is already installed"
fi

echo ""
echo "🚀 Next Steps:"
echo "=============="
echo "1. Login to Firebase:"
echo "   firebase login"
echo ""
echo "2. Configure Firebase for your Flutter app:"
echo "   flutterfire configure"
echo ""
echo "3. Or manually set up Firebase project:"
echo "   - Go to https://console.firebase.google.com/"
echo "   - Create a new project"
echo "   - Enable Authentication (Email/Password)"
echo "   - Enable Firestore Database"
echo "   - Add Android app with package: com.example.nngapp"
echo "   - Add iOS app with bundle ID: com.example.nngapp"
echo "   - Download configuration files"
echo ""
echo "4. Clean and rebuild:"
echo "   flutter clean"
echo "   flutter pub get"
echo ""
echo "5. Test the app:"
echo "   flutter run"
echo ""
echo "📚 For detailed instructions, see:"
echo "   - FIREBASE_SETUP.md"
echo "   - TROUBLESHOOTING.md"
echo ""
echo "🎉 Happy coding with Firebase!"
