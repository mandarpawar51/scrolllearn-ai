// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'स्क्रॉलर्न एआई';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get account => 'खाता';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get manageProfile => 'अपनी प्रोफ़ाइल प्रबंधित करें';

  @override
  String get email => 'ईमेल';

  @override
  String get changeEmail => 'अपना ईमेल बदलें';

  @override
  String get password => 'पासवर्ड';

  @override
  String get changePassword => 'अपना पासवर्ड बदलें';

  @override
  String get preferences => 'प्राथमिकताएं';

  @override
  String get language => 'भाषा';

  @override
  String get chooseLanguage => 'अपनी पसंदीदा भाषा चुनें';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get darkModeDescription =>
      'आरामदायक देखने के अनुभव के लिए\nडार्क मोड सक्षम करें';

  @override
  String get apiConfiguration => 'एपीआई कॉन्फ़िगरेशन';

  @override
  String get aiProviderKeys => 'एआई प्रदाता कुंजी';

  @override
  String get apiKeysDescription =>
      'एआई-संचालित शिक्षण सुविधाओं को सक्षम करने के लिए अपनी एपीआई कुंजी कॉन्फ़िगर करें';

  @override
  String get openaiApiKey => 'ओपनएआई एपीआई कुंजी';

  @override
  String get geminiApiKey => 'गूगल जेमिनी एपीआई कुंजी';

  @override
  String get anthropicApiKey => 'एंथ्रोपिक क्लॉड एपीआई कुंजी';

  @override
  String get openrouterApiKey => 'ओपनराउटर एपीआई कुंजी';

  @override
  String get saveApiKeys => 'एपीआई कुंजी सहेजें';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get appNotifications => 'ऐप सूचनाएं';

  @override
  String get appNotificationsDescription =>
      'नई सामग्री और अपडेट के लिए\nसूचनाएं प्राप्त करें';

  @override
  String get emailNotifications => 'ईमेल सूचनाएं';

  @override
  String get emailNotificationsDescription =>
      'महत्वपूर्ण अपडेट के लिए\nईमेल सूचनाएं प्राप्त करें';

  @override
  String get support => 'सहायता';

  @override
  String get helpCenter => 'सहायता केंद्र';

  @override
  String get getHelp => 'सहायता और समर्थन प्राप्त करें';

  @override
  String get contactUs => 'संपर्क करें';

  @override
  String get contactSupport => 'सहायता के लिए हमसे संपर्क करें';

  @override
  String get home => 'होम';

  @override
  String get progress => 'प्रगति';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String currentLanguage(Object languageName) {
    return 'वर्तमान: $languageName';
  }

  @override
  String languageChanged(Object languageName) {
    return 'भाषा बदलकर $languageName कर दी गई';
  }

  @override
  String comingSoon(Object feature) {
    return '$feature जल्द आ रहा है!';
  }

  @override
  String get apiKeysSaved => 'एपीआई कुंजी सफलतापूर्वक सहेजी गई';

  @override
  String apiKeysLoadFailed(Object error) {
    return 'एपीआई कुंजी लोड करने में विफल: $error';
  }

  @override
  String apiKeysSaveFailed(Object error) {
    return 'एपीआई कुंजी सहेजने में विफल: $error';
  }

  @override
  String get progressTracking => 'प्रगति ट्रैकिंग जल्द आ रही है!';

  @override
  String get swipeToSwitch => 'विषय बदलने के लिए स्वाइप करें';

  @override
  String get swipeInstructions =>
      'विभिन्न विषयों का अन्वेषण करने के लिए\nबाएं या दाएं स्वाइप करें';

  @override
  String get skip => 'छोड़ें';

  @override
  String get math => 'गणित';

  @override
  String get science => 'विज्ञान';

  @override
  String get history => 'इतिहास';

  @override
  String get geography => 'भूगोल';

  @override
  String get solveForX => 'x के लिए हल करें: 2x + 5 = 15';

  @override
  String get chemicalFormula => 'पानी का रासायनिक सूत्र क्या है?';

  @override
  String get worldWarEnd => 'द्वितीय विश्व युद्ध किस वर्ष समाप्त हुआ?';

  @override
  String get australiaCapital => 'ऑस्ट्रेलिया की राजधानी क्या है?';

  @override
  String get enterAnswer => 'नीचे अपना उत्तर दर्ज करें:';

  @override
  String get answer => 'उत्तर';

  @override
  String get showSolution => 'समाधान दिखाएं';

  @override
  String get solution => 'समाधान:';

  @override
  String switchedTo(Object subject) {
    return '$subject पर स्विच किया गया';
  }
}
