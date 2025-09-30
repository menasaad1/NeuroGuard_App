import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../services/language_service.dart';
import 'language_settings_screen.dart';
import 'auth_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LanguageService().isArabic ? 'الإعدادات' : 'Settings',
          style: const TextStyle(fontFamily: 'Arial'),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Language settings
            _buildSettingsCard(
              context,
              icon: Icons.language,
              title: LanguageService().isArabic ? 'اللغة' : 'Language',
              subtitle: LanguageService().getCurrentLanguageName(),
              color: Colors.blue,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LanguageSettingsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            
            // Sign out
            _buildSettingsCard(
              context,
              icon: Icons.logout,
              title: LanguageService().isArabic ? 'تسجيل الخروج' : 'Sign Out',
              subtitle: LanguageService().isArabic 
                ? 'تسجيل الخروج من التطبيق' 
                : 'Sign out of the application',
              color: Colors.red,
              onTap: () async {
                // Show confirmation dialog
                final shouldSignOut = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      LanguageService().isArabic ? 'تأكيد تسجيل الخروج' : 'Confirm Sign Out',
                      style: const TextStyle(fontFamily: 'Arial'),
                    ),
                    content: Text(
                      LanguageService().isArabic 
                        ? 'هل أنت متأكد من أنك تريد تسجيل الخروج؟'
                        : 'Are you sure you want to sign out?',
                      style: const TextStyle(fontFamily: 'Arial'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(
                          LanguageService().isArabic ? 'إلغاء' : 'Cancel',
                          style: const TextStyle(fontFamily: 'Arial'),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(
                          LanguageService().isArabic ? 'تسجيل الخروج' : 'Sign Out',
                          style: const TextStyle(
                            color: Colors.red,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                
                if (shouldSignOut == true) {
                  await AppState.instance.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => AuthScreen(
                          onToggleTheme: () {}, // Will be handled by main app
                        ),
                      ),
                      (route) => false,
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            
            // App info
            _buildSettingsCard(
              context,
              icon: Icons.info,
              title: LanguageService().isArabic ? 'معلومات التطبيق' : 'App Info',
              subtitle: 'NeuroGuard v1.0.0',
              color: Colors.green,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      LanguageService().isArabic ? 'معلومات التطبيق' : 'App Information',
                      style: const TextStyle(fontFamily: 'Arial'),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NeuroGuard',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: 'Arial',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          LanguageService().isArabic 
                            ? 'نظام مراقبة الصحة العصبية الذكي'
                            : 'Smart Neurological Health Monitoring System',
                          style: const TextStyle(fontFamily: 'Arial'),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Version: 1.0.0',
                          style: const TextStyle(fontFamily: 'Arial'),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          LanguageService().isArabic 
                            ? 'تم تطويره باستخدام Flutter و Firebase'
                            : 'Built with Flutter and Firebase',
                          style: const TextStyle(fontFamily: 'Arial'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          LanguageService().isArabic ? 'إغلاق' : 'Close',
                          style: const TextStyle(fontFamily: 'Arial'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: color,
          size: 24,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial',
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.grey,
            fontFamily: 'Arial',
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}
