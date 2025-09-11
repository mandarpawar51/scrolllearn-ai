// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get appTitle => 'ಸ್ಕ್ರೋಲ್‌ಲರ್ನ್ AI';

  @override
  String get settings => 'ಸೆಟ್ಟಿಂಗ್‌ಗಳು';

  @override
  String get account => 'ಖಾತೆ';

  @override
  String get profile => 'ಪ್ರೊಫೈಲ್';

  @override
  String get manageProfile => 'ನಿಮ್ಮ ಪ್ರೊಫೈಲ್ ಅನ್ನು ನಿರ್ವಹಿಸಿ';

  @override
  String get email => 'ಇಮೇಲ್';

  @override
  String get changeEmail => 'ನಿಮ್ಮ ಇಮೇಲ್ ಬದಲಾಯಿಸಿ';

  @override
  String get password => 'ಪಾಸ್‌ವರ್ಡ್';

  @override
  String get changePassword => 'ನಿಮ್ಮ ಪಾಸ್‌ವರ್ಡ್ ಬದಲಾಯಿಸಿ';

  @override
  String get preferences => 'ಆದ್ಯತೆಗಳು';

  @override
  String get language => 'ಭಾಷೆ';

  @override
  String get chooseLanguage => 'ನಿಮ್ಮ ಆದ್ಯತೆಯ ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get darkMode => 'ಡಾರ್ಕ್ ಮೋಡ್';

  @override
  String get darkModeDescription =>
      'ಆರಾಮದಾಯಕ ವೀಕ್ಷಣೆ ಅನುಭವಕ್ಕಾಗಿ\nಡಾರ್ಕ್ ಮೋಡ್ ಅನ್ನು ಸಕ್ರಿಯಗೊಳಿಸಿ';

  @override
  String get apiConfiguration => 'API ಕಾನ್ಫಿಗರೇಶನ್';

  @override
  String get aiProviderKeys => 'AI ಪ್ರೊವೈಡರ್ ಕೀಗಳು';

  @override
  String get apiKeysDescription =>
      'AI-ಚಾಲಿತ ಕಲಿಕೆಯ ವೈಶಿಷ್ಟ್ಯಗಳನ್ನು ಸಕ್ರಿಯಗೊಳಿಸಲು ನಿಮ್ಮ API ಕೀಗಳನ್ನು ಕಾನ್ಫಿಗರ್ ಮಾಡಿ';

  @override
  String get openaiApiKey => 'OpenAI API ಕೀ';

  @override
  String get geminiApiKey => 'Google Gemini API ಕೀ';

  @override
  String get anthropicApiKey => 'Anthropic Claude API ಕೀ';

  @override
  String get openrouterApiKey => 'OpenRouter API ಕೀ';

  @override
  String get saveApiKeys => 'API ಕೀಗಳನ್ನು ಉಳಿಸಿ';

  @override
  String get notifications => 'ಅಧಿಸೂಚನೆಗಳು';

  @override
  String get appNotifications => 'ಅಪ್ಲಿಕೇಶನ್ ಅಧಿಸೂಚನೆಗಳು';

  @override
  String get appNotificationsDescription =>
      'ಹೊಸ ವಿಷಯ ಮತ್ತು ಅಪ್‌ಡೇಟ್‌ಗಳಿಗಾಗಿ\nಅಧಿಸೂಚನೆಗಳನ್ನು ಸ್ವೀಕರಿಸಿ';

  @override
  String get emailNotifications => 'ಇಮೇಲ್ ಅಧಿಸೂಚನೆಗಳು';

  @override
  String get emailNotificationsDescription =>
      'ಪ್ರಮುಖ ಅಪ್‌ಡೇಟ್‌ಗಳಿಗಾಗಿ\nಇಮೇಲ್ ಅಧಿಸೂಚನೆಗಳನ್ನು ಪಡೆಯಿರಿ';

  @override
  String get support => 'ಬೆಂಬಲ';

  @override
  String get helpCenter => 'ಸಹಾಯ ಕೇಂದ್ರ';

  @override
  String get getHelp => 'ಸಹಾಯ ಮತ್ತು ಬೆಂಬಲ ಪಡೆಯಿರಿ';

  @override
  String get contactUs => 'ನಮ್ಮನ್ನು ಸಂಪರ್ಕಿಸಿ';

  @override
  String get contactSupport => 'ಸಹಾಯಕ್ಕಾಗಿ ನಮ್ಮನ್ನು ಸಂಪರ್ಕಿಸಿ';

  @override
  String get home => 'ಮುಖ್ಯಪುಟ';

  @override
  String get progress => 'ಪ್ರಗತಿ';

  @override
  String get selectLanguage => 'ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String currentLanguage(Object languageName) {
    return 'ಪ್ರಸ್ತುತ: $languageName';
  }

  @override
  String languageChanged(Object languageName) {
    return 'ಭಾಷೆಯನ್ನು $languageName ಗೆ ಬದಲಾಯಿಸಲಾಗಿದೆ';
  }

  @override
  String comingSoon(Object feature) {
    return '$feature ಶೀಘ್ರದಲ್ಲೇ ಬರುತ್ತಿದೆ!';
  }

  @override
  String get apiKeysSaved => 'API ಕೀಗಳನ್ನು ಯಶಸ್ವಿಯಾಗಿ ಉಳಿಸಲಾಗಿದೆ';

  @override
  String apiKeysLoadFailed(Object error) {
    return 'API ಕೀಗಳನ್ನು ಲೋಡ್ ಮಾಡುವಲ್ಲಿ ವಿಫಲವಾಗಿದೆ: $error';
  }

  @override
  String apiKeysSaveFailed(Object error) {
    return 'API ಕೀಗಳನ್ನು ಉಳಿಸುವಲ್ಲಿ ವಿಫಲವಾಗಿದೆ: $error';
  }

  @override
  String get progressTracking => 'ಪ್ರಗತಿ ಟ್ರ್ಯಾಕಿಂಗ್ ಶೀಘ್ರದಲ್ಲೇ ಬರುತ್ತಿದೆ!';

  @override
  String get swipeToSwitch => 'ವಿಷಯಗಳನ್ನು ಬದಲಾಯಿಸಲು ಸ್ವೈಪ್ ಮಾಡಿ';

  @override
  String get swipeInstructions =>
      'ವಿವಿಧ ವಿಷಯಗಳನ್ನು ಅನ್ವೇಷಿಸಲು\nಎಡ ಅಥವಾ ಬಲಕ್ಕೆ ಸ್ವೈಪ್ ಮಾಡಿ';

  @override
  String get skip => 'ಬಿಟ್ಟುಬಿಡಿ';

  @override
  String get math => 'ಗಣಿತ';

  @override
  String get science => 'ವಿಜ್ಞಾನ';

  @override
  String get history => 'ಇತಿಹಾಸ';

  @override
  String get geography => 'ಭೂಗೋಳ';

  @override
  String get solveForX => 'x ಗಾಗಿ ಪರಿಹರಿಸಿ: 2x + 5 = 15';

  @override
  String get chemicalFormula => 'ನೀರಿನ ರಾಸಾಯನಿಕ ಸೂತ್ರ ಏನು?';

  @override
  String get worldWarEnd => 'ಎರಡನೆಯ ಮಹಾಯುದ್ಧ ಯಾವ ವರ್ಷದಲ್ಲಿ ಕೊನೆಗೊಂಡಿತು?';

  @override
  String get australiaCapital => 'ಆಸ್ಟ್ರೇಲಿಯಾದ ರಾಜಧಾನಿ ಏನು?';

  @override
  String get enterAnswer => 'ನಿಮ್ಮ ಉತ್ತರವನ್ನು ಕೆಳಗೆ ನಮೂದಿಸಿ:';

  @override
  String get answer => 'ಉತ್ತರ';

  @override
  String get showSolution => 'ಪರಿಹಾರವನ್ನು ತೋರಿಸಿ';

  @override
  String get solution => 'ಪರಿಹಾರ:';

  @override
  String switchedTo(Object subject) {
    return '$subject ಗೆ ಬದಲಾಯಿಸಲಾಗಿದೆ';
  }
}
