import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  Locale _currentLocale = const Locale('en', 'US');

  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'en';
    _currentLocale = getLocaleFromCode(languageCode);
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    _currentLocale = getLocaleFromCode(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
    notifyListeners();
  }

  static Locale getLocaleFromCode(String code) {
    switch (code) {
      case 'hi':
        return const Locale('hi', 'IN');
      case 'bn':
        return const Locale('bn', 'IN');
      case 'te':
        return const Locale('te', 'IN');
      case 'mr':
        return const Locale('mr', 'IN');
      case 'ta':
        return const Locale('ta', 'IN');
      case 'gu':
        return const Locale('gu', 'IN');
      case 'kn':
        return const Locale('kn', 'IN');
      case 'ml':
        return const Locale('ml', 'IN');
      case 'or':
        return const Locale('or', 'IN');
      case 'pa':
        return const Locale('pa', 'IN');
      case 'as':
        return const Locale('as', 'IN');
      case 'ur':
        return const Locale('ur', 'IN');
      case 'sa':
        return const Locale('sa', 'IN');
      case 'ne':
        return const Locale('ne', 'IN');
      case 'si':
        return const Locale('si', 'LK');
      case 'my':
        return const Locale('my', 'MM');
      case 'dz':
        return const Locale('dz', 'BT');
      case 'bo':
        return const Locale('bo', 'CN');
      case 'ks':
        return const Locale('ks', 'IN');
      case 'sd':
        return const Locale('sd', 'IN');
      case 'mai':
        return const Locale('mai', 'IN');
      case 'bho':
        return const Locale('bho', 'IN');
      default:
        return const Locale('en', 'US');
    }
  }

  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    {'code': 'hi', 'name': 'Hindi', 'nativeName': 'हिन्दी'},
    {'code': 'bn', 'name': 'Bengali', 'nativeName': 'বাংলা'},
    {'code': 'te', 'name': 'Telugu', 'nativeName': 'తెలుగు'},
    {'code': 'mr', 'name': 'Marathi', 'nativeName': 'मराठी'},
    {'code': 'ta', 'name': 'Tamil', 'nativeName': 'தமிழ்'},
    {'code': 'gu', 'name': 'Gujarati', 'nativeName': 'ગુજરાતી'},
    {'code': 'kn', 'name': 'Kannada', 'nativeName': 'ಕನ್ನಡ'},
    {'code': 'ml', 'name': 'Malayalam', 'nativeName': 'മലയാളം'},
    {'code': 'or', 'name': 'Odia', 'nativeName': 'ଓଡ଼ିଆ'},
    {'code': 'pa', 'name': 'Punjabi', 'nativeName': 'ਪੰਜਾਬੀ'},
    {'code': 'as', 'name': 'Assamese', 'nativeName': 'অসমীয়া'},
    {'code': 'ur', 'name': 'Urdu', 'nativeName': 'اردو'},


  ];

  static List<Locale> get supportedLocales {
    return supportedLanguages
        .map((lang) => getLocaleFromCode(lang['code']!))
        .toList();
  }
}