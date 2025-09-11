// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'اسکرول لرن AI';

  @override
  String get settings => 'سیٹنگز';

  @override
  String get account => 'اکاؤنٹ';

  @override
  String get profile => 'پروفائل';

  @override
  String get manageProfile => 'اپنا پروفائل منظم کریں';

  @override
  String get email => 'ای میل';

  @override
  String get changeEmail => 'اپنا ای میل تبدیل کریں';

  @override
  String get password => 'پاس ورڈ';

  @override
  String get changePassword => 'اپنا پاس ورڈ تبدیل کریں';

  @override
  String get preferences => 'ترجیحات';

  @override
  String get language => 'زبان';

  @override
  String get chooseLanguage => 'اپنی پسندیدہ زبان منتخب کریں';

  @override
  String get darkMode => 'ڈارک موڈ';

  @override
  String get darkModeDescription =>
      'آرام دہ دیکھنے کے تجربے کے لیے\nڈارک موڈ فعال کریں';

  @override
  String get apiConfiguration => 'API کنفیگریشن';

  @override
  String get aiProviderKeys => 'AI فراہم کنندہ کیز';

  @override
  String get apiKeysDescription =>
      'AI سے چلنے والی سیکھنے کی خصوصیات کو فعال کرنے کے لیے اپنی API کیز کو کنفیگر کریں';

  @override
  String get openaiApiKey => 'OpenAI API کی';

  @override
  String get geminiApiKey => 'Google Gemini API کی';

  @override
  String get anthropicApiKey => 'Anthropic Claude API کی';

  @override
  String get openrouterApiKey => 'OpenRouter API کی';

  @override
  String get saveApiKeys => 'API کیز محفوظ کریں';

  @override
  String get notifications => 'اطلاعات';

  @override
  String get appNotifications => 'ایپ اطلاعات';

  @override
  String get appNotificationsDescription =>
      'نئے مواد اور اپ ڈیٹس کے لیے\nاطلاعات حاصل کریں';

  @override
  String get emailNotifications => 'ای میل اطلاعات';

  @override
  String get emailNotificationsDescription =>
      'اہم اپ ڈیٹس کے لیے\nای میل اطلاعات حاصل کریں';

  @override
  String get support => 'سپورٹ';

  @override
  String get helpCenter => 'ہیلپ سینٹر';

  @override
  String get getHelp => 'مدد اور سپورٹ حاصل کریں';

  @override
  String get contactUs => 'ہم سے رابطہ کریں';

  @override
  String get contactSupport => 'مدد کے لیے ہم سے رابطہ کریں';

  @override
  String get home => 'ہوم';

  @override
  String get progress => 'پیش قدمی';

  @override
  String get selectLanguage => 'زبان منتخب کریں';

  @override
  String currentLanguage(Object languageName) {
    return 'موجودہ: $languageName';
  }

  @override
  String languageChanged(Object languageName) {
    return 'زبان $languageName میں تبدیل کر دی گئی';
  }

  @override
  String comingSoon(Object feature) {
    return '$feature جلد آ رہا ہے!';
  }

  @override
  String get apiKeysSaved => 'API کیز کامیابی سے محفوظ ہو گئیں';

  @override
  String apiKeysLoadFailed(Object error) {
    return 'API کیز لوڈ کرنے میں ناکام: $error';
  }

  @override
  String apiKeysSaveFailed(Object error) {
    return 'API کیز محفوظ کرنے میں ناکام: $error';
  }

  @override
  String get progressTracking => 'پیش قدمی کی ٹریکنگ جلد آ رہی ہے!';

  @override
  String get swipeToSwitch => 'مضامین تبدیل کرنے کے لیے سوائپ کریں';

  @override
  String get swipeInstructions =>
      'مختلف مضامین کی تلاش کے لیے\nبائیں یا دائیں سوائپ کریں';

  @override
  String get skip => 'چھوڑیں';

  @override
  String get math => 'ریاضی';

  @override
  String get science => 'سائنس';

  @override
  String get history => 'تاریخ';

  @override
  String get geography => 'جغرافیہ';

  @override
  String get solveForX => 'x کے لیے حل کریں: 2x + 5 = 15';

  @override
  String get chemicalFormula => 'پانی کا کیمیائی فارمولا کیا ہے؟';

  @override
  String get worldWarEnd => 'دوسری جنگ عظیم کس سال ختم ہوئی؟';

  @override
  String get australiaCapital => 'آسٹریلیا کا دارالحکومت کیا ہے؟';

  @override
  String get enterAnswer => 'اپنا جواب نیچے درج کریں:';

  @override
  String get answer => 'جواب';

  @override
  String get showSolution => 'حل دکھائیں';

  @override
  String get solution => 'حل:';

  @override
  String switchedTo(Object subject) {
    return '$subject میں تبدیل کر دیا گیا';
  }
}
