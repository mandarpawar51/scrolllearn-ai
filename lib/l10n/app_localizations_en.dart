// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ScrollLearn AI';

  @override
  String get settings => 'Settings';

  @override
  String get account => 'Account';

  @override
  String get profile => 'Profile';

  @override
  String get manageProfile => 'Manage your profile';

  @override
  String get email => 'Email';

  @override
  String get changeEmail => 'Change your email';

  @override
  String get password => 'Password';

  @override
  String get changePassword => 'Change your password';

  @override
  String get preferences => 'Preferences';

  @override
  String get language => 'Language';

  @override
  String get chooseLanguage => 'Choose your preferred language';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkModeDescription =>
      'Enable dark mode for a\ncomfortable viewing experience';

  @override
  String get apiConfiguration => 'API Configuration';

  @override
  String get aiProviderKeys => 'AI Provider Keys';

  @override
  String get apiKeysDescription =>
      'Configure your API keys to enable AI-powered learning features';

  @override
  String get openaiApiKey => 'OpenAI API Key';

  @override
  String get geminiApiKey => 'Google Gemini API Key';

  @override
  String get anthropicApiKey => 'Anthropic Claude API Key';

  @override
  String get openrouterApiKey => 'OpenRouter API Key';

  @override
  String get saveApiKeys => 'Save API Keys';

  @override
  String get notifications => 'Notifications';

  @override
  String get appNotifications => 'App Notifications';

  @override
  String get appNotificationsDescription =>
      'Receive notifications for new\ncontent and updates';

  @override
  String get emailNotifications => 'Email Notifications';

  @override
  String get emailNotificationsDescription =>
      'Get email notifications for\nimportant updates';

  @override
  String get support => 'Support';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get getHelp => 'Get help and support';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get contactSupport => 'Contact us for assistance';

  @override
  String get home => 'Home';

  @override
  String get progress => 'Progress';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String currentLanguage(Object languageName) {
    return 'Current: $languageName';
  }

  @override
  String languageChanged(Object languageName) {
    return 'Language changed to $languageName';
  }

  @override
  String comingSoon(Object feature) {
    return '$feature coming soon!';
  }

  @override
  String get apiKeysSaved => 'API keys saved successfully';

  @override
  String apiKeysLoadFailed(Object error) {
    return 'Failed to load API keys: $error';
  }

  @override
  String apiKeysSaveFailed(Object error) {
    return 'Failed to save API keys: $error';
  }

  @override
  String get progressTracking => 'Progress tracking coming soon!';

  @override
  String get swipeToSwitch => 'Swipe to Switch Subjects';

  @override
  String get swipeInstructions =>
      'Swipe left or right to explore\ndifferent subjects';

  @override
  String get skip => 'Skip';

  @override
  String get math => 'Math';

  @override
  String get science => 'Science';

  @override
  String get history => 'History';

  @override
  String get geography => 'Geography';

  @override
  String get solveForX => 'Solve for x: 2x + 5 = 15';

  @override
  String get chemicalFormula => 'What is the chemical formula for water?';

  @override
  String get worldWarEnd => 'In which year did World War II end?';

  @override
  String get australiaCapital => 'What is the capital of Australia?';

  @override
  String get enterAnswer => 'Enter your answer below:';

  @override
  String get answer => 'Answer';

  @override
  String get showSolution => 'Show Solution';

  @override
  String get solution => 'Solution:';

  @override
  String switchedTo(Object subject) {
    return 'Switched to $subject';
  }
}
