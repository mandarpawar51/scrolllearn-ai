// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appTitle => 'स्क्रोललर्न AI';

  @override
  String get settings => 'सेटिंग्ज';

  @override
  String get account => 'खाते';

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get manageProfile => 'तुमची प्रोफाइल व्यवस्थापित करा';

  @override
  String get email => 'ईमेल';

  @override
  String get changeEmail => 'तुमचा ईमेल बदला';

  @override
  String get password => 'पासवर्ड';

  @override
  String get changePassword => 'तुमचा पासवर्ड बदला';

  @override
  String get preferences => 'प्राधान्ये';

  @override
  String get language => 'भाषा';

  @override
  String get chooseLanguage => 'तुमची आवडती भाषा निवडा';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get darkModeDescription =>
      'आरामदायक दृश्य अनुभवासाठी\nडार्क मोड सक्षम करा';

  @override
  String get apiConfiguration => 'API कॉन्फिगरेशन';

  @override
  String get aiProviderKeys => 'AI प्रदाता की';

  @override
  String get apiKeysDescription =>
      'AI-चालित शिक्षण वैशिष्ट्ये सक्षम करण्यासाठी तुमच्या API की कॉन्फिगर करा';

  @override
  String get openaiApiKey => 'OpenAI API की';

  @override
  String get geminiApiKey => 'Google Gemini API की';

  @override
  String get anthropicApiKey => 'Anthropic Claude API की';

  @override
  String get openrouterApiKey => 'OpenRouter API की';

  @override
  String get saveApiKeys => 'API की जतन करा';

  @override
  String get notifications => 'सूचना';

  @override
  String get appNotifications => 'अॅप सूचना';

  @override
  String get appNotificationsDescription =>
      'नवीन सामग्री आणि अपडेट्ससाठी\nसूचना प्राप्त करा';

  @override
  String get emailNotifications => 'ईमेल सूचना';

  @override
  String get emailNotificationsDescription =>
      'महत्वाच्या अपडेट्ससाठी\nईमेल सूचना मिळवा';

  @override
  String get support => 'समर्थन';

  @override
  String get helpCenter => 'मदत केंद्र';

  @override
  String get getHelp => 'मदत आणि समर्थन मिळवा';

  @override
  String get contactUs => 'आमच्याशी संपर्क साधा';

  @override
  String get contactSupport => 'सहाय्यासाठी आमच्याशी संपर्क साधा';

  @override
  String get home => 'मुख्यपृष्ठ';

  @override
  String get progress => 'प्रगती';

  @override
  String get selectLanguage => 'भाषा निवडा';

  @override
  String currentLanguage(Object languageName) {
    return 'सध्याची: $languageName';
  }

  @override
  String languageChanged(Object languageName) {
    return 'भाषा $languageName मध्ये बदलली';
  }

  @override
  String comingSoon(Object feature) {
    return '$feature लवकरच येत आहे!';
  }

  @override
  String get apiKeysSaved => 'API की यशस्वीरित्या जतन केल्या';

  @override
  String apiKeysLoadFailed(Object error) {
    return 'API की लोड करण्यात अयशस्वी: $error';
  }

  @override
  String apiKeysSaveFailed(Object error) {
    return 'API की जतन करण्यात अयशस्वी: $error';
  }

  @override
  String get progressTracking => 'प्रगती ट्रॅकिंग लवकरच येत आहे!';

  @override
  String get swipeToSwitch => 'विषय बदलण्यासाठी स्वाइप करा';

  @override
  String get swipeInstructions =>
      'वेगवेगळे विषय एक्सप्लोर करण्यासाठी\nडावीकडे किंवा उजवीकडे स्वाइप करा';

  @override
  String get skip => 'वगळा';

  @override
  String get math => 'गणित';

  @override
  String get science => 'विज्ञान';

  @override
  String get history => 'इतिहास';

  @override
  String get geography => 'भूगोल';

  @override
  String get solveForX => 'x साठी सोडवा: 2x + 5 = 15';

  @override
  String get chemicalFormula => 'पाण्याचे रासायनिक सूत्र काय आहे?';

  @override
  String get worldWarEnd => 'दुसरे महायुद्ध कोणत्या वर्षी संपले?';

  @override
  String get australiaCapital => 'ऑस्ट्रेलियाची राजधानी काय आहे?';

  @override
  String get enterAnswer => 'तुमचे उत्तर खाली प्रविष्ट करा:';

  @override
  String get answer => 'उत्तर';

  @override
  String get showSolution => 'समाधान दाखवा';

  @override
  String get solution => 'समाधान:';

  @override
  String switchedTo(Object subject) {
    return '$subject मध्ये बदलले';
  }
}
