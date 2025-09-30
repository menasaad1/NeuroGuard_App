import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  final ValueNotifier<Locale> currentLocale = ValueNotifier(const Locale('ar', 'EG'));
  
  // Available languages
  static const List<Locale> supportedLocales = [
    Locale('ar', 'EG'), // Arabic
    Locale('en', 'US'), // English
  ];

  // Initialize language service
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'ar';
    final countryCode = prefs.getString('country_code') ?? 'EG';
    currentLocale.value = Locale(languageCode, countryCode);
  }

  // Change language
  Future<void> changeLanguage(Locale locale) async {
    currentLocale.value = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    await prefs.setString('country_code', locale.countryCode ?? '');
  }

  // Get current language name
  String getCurrentLanguageName() {
    switch (currentLocale.value.languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      default:
        return 'العربية';
    }
  }

  // Get language name for display
  String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      default:
        return 'العربية';
    }
  }

  // Check if current language is Arabic
  bool get isArabic => currentLocale.value.languageCode == 'ar';

  // Check if current language is English
  bool get isEnglish => currentLocale.value.languageCode == 'en';
}
