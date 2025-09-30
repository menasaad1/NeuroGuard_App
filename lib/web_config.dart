import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WebConfig {
  static void configureWebRenderer() {
    if (kIsWeb) {
      // Configure web-specific settings
      debugPrint('Configuring web renderer for NeuroGuard App');
      
      // Set text direction for Arabic support
      WidgetsBinding.instance.platformDispatcher.locale = const Locale('ar', 'EG');
    }
  }
}
