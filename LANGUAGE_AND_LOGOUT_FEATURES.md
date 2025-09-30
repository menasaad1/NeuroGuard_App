# ميزات اللغة وتسجيل الخروج - NeuroGuard App

## ✅ تم إضافة الميزات الجديدة بنجاح

### 🌐 **ميزة تغيير اللغة**

#### 1. **خدمة إدارة اللغة**
- حفظ تفضيل اللغة في SharedPreferences
- دعم العربية والإنجليزية
- تغيير فوري للغة في جميع أنحاء التطبيق

#### 2. **شاشة إعدادات اللغة**
- واجهة سهلة لتغيير اللغة
- عرض اللغة الحالية
- خيارات واضحة للعربية والإنجليزية

#### 3. **زر تغيير اللغة**
- زر في شريط التنقل العلوي
- أيقونة لغة واضحة
- انتقال سريع لإعدادات اللغة

### 🚪 **إصلاح مشكلة تسجيل الخروج**

#### 1. **تحسين عملية تسجيل الخروج**
- مسح حالة Firebase بشكل صحيح
- إعادة تعيين البيانات المحلية
- إلغاء المؤقتات الجارية
- مسح الأحداث

#### 2. **شاشة الإعدادات**
- زر تسجيل الخروج مع تأكيد
- معلومات التطبيق
- واجهة سهلة الاستخدام

## 📁 **الملفات المضافة/المحدثة:**

### 1. `lib/services/language_service.dart` (جديد)
```dart
class LanguageService {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  
  final ValueNotifier<Locale> currentLocale = ValueNotifier(const Locale('ar', 'EG'));
  
  // تغيير اللغة
  Future<void> changeLanguage(Locale locale) async {
    currentLocale.value = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    await prefs.setString('country_code', locale.countryCode ?? '');
  }
}
```

### 2. `lib/screens/language_settings_screen.dart` (جديد)
```dart
class LanguageSettingsScreen extends StatelessWidget {
  // واجهة تغيير اللغة
  // خيارات واضحة للعربية والإنجليزية
  // عرض اللغة الحالية
}
```

### 3. `lib/screens/settings_screen.dart` (جديد)
```dart
class SettingsScreen extends StatelessWidget {
  // شاشة الإعدادات الرئيسية
  // زر تسجيل الخروج مع تأكيد
  // معلومات التطبيق
}
```

### 4. `lib/state/app_state.dart` (محدث)
```dart
Future<void> signOut() async {
  try {
    // Clear Firebase auth state
    await _authService.signOut();
    
    // Clear local state
    currentUser.value = null;
    
    // Reset vitals to default
    vitals.value = { /* default values */ };
    
    // Clear events
    events.value = [];
    
    // Cancel any ongoing timers
    _telemetryTimer?.cancel();
    
    print('User signed out successfully');
  } catch (e) {
    print('Sign out error: $e');
    // Force clear local state even if Firebase signOut fails
    currentUser.value = null;
  }
}
```

### 5. `lib/main.dart` (محدث)
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure web renderer
  WebConfig.configureWebRenderer();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize language service
  await LanguageService().initialize();
  
  AppState.instance.initialize();
  runApp(const NeuroGuardApp());
}
```

### 6. `pubspec.yaml` (محدث)
```yaml
dependencies:
  # Local storage
  shared_preferences: ^2.2.2
```

## 🚀 **كيفية الاستخدام:**

### 1. **تغيير اللغة**
1. اضغط على أيقونة اللغة في شريط التنقل العلوي
2. اختر اللغة المفضلة (العربية أو الإنجليزية)
3. سيتم تطبيق التغيير فوراً

### 2. **تسجيل الخروج**
1. اذهب إلى شاشة الإعدادات
2. اضغط على "تسجيل الخروج"
3. أكد العملية
4. سيتم تسجيل الخروج وإعادة توجيهك لشاشة تسجيل الدخول

### 3. **الوصول للإعدادات**
- من أي شاشة في التطبيق
- زر الإعدادات في شريط التنقل
- خيارات متعددة للإعدادات

## ✅ **النتائج المتوقعة:**

### ✅ ميزات اللغة
- 🌐 دعم كامل للعربية والإنجليزية
- 🔄 تغيير فوري للغة
- 💾 حفظ تفضيل اللغة
- 🎯 واجهة سهلة الاستخدام

### ✅ إصلاح تسجيل الخروج
- 🚪 تسجيل خروج صحيح
- 🔄 إعادة تعيين البيانات
- 🧹 مسح الحالة المحلية
- 🔄 إمكانية تسجيل الدخول مرة أخرى

### ✅ تجربة مستخدم محسنة
- 🎨 واجهة احترافية
- 🔔 رسائل واضحة
- 📱 تصميم متجاوب
- ⚡ أداء سريع

## 🔍 **اختبار الميزات:**

### 1. اختبار تغيير اللغة
- [ ] تغيير اللغة يعمل بشكل صحيح
- [ ] النصوص تظهر باللغة المختارة
- [ ] التفضيل محفوظ بعد إعادة التشغيل
- [ ] الواجهة متجاوبة

### 2. اختبار تسجيل الخروج
- [ ] تسجيل الخروج يعمل بشكل صحيح
- [ ] البيانات تُمسح بشكل صحيح
- [ ] إمكانية تسجيل الدخول مرة أخرى
- [ ] لا توجد مشاكل في الحالة

### 3. اختبار الإعدادات
- [ ] شاشة الإعدادات تعمل
- [ ] خيارات اللغة متاحة
- [ ] تسجيل الخروج مع تأكيد
- [ ] معلومات التطبيق صحيحة

## 📞 **الدعم:**

إذا واجهت أي مشاكل:

1. **تحقق من التبعيات:**
```bash
flutter pub get
```

2. **تنظيف المشروع:**
```bash
flutter clean
flutter pub get
```

3. **إعادة تشغيل التطبيق:**
```bash
flutter run -d chrome --web-renderer canvaskit
```

---

## 🎉 النتيجة النهائية

**التطبيق الآن يحتوي على:**
- ✅ ميزة تغيير اللغة (العربية/الإنجليزية)
- ✅ إصلاح مشكلة تسجيل الخروج
- ✅ شاشة إعدادات شاملة
- ✅ حفظ تفضيلات المستخدم
- ✅ واجهة سهلة الاستخدام
- ✅ تجربة مستخدم محسنة

**جاهز للاستخدام! 🚀**
