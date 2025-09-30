import 'package:flutter/material.dart';
import '../services/language_service.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LanguageService().isArabic ? 'إعدادات اللغة' : 'Language Settings',
          style: const TextStyle(fontFamily: 'Arial'),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current language
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.language,
                    color: Colors.blue[600],
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LanguageService().isArabic ? 'اللغة الحالية' : 'Current Language',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                            fontFamily: 'Arial',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          LanguageService().getCurrentLanguageName(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue[600],
                            fontFamily: 'Arial',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Language options
            Text(
              LanguageService().isArabic ? 'اختر اللغة' : 'Choose Language',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Arial',
              ),
            ),
            const SizedBox(height: 16),
            
            // Arabic option
            _buildLanguageOption(
              context,
              const Locale('ar', 'EG'),
              'العربية',
              'Arabic',
              Icons.flag,
              Colors.green,
            ),
            const SizedBox(height: 12),
            
            // English option
            _buildLanguageOption(
              context,
              const Locale('en', 'US'),
              'English',
              'English',
              Icons.flag,
              Colors.blue,
            ),
            const SizedBox(height: 24),
            
            // Info card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.orange[600],
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      LanguageService().isArabic 
                        ? 'سيتم تطبيق التغيير فوراً في جميع أنحاء التطبيق'
                        : 'The change will be applied immediately throughout the app',
                      style: TextStyle(
                        color: Colors.orange[800],
                        fontFamily: 'Arial',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    Locale locale,
    String arabicName,
    String englishName,
    IconData icon,
    Color color,
  ) {
    final isSelected = LanguageService().currentLocale.value == locale;
    
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? color.withOpacity(0.1) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? color : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? color : Colors.grey[600],
          size: 24,
        ),
        title: Text(
          LanguageService().isArabic ? arabicName : englishName,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? color : Colors.black87,
            fontFamily: 'Arial',
          ),
        ),
        subtitle: Text(
          LanguageService().isArabic ? englishName : arabicName,
          style: TextStyle(
            color: Colors.grey[600],
            fontFamily: 'Arial',
          ),
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: color,
                size: 24,
              )
            : null,
        onTap: () async {
          await LanguageService().changeLanguage(locale);
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
