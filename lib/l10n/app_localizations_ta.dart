// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'ஸ்க்ரோல்லெர்ன் AI';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get account => 'கணக்கு';

  @override
  String get profile => 'சுயவிவரம்';

  @override
  String get manageProfile => 'உங்கள் சுயவிவரத்தை நிர்வகிக்கவும்';

  @override
  String get email => 'மின்னஞ்சல்';

  @override
  String get changeEmail => 'உங்கள் மின்னஞ்சலை மாற்றவும்';

  @override
  String get password => 'கடவுச்சொல்';

  @override
  String get changePassword => 'உங்கள் கடவுச்சொல்லை மாற்றவும்';

  @override
  String get preferences => 'விருப்பத்தேர்வுகள்';

  @override
  String get language => 'மொழி';

  @override
  String get chooseLanguage => 'உங்கள் விருப்பமான மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get darkMode => 'இருண்ட பயன்முறை';

  @override
  String get darkModeDescription =>
      'வசதியான பார்வை அனுபவத்திற்காக\nஇருண்ட பயன்முறையை இயக்கவும்';

  @override
  String get apiConfiguration => 'API கட்டமைப்பு';

  @override
  String get aiProviderKeys => 'AI வழங்குநர் விசைகள்';

  @override
  String get apiKeysDescription =>
      'AI-இயங்கும் கற்றல் அம்சங்களை இயக்க உங்கள் API விசைகளை கட்டமைக்கவும்';

  @override
  String get openaiApiKey => 'OpenAI API விசை';

  @override
  String get geminiApiKey => 'Google Gemini API விசை';

  @override
  String get anthropicApiKey => 'Anthropic Claude API விசை';

  @override
  String get openrouterApiKey => 'OpenRouter API விசை';

  @override
  String get saveApiKeys => 'API விசைகளை சேமிக்கவும்';

  @override
  String get notifications => 'அறிவிப்புகள்';

  @override
  String get appNotifications => 'பயன்பாட்டு அறிவிப்புகள்';

  @override
  String get appNotificationsDescription =>
      'புதிய உள்ளடக்கம் மற்றும் புதுப்பிப்புகளுக்கான\nஅறிவிப்புகளைப் பெறவும்';

  @override
  String get emailNotifications => 'மின்னஞ்சல் அறிவிப்புகள்';

  @override
  String get emailNotificationsDescription =>
      'முக்கியமான புதுப்பிப்புகளுக்கான\nமின்னஞ்சல் அறிவிப்புகளைப் பெறவும்';

  @override
  String get support => 'ஆதரவு';

  @override
  String get helpCenter => 'உதவி மையம்';

  @override
  String get getHelp => 'உதவி மற்றும் ஆதரவைப் பெறவும்';

  @override
  String get contactUs => 'எங்களைத் தொடர்பு கொள்ளவும்';

  @override
  String get contactSupport => 'உதவிக்காக எங்களைத் தொடர்பு கொள்ளவும்';

  @override
  String get home => 'முகப்பு';

  @override
  String get progress => 'முன்னேற்றம்';

  @override
  String get selectLanguage => 'மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String currentLanguage(Object languageName) {
    return 'தற்போதைய: $languageName';
  }

  @override
  String languageChanged(Object languageName) {
    return 'மொழி $languageNameக்கு மாற்றப்பட்டது';
  }

  @override
  String comingSoon(Object feature) {
    return '$feature விரைவில் வருகிறது!';
  }

  @override
  String get apiKeysSaved => 'API விசைகள் வெற்றிகரமாக சேமிக்கப்பட்டன';

  @override
  String apiKeysLoadFailed(Object error) {
    return 'API விசைகளை ஏற்றுவதில் தோல்வி: $error';
  }

  @override
  String apiKeysSaveFailed(Object error) {
    return 'API விசைகளை சேமிப்பதில் தோல்வி: $error';
  }

  @override
  String get progressTracking => 'முன்னேற்ற கண்காணிப்பு விரைவில் வருகிறது!';

  @override
  String get swipeToSwitch => 'பாடங்களை மாற்ற ஸ்வைப் செய்யவும்';

  @override
  String get swipeInstructions =>
      'வெவ்வேறு பாடங்களை ஆராய\nஇடது அல்லது வலது ஸ்வைப் செய்யவும்';

  @override
  String get skip => 'தவிர்க்கவும்';

  @override
  String get math => 'கணிதம்';

  @override
  String get science => 'அறிவியல்';

  @override
  String get history => 'வரலாறு';

  @override
  String get geography => 'புவியியல்';

  @override
  String get solveForX => 'x-க்கு தீர்க்கவும்: 2x + 5 = 15';

  @override
  String get chemicalFormula => 'நீரின் வேதியியல் சூத்திரம் என்ன?';

  @override
  String get worldWarEnd => 'இரண்டாம் உலகப் போர் எந்த ஆண்டில் முடிந்தது?';

  @override
  String get australiaCapital => 'ஆஸ்திரேலியாவின் தலைநகரம் என்ன?';

  @override
  String get enterAnswer => 'உங்கள் பதிலை கீழே உள்ளிடவும்:';

  @override
  String get answer => 'பதில்';

  @override
  String get showSolution => 'தீர்வைக் காட்டு';

  @override
  String get solution => 'தீர்வு:';

  @override
  String switchedTo(Object subject) {
    return '$subjectக்கு மாற்றப்பட்டது';
  }
}
