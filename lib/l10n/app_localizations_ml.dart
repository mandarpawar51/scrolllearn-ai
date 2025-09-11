// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appTitle => 'സ്ക്രോൾലേൺ AI';

  @override
  String get settings => 'ക്രമീകരണങ്ങൾ';

  @override
  String get account => 'അക്കൗണ്ട്';

  @override
  String get profile => 'പ്രൊഫൈൽ';

  @override
  String get manageProfile => 'നിങ്ങളുടെ പ്രൊഫൈൽ നിയന്ത്രിക്കുക';

  @override
  String get email => 'ഇമെയിൽ';

  @override
  String get changeEmail => 'നിങ്ങളുടെ ഇമെയിൽ മാറ്റുക';

  @override
  String get password => 'പാസ്‌വേഡ്';

  @override
  String get changePassword => 'നിങ്ങളുടെ പാസ്‌വേഡ് മാറ്റുക';

  @override
  String get preferences => 'മുൻഗണനകൾ';

  @override
  String get language => 'ഭാഷ';

  @override
  String get chooseLanguage => 'നിങ്ങളുടെ ഇഷ്ടപ്പെട്ട ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get darkMode => 'ഡാർക്ക് മോഡ്';

  @override
  String get darkModeDescription =>
      'സുഖകരമായ കാഴ്ച അനുഭവത്തിനായി\nഡാർക്ക് മോഡ് പ്രവർത്തനക്ഷമമാക്കുക';

  @override
  String get apiConfiguration => 'API കോൺഫിഗറേഷൻ';

  @override
  String get aiProviderKeys => 'AI പ്രൊവൈഡർ കീകൾ';

  @override
  String get apiKeysDescription =>
      'AI-പവേർഡ് ലേണിംഗ് ഫീച്ചറുകൾ പ്രവർത്തനക്ഷമമാക്കാൻ നിങ്ങളുടെ API കീകൾ കോൺഫിഗർ ചെയ്യുക';

  @override
  String get openaiApiKey => 'OpenAI API കീ';

  @override
  String get geminiApiKey => 'Google Gemini API കീ';

  @override
  String get anthropicApiKey => 'Anthropic Claude API കീ';

  @override
  String get openrouterApiKey => 'OpenRouter API കീ';

  @override
  String get saveApiKeys => 'API കീകൾ സേവ് ചെയ്യുക';

  @override
  String get notifications => 'അറിയിപ്പുകൾ';

  @override
  String get appNotifications => 'ആപ്പ് അറിയിപ്പുകൾ';

  @override
  String get appNotificationsDescription =>
      'പുതിയ ഉള്ളടക്കത്തിനും അപ്‌ഡേറ്റുകൾക്കുമായി\nഅറിയിപ്പുകൾ സ്വീകരിക്കുക';

  @override
  String get emailNotifications => 'ഇമെയിൽ അറിയിപ്പുകൾ';

  @override
  String get emailNotificationsDescription =>
      'പ്രധാനപ്പെട്ട അപ്‌ഡേറ്റുകൾക്കായി\nഇമെയിൽ അറിയിപ്പുകൾ നേടുക';

  @override
  String get support => 'പിന്തുണ';

  @override
  String get helpCenter => 'സഹായ കേന്ദ്രം';

  @override
  String get getHelp => 'സഹായവും പിന്തുണയും നേടുക';

  @override
  String get contactUs => 'ഞങ്ങളെ ബന്ധപ്പെടുക';

  @override
  String get contactSupport => 'സഹായത്തിനായി ഞങ്ങളെ ബന്ധപ്പെടുക';

  @override
  String get home => 'ഹോം';

  @override
  String get progress => 'പുരോഗതി';

  @override
  String get selectLanguage => 'ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String currentLanguage(Object languageName) {
    return 'നിലവിലുള്ളത്: $languageName';
  }

  @override
  String languageChanged(Object languageName) {
    return 'ഭാഷ $languageName ലേക്ക് മാറ്റി';
  }

  @override
  String comingSoon(Object feature) {
    return '$feature ഉടൻ വരുന്നു!';
  }

  @override
  String get apiKeysSaved => 'API കീകൾ വിജയകരമായി സേവ് ചെയ്തു';

  @override
  String apiKeysLoadFailed(Object error) {
    return 'API കീകൾ ലോഡ് ചെയ്യുന്നതിൽ പരാജയപ്പെട്ടു: $error';
  }

  @override
  String apiKeysSaveFailed(Object error) {
    return 'API കീകൾ സേവ് ചെയ്യുന്നതിൽ പരാജയപ്പെട്ടു: $error';
  }

  @override
  String get progressTracking => 'പുരോഗതി ട്രാക്കിംഗ് ഉടൻ വരുന്നു!';

  @override
  String get swipeToSwitch => 'വിഷയങ്ങൾ മാറാൻ സ്വൈപ് ചെയ്യുക';

  @override
  String get swipeInstructions =>
      'വിവിധ വിഷയങ്ങൾ പര്യവേക്ഷണം ചെയ്യാൻ\nഇടത്തോട്ടോ വലത്തോട്ടോ സ്വൈപ് ചെയ്യുക';

  @override
  String get skip => 'ഒഴിവാക്കുക';

  @override
  String get math => 'ഗണിതം';

  @override
  String get science => 'ശാസ്ത്രം';

  @override
  String get history => 'ചരിത്രം';

  @override
  String get geography => 'ഭൂമിശാസ്ത്രം';

  @override
  String get solveForX => 'x നായി പരിഹരിക്കുക: 2x + 5 = 15';

  @override
  String get chemicalFormula => 'വെള്ളത്തിന്റെ രാസ സൂത്രം എന്താണ്?';

  @override
  String get worldWarEnd => 'രണ്ടാം ലോകമഹായുദ്ധം ഏത് വർഷത്തിൽ അവസാനിച്ചു?';

  @override
  String get australiaCapital => 'ഓസ്ട്രേലിയയുടെ തലസ്ഥാനം എന്താണ്?';

  @override
  String get enterAnswer => 'നിങ്ങളുടെ ഉത്തരം താഴെ നൽകുക:';

  @override
  String get answer => 'ഉത്തരം';

  @override
  String get showSolution => 'പരിഹാരം കാണിക്കുക';

  @override
  String get solution => 'പരിഹാരം:';

  @override
  String switchedTo(Object subject) {
    return '$subject ലേക്ക് മാറി';
  }
}
