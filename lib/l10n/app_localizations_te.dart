// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'స్క్రోల్‌లెర్న్ AI';

  @override
  String get settings => 'సెట్టింగులు';

  @override
  String get account => 'ఖాతా';

  @override
  String get profile => 'ప్రొఫైల్';

  @override
  String get manageProfile => 'మీ ప్రొఫైల్‌ను నిర్వహించండి';

  @override
  String get email => 'ఇమెయిల్';

  @override
  String get changeEmail => 'మీ ఇమెయిల్‌ను మార్చండి';

  @override
  String get password => 'పాస్‌వర్డ్';

  @override
  String get changePassword => 'మీ పాస్‌వర్డ్‌ను మార్చండి';

  @override
  String get preferences => 'ప్రాధాన్యతలు';

  @override
  String get language => 'భాష';

  @override
  String get chooseLanguage => 'మీ ఇష్టపడే భాషను ఎంచుకోండి';

  @override
  String get darkMode => 'డార్క్ మోడ్';

  @override
  String get darkModeDescription =>
      'సౌకర్యవంతమైన వీక్షణ అనుభవం కోసం\nడార్క్ మోడ్‌ను ప్రారంభించండి';

  @override
  String get apiConfiguration => 'API కాన్ఫిగరేషన్';

  @override
  String get aiProviderKeys => 'AI ప్రొవైడర్ కీలు';

  @override
  String get apiKeysDescription =>
      'AI-శక్తితో కూడిన అభ్యాస లక్షణాలను ప్రారంభించడానికి మీ API కీలను కాన్ఫిగర్ చేయండి';

  @override
  String get openaiApiKey => 'OpenAI API కీ';

  @override
  String get geminiApiKey => 'Google Gemini API కీ';

  @override
  String get anthropicApiKey => 'Anthropic Claude API కీ';

  @override
  String get openrouterApiKey => 'OpenRouter API కీ';

  @override
  String get saveApiKeys => 'API కీలను సేవ్ చేయండి';

  @override
  String get notifications => 'నోటిఫికేషన్లు';

  @override
  String get appNotifications => 'యాప్ నోటిఫికేషన్లు';

  @override
  String get appNotificationsDescription =>
      'కొత్త కంటెంట్ మరియు అప్‌డేట్‌ల కోసం\nనోటిఫికేషన్లను స్వీకరించండి';

  @override
  String get emailNotifications => 'ఇమెయిల్ నోటిఫికేషన్లు';

  @override
  String get emailNotificationsDescription =>
      'ముఖ్యమైన అప్‌డేట్‌ల కోసం\nఇమెయిల్ నోటిఫికేషన్లను పొందండి';

  @override
  String get support => 'మద్దతు';

  @override
  String get helpCenter => 'సహాయ కేంద్రం';

  @override
  String get getHelp => 'సహాయం మరియు మద్దతు పొందండి';

  @override
  String get contactUs => 'మమ్మల్ని సంప్రదించండి';

  @override
  String get contactSupport => 'సహాయం కోసం మమ్మల్ని సంప్రదించండి';

  @override
  String get home => 'హోమ్';

  @override
  String get progress => 'పురోగతి';

  @override
  String get selectLanguage => 'భాషను ఎంచుకోండి';

  @override
  String currentLanguage(Object languageName) {
    return 'ప్రస్తుత: $languageName';
  }

  @override
  String languageChanged(Object languageName) {
    return 'భాష $languageNameకు మార్చబడింది';
  }

  @override
  String comingSoon(Object feature) {
    return '$feature త్వరలో వస్తుంది!';
  }

  @override
  String get apiKeysSaved => 'API కీలు విజయవంతంగా సేవ్ చేయబడ్డాయి';

  @override
  String apiKeysLoadFailed(Object error) {
    return 'API కీలను లోడ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String apiKeysSaveFailed(Object error) {
    return 'API కీలను సేవ్ చేయడంలో విఫలమైంది: $error';
  }

  @override
  String get progressTracking => 'పురోగతి ట్రాకింగ్ త్వరలో వస్తుంది!';

  @override
  String get swipeToSwitch => 'విషయాలను మార్చడానికి స్వైప్ చేయండి';

  @override
  String get swipeInstructions =>
      'వివిధ విషయాలను అన్వేషించడానికి\nఎడమ లేదా కుడికి స్వైప్ చేయండి';

  @override
  String get skip => 'దాటవేయండి';

  @override
  String get math => 'గణితం';

  @override
  String get science => 'సైన్స్';

  @override
  String get history => 'చరిత్ర';

  @override
  String get geography => 'భూగోళశాస్త్రం';

  @override
  String get solveForX => 'x కోసం పరిష్కరించండి: 2x + 5 = 15';

  @override
  String get chemicalFormula => 'నీటి రసాయన సూత్రం ఏమిటి?';

  @override
  String get worldWarEnd => 'రెండవ ప్రపంచ యుద్ధం ఏ సంవత్సరంలో ముగిసింది?';

  @override
  String get australiaCapital => 'ఆస్ట్రేలియా రాజధాని ఏమిటి?';

  @override
  String get enterAnswer => 'మీ సమాధానాన్ని క్రింద నమోదు చేయండి:';

  @override
  String get answer => 'సమాధానం';

  @override
  String get showSolution => 'పరిష్కారాన్ని చూపించు';

  @override
  String get solution => 'పరిష్కారం:';

  @override
  String switchedTo(Object subject) {
    return '$subjectకు మార్చబడింది';
  }
}
