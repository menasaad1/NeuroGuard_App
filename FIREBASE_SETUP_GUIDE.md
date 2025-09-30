# دليل إعداد Firebase للمشروع

## الخطوات المطلوبة لإعداد Firebase

### 1. إنشاء مشروع Firebase

1. اذهب إلى [Firebase Console](https://console.firebase.google.com/)
2. انقر على "إضافة مشروع" أو "Add Project"
3. أدخل اسم المشروع: `neuroguard-app`
4. اختر "تمكين Google Analytics" إذا كنت تريد ذلك
5. انقر على "إنشاء المشروع"

### 2. إضافة تطبيق Flutter

1. في لوحة التحكم، انقر على أيقونة Flutter
2. أدخل اسم التطبيق: `NeuroGuard App`
3. أدخل معرف الحزمة: `com.example.nngapp`
4. انقر على "تسجيل التطبيق"

### 3. تنزيل ملفات التكوين

#### للأندرويد:
1. انقر على "تنزيل google-services.json"
2. ضع الملف في `android/app/google-services.json`

#### للـ iOS:
1. انقر على "تنزيل GoogleService-Info.plist"
2. ضع الملف في `ios/Runner/GoogleService-Info.plist`

### 4. تفعيل Authentication

1. في لوحة التحكم، اذهب إلى "Authentication"
2. انقر على "بدء" أو "Get Started"
3. اذهب إلى تبويب "Sign-in method"
4. فعّل "البريد الإلكتروني/كلمة المرور" (Email/Password)

### 5. إعداد Firestore Database

1. اذهب إلى "Firestore Database"
2. انقر على "إنشاء قاعدة بيانات"
3. اختر "بدء في وضع الاختبار" للبداية
4. اختر موقع قاعدة البيانات (الأقرب لك)

### 6. تحديث ملف firebase_options.dart

استبدل القيم في `lib/firebase_options.dart` بالقيم الحقيقية من مشروعك:

```dart
// مثال على القيم المطلوبة
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'your-api-key-here',
  appId: 'your-app-id-here',
  messagingSenderId: 'your-sender-id-here',
  projectId: 'your-project-id-here',
  authDomain: 'your-project-id.firebaseapp.com',
  storageBucket: 'your-project-id.appspot.com',
);
```

### 7. إعداد قواعد Firestore

في لوحة التحكم، اذهب إلى "Firestore Database" > "Rules" واستبدل القواعد بـ:

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
    
    // Patients data (only accessible by patient, their caregivers, and clinicians)
    match /patients/{patientId} {
      allow read, write: if request.auth != null && (
        request.auth.uid == patientId ||
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'clinician', 'caregiver']
      );
    }
  }
}
```

### 8. تثبيت التبعيات

قم بتشغيل الأمر التالي في terminal:

```bash
flutter pub get
```

### 9. اختبار التطبيق

1. شغل التطبيق: `flutter run`
2. جرب إنشاء حساب جديد
3. جرب تسجيل الدخول
4. تأكد من أن البيانات تُحفظ في Firestore

## ملاحظات مهمة

- تأكد من تحديث ملفات التكوين لكل من Android و iOS
- لا تشارك مفاتيح API في الكود العام
- استخدم متغيرات البيئة للقيم الحساسة في الإنتاج
- فعّل قواعد الأمان المناسبة في Firestore

## استكشاف الأخطاء

### خطأ "Firebase not initialized"
- تأكد من استدعاء `Firebase.initializeApp()` في `main()`
- تأكد من صحة ملف `firebase_options.dart`

### خطأ "Permission denied"
- تحقق من قواعد Firestore
- تأكد من أن المستخدم مسجل الدخول

### خطأ "User not found"
- تأكد من تفعيل Email/Password authentication
- تحقق من صحة بيانات تسجيل الدخول
