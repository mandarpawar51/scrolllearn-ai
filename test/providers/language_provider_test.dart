import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrolllearn_ai/providers/language_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LanguageProvider Tests', () {
    setUp(() {
      // Clear shared preferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    test('should initialize with English as default language', () {
      final provider = LanguageProvider();
      expect(provider.currentLocale, equals(const Locale('en', 'US')));
    });

    test('should change language successfully for all supported languages', () async {
      final provider = LanguageProvider();
      
      // Test each supported language
      for (final language in LanguageProvider.supportedLanguages) {
        final languageCode = language['code']!;
        final languageName = language['name']!;
        
        try {
          await provider.changeLanguage(languageCode);
          
          // Verify the locale changed
          final expectedLocale = LanguageProvider.getLocaleFromCode(languageCode);
          expect(provider.currentLocale, equals(expectedLocale));
          
          print('✓ $languageName ($languageCode) - Language change successful');
        } catch (e) {
          fail('✗ $languageName ($languageCode) - Failed to change language: $e');
        }
      }
    });

    test('should return correct locale for each language code', () {
      final testCases = {
        'en': const Locale('en', 'US'),
        'hi': const Locale('hi', 'IN'),
        'bn': const Locale('bn', 'IN'),
        'te': const Locale('te', 'IN'),
        'ta': const Locale('ta', 'IN'),
        'mr': const Locale('mr', 'IN'),
        'gu': const Locale('gu', 'IN'),
        'kn': const Locale('kn', 'IN'),
        'ml': const Locale('ml', 'IN'),
        'or': const Locale('or', 'IN'),
        'pa': const Locale('pa', 'IN'),
        'as': const Locale('as', 'IN'),
        'ur': const Locale('ur', 'IN'),
      };

      for (final entry in testCases.entries) {
        final result = LanguageProvider.getLocaleFromCode(entry.key);
        expect(result, equals(entry.value), 
               reason: 'Failed for language code: ${entry.key}');
      }
    });

    test('should handle invalid language codes gracefully', () {
      final result = LanguageProvider.getLocaleFromCode('invalid');
      expect(result, equals(const Locale('en', 'US')));
    });

    test('should persist language selection', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      
      final provider = LanguageProvider();
      await provider.changeLanguage('hi');
      
      // Check if it was saved to SharedPreferences
      expect(prefs.getString('selected_language'), equals('hi'));
    });

    test('should load saved language on initialization', () async {
      // Set up mock with saved language
      SharedPreferences.setMockInitialValues({'selected_language': 'ta'});
      
      final provider = LanguageProvider();
      
      // Wait for async initialization
      await Future.delayed(const Duration(milliseconds: 100));
      
      expect(provider.currentLocale, equals(const Locale('ta', 'IN')));
    });

    test('should have all required languages in supportedLanguages list', () {
      final supportedCodes = LanguageProvider.supportedLanguages
          .map((lang) => lang['code'])
          .toSet();
      
      final expectedCodes = {
        'en', 'hi', 'bn', 'te', 'mr', 'ta', 'gu', 'kn', 'ml', 'or', 'pa', 'as', 'ur'
      };
      
      // Check that all expected languages are present
      for (final code in expectedCodes) {
        expect(supportedCodes.contains(code), isTrue, 
               reason: 'Missing language code: $code');
      }
    });

    test('should generate correct supportedLocales list', () {
      final locales = LanguageProvider.supportedLocales;
      
      expect(locales.length, equals(LanguageProvider.supportedLanguages.length));
      
      // Check that each locale is valid
      for (final locale in locales) {
        expect(locale.languageCode.isNotEmpty, isTrue);
        expect(locale.countryCode?.isNotEmpty ?? true, isTrue);
      }
    });

    test('should handle RTL languages correctly', () {
      // Test Urdu (RTL language)
      final urduLocale = LanguageProvider.getLocaleFromCode('ur');
      expect(urduLocale.languageCode, equals('ur'));
      expect(urduLocale.countryCode, equals('IN'));
    });
  });
}