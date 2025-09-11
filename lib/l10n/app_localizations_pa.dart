// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Panjabi Punjabi (`pa`).
class AppLocalizationsPa extends AppLocalizations {
  AppLocalizationsPa([String locale = 'pa']) : super(locale);

  @override
  String get appTitle => 'ਸਕ੍ਰੋਲਲਰਨ AI';

  @override
  String get settings => 'ਸੈਟਿੰਗਾਂ';

  @override
  String get account => 'ਖਾਤਾ';

  @override
  String get profile => 'ਪ੍ਰੋਫਾਈਲ';

  @override
  String get manageProfile => 'ਆਪਣੀ ਪ੍ਰੋਫਾਈਲ ਦਾ ਪ੍ਰਬੰਧਨ ਕਰੋ';

  @override
  String get email => 'ਈਮੇਲ';

  @override
  String get changeEmail => 'ਆਪਣਾ ਈਮੇਲ ਬਦਲੋ';

  @override
  String get password => 'ਪਾਸਵਰਡ';

  @override
  String get changePassword => 'ਆਪਣਾ ਪਾਸਵਰਡ ਬਦਲੋ';

  @override
  String get preferences => 'ਤਰਜੀਹਾਂ';

  @override
  String get language => 'ਭਾਸ਼ਾ';

  @override
  String get chooseLanguage => 'ਆਪਣੀ ਪਸੰਦੀਦਾ ਭਾਸ਼ਾ ਚੁਣੋ';

  @override
  String get darkMode => 'ਡਾਰਕ ਮੋਡ';

  @override
  String get darkModeDescription =>
      'ਆਰਾਮਦਾਇਕ ਦੇਖਣ ਦੇ ਤਜਰਬੇ ਲਈ\nਡਾਰਕ ਮੋਡ ਚਾਲੂ ਕਰੋ';

  @override
  String get apiConfiguration => 'API ਸੰਰਚਨਾ';

  @override
  String get aiProviderKeys => 'AI ਪ੍ਰਦਾਤਾ ਕੀਆਂ';

  @override
  String get apiKeysDescription =>
      'AI-ਸੰਚਾਲਿਤ ਸਿੱਖਣ ਦੀਆਂ ਵਿਸ਼ੇਸ਼ਤਾਵਾਂ ਨੂੰ ਸਮਰੱਥ ਬਣਾਉਣ ਲਈ ਆਪਣੀਆਂ API ਕੀਆਂ ਨੂੰ ਸੰਰਚਿਤ ਕਰੋ';

  @override
  String get openaiApiKey => 'OpenAI API ਕੀ';

  @override
  String get geminiApiKey => 'Google Gemini API ਕੀ';

  @override
  String get anthropicApiKey => 'Anthropic Claude API ਕੀ';

  @override
  String get openrouterApiKey => 'OpenRouter API ਕੀ';

  @override
  String get saveApiKeys => 'API ਕੀਆਂ ਸੇਵ ਕਰੋ';

  @override
  String get notifications => 'ਸੂਚਨਾਵਾਂ';

  @override
  String get appNotifications => 'ਐਪ ਸੂਚਨਾਵਾਂ';

  @override
  String get appNotificationsDescription =>
      'ਨਵੀਂ ਸਮੱਗਰੀ ਅਤੇ ਅਪਡੇਟਾਂ ਲਈ\nਸੂਚਨਾਵਾਂ ਪ੍ਰਾਪਤ ਕਰੋ';

  @override
  String get emailNotifications => 'ਈਮੇਲ ਸੂਚਨਾਵਾਂ';

  @override
  String get emailNotificationsDescription =>
      'ਮਹੱਤਵਪੂਰਨ ਅਪਡੇਟਾਂ ਲਈ\nਈਮੇਲ ਸੂਚਨਾਵਾਂ ਪ੍ਰਾਪਤ ਕਰੋ';

  @override
  String get support => 'ਸਹਾਇਤਾ';

  @override
  String get helpCenter => 'ਸਹਾਇਤਾ ਕੇਂਦਰ';

  @override
  String get getHelp => 'ਸਹਾਇਤਾ ਅਤੇ ਸਮਰਥਨ ਪ੍ਰਾਪਤ ਕਰੋ';

  @override
  String get contactUs => 'ਸਾਡੇ ਨਾਲ ਸੰਪਰਕ ਕਰੋ';

  @override
  String get contactSupport => 'ਸਹਾਇਤਾ ਲਈ ਸਾਡੇ ਨਾਲ ਸੰਪਰਕ ਕਰੋ';

  @override
  String get home => 'ਘਰ';

  @override
  String get progress => 'ਤਰੱਕੀ';

  @override
  String get selectLanguage => 'ਭਾਸ਼ਾ ਚੁਣੋ';

  @override
  String currentLanguage(Object languageName) {
    return 'ਮੌਜੂਦਾ: $languageName';
  }

  @override
  String languageChanged(Object languageName) {
    return 'ਭਾਸ਼ਾ $languageName ਵਿੱਚ ਬਦਲੀ ਗਈ';
  }

  @override
  String comingSoon(Object feature) {
    return '$feature ਜਲਦੀ ਆ ਰਿਹਾ ਹੈ!';
  }

  @override
  String get apiKeysSaved => 'API ਕੀਆਂ ਸਫਲਤਾਪੂਰਵਕ ਸੇਵ ਹੋਈਆਂ';

  @override
  String apiKeysLoadFailed(Object error) {
    return 'API ਕੀਆਂ ਲੋਡ ਕਰਨ ਵਿੱਚ ਅਸਫਲ: $error';
  }

  @override
  String apiKeysSaveFailed(Object error) {
    return 'API ਕੀਆਂ ਸੇਵ ਕਰਨ ਵਿੱਚ ਅਸਫਲ: $error';
  }

  @override
  String get progressTracking => 'ਤਰੱਕੀ ਟਰੈਕਿੰਗ ਜਲਦੀ ਆ ਰਹੀ ਹੈ!';

  @override
  String get swipeToSwitch => 'ਵਿਸ਼ੇ ਬਦਲਣ ਲਈ ਸਵਾਈਪ ਕਰੋ';

  @override
  String get swipeInstructions =>
      'ਵੱਖ-ਵੱਖ ਵਿਸ਼ਿਆਂ ਦੀ ਖੋਜ ਕਰਨ ਲਈ\nਖੱਬੇ ਜਾਂ ਸੱਜੇ ਸਵਾਈਪ ਕਰੋ';

  @override
  String get skip => 'ਛੱਡੋ';

  @override
  String get math => 'ਗਣਿਤ';

  @override
  String get science => 'ਵਿਗਿਆਨ';

  @override
  String get history => 'ਇਤਿਹਾਸ';

  @override
  String get geography => 'ਭੂਗੋਲ';

  @override
  String get solveForX => 'x ਲਈ ਹੱਲ ਕਰੋ: 2x + 5 = 15';

  @override
  String get chemicalFormula => 'ਪਾਣੀ ਦਾ ਰਸਾਇਣਕ ਸੂਤਰ ਕੀ ਹੈ?';

  @override
  String get worldWarEnd => 'ਦੂਜਾ ਵਿਸ਼ਵ ਯੁੱਧ ਕਿਸ ਸਾਲ ਖਤਮ ਹੋਇਆ?';

  @override
  String get australiaCapital => 'ਆਸਟ੍ਰੇਲੀਆ ਦੀ ਰਾਜਧਾਨੀ ਕੀ ਹੈ?';

  @override
  String get enterAnswer => 'ਆਪਣਾ ਜਵਾਬ ਹੇਠਾਂ ਦਰਜ ਕਰੋ:';

  @override
  String get answer => 'ਜਵਾਬ';

  @override
  String get showSolution => 'ਹੱਲ ਦਿਖਾਓ';

  @override
  String get solution => 'ਹੱਲ:';

  @override
  String switchedTo(Object subject) {
    return '$subject ਵਿੱਚ ਬਦਲਿਆ ਗਿਆ';
  }
}
