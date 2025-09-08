import 'package:flutter/foundation.dart';
import '../providers/language_provider.dart';

/// Debug helper class for testing language functionality
class LanguageDebugHelper {
  static void logAllSupportedLanguages() {
    if (kDebugMode) {
      print('🌐 Supported Languages:');
      for (final language in LanguageProvider.supportedLanguages) {
        final code = language['code']!;
        final name = language['name']!;
        final nativeName = language['nativeName']!;
        final locale = LanguageProvider.getLocaleFromCode(code);
        
        print('  $code: $name ($nativeName) -> ${locale.languageCode}_${locale.countryCode}');
      }
    }
  }

  static void testLanguageSwitch(LanguageProvider provider, String languageCode) async {
    if (kDebugMode) {
      print('🔄 Testing language switch to: $languageCode');
      
      try {
        final oldLocale = provider.currentLocale;
        await provider.changeLanguage(languageCode);
        final newLocale = provider.currentLocale;
        
        print('  ✅ Success: ${oldLocale.languageCode} -> ${newLocale.languageCode}');
      } catch (e) {
        print('  ❌ Failed: $e');
      }
    }
  }

  static void testAllLanguages(LanguageProvider provider) async {
    if (kDebugMode) {
      print('🧪 Testing all supported languages...');
      
      for (final language in LanguageProvider.supportedLanguages) {
        await testLanguageSwitch(provider, language['code']!);
        
        // Small delay to avoid overwhelming the system
        await Future.delayed(const Duration(milliseconds: 100));
      }
      
      print('✅ All language tests completed');
    }
  }

  static bool isRTLLanguage(String languageCode) {
    const rtlLanguages = ['ur', 'ar', 'fa', 'he'];
    return rtlLanguages.contains(languageCode);
  }

  static void logRTLLanguages() {
    if (kDebugMode) {
      print('📱 RTL Languages in app:');
      for (final language in LanguageProvider.supportedLanguages) {
        final code = language['code']!;
        if (isRTLLanguage(code)) {
          print('  $code: ${language['name']} (${language['nativeName']})');
        }
      }
    }
  }
}