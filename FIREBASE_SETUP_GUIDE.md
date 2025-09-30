# Firebase Setup Guide for NeuroGuard App

## خطوات إعداد Firebase للمشروع

### 1. إنشاء مشروع Firebase جديد

1. اذهب إلى [Firebase Console](https://console.firebase.google.com/)
2. انقر على "Add project" أو "إضافة مشروع"
3. أدخل اسم المشروع: `neuroguard-app`
4. اختر "Enable Google Analytics" إذا كنت تريد
5. انقر على "Create project"

### 2. إضافة تطبيق Flutter للمشروع

1. في Firebase Console، انقر على "Add app" واختر "Flutter"
2. أدخل اسم التطبيق: `NeuroGuard App`
3. انقر على "Register app"

### 3. تثبيت Firebase CLI

```bash
npm install -g firebase-tools
```

### 4. تسجيل الدخول إلى Firebase

```bash
firebase login
```

### 5. تثبيت FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

### 6. تكوين Firebase في المشروع

```bash
# تأكد من أنك في مجلد المشروع
cd "E:\graduation project\NeuroGuard_App"

# تشغيل FlutterFire CLI
flutterfire configure
```

### 7. تحديث ملف firebase_options.dart

سيقوم FlutterFire CLI بإنشاء ملف `firebase_options.dart` جديد. استبدل الملف الحالي بالملف الجديد.

### 8. إعداد Authentication

1. في Firebase Console، اذهب إلى "Authentication"
2. انقر على "Get started"
3. اذهب إلى "Sign-in method" tab
4. فعّل "Email/Password" provider
5. انقر على "Save"

### 9. إعداد Firestore Database

1. في Firebase Console، اذهب إلى "Firestore Database"
2. انقر على "Create database"
3. اختر "Start in test mode" للبداية
4. اختر موقع قاعدة البيانات (يفضل الأقرب لمنطقتك)
5. انقر على "Done"

### 10. إعداد قواعد الأمان (Security Rules)

في Firestore Database، اذهب إلى "Rules" tab وأضف القواعد التالية:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      allow read: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // User relationships collection
    match /user_relationships/{relationshipId} {
      allow read, write: if request.auth != null && 
        (resource.data.caregiverId == request.auth.uid || 
         resource.data.clinicianId == request.auth.uid ||
         resource.data.patientId == request.auth.uid ||
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin');
    }
    
    // Vitals collection (for patients)
    match /vitals/{vitalId} {
      allow read, write: if request.auth != null && 
        (resource.data.patientId == request.auth.uid ||
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'clinician', 'caregiver']);
    }
    
    // Events collection
    match /events/{eventId} {
      allow read, write: if request.auth != null && 
        (resource.data.patientId == request.auth.uid ||
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'clinician', 'caregiver']);
    }
  }
}
```

### 11. اختبار التطبيق

1. شغل التطبيق:
```bash
flutter run
```

2. جرب إنشاء حساب جديد
3. جرب تسجيل الدخول
4. تأكد من أن البيانات تُحفظ في Firestore

### 12. إعدادات إضافية للـ Production

#### أ. تحديث قواعد الأمان
قبل النشر، تأكد من تحديث قواعد الأمان لتكون أكثر تقييداً.

#### ب. إعداد Firebase Hosting (اختياري)
```bash
firebase init hosting
```

#### ج. إعداد Cloud Functions (اختياري)
```bash
firebase init functions
```

## ملاحظات مهمة

1. **تأكد من تحديث ملف `firebase_options.dart`** بالبيانات الصحيحة من Firebase Console
2. **لا تشارك ملف `firebase_options.dart`** في Git إذا كان يحتوي على بيانات حساسة
3. **استخدم متغيرات البيئة** للبيانات الحساسة في الإنتاج
4. **اختبر جميع الوظائف** قبل النشر

## استكشاف الأخطاء

### خطأ: "Firebase not initialized"
- تأكد من استدعاء `Firebase.initializeApp()` في `main()`
- تأكد من صحة ملف `firebase_options.dart`

### خطأ: "Permission denied"
- تحقق من قواعد الأمان في Firestore
- تأكد من تسجيل دخول المستخدم

### خطأ: "User not found"
- تأكد من تفعيل Email/Password في Authentication
- تحقق من صحة بيانات المستخدم

## الدعم

إذا واجهت أي مشاكل، راجع:
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)
