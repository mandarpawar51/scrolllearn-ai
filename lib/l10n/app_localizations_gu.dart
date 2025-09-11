// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appTitle => 'સ્ક્રોલલર્ન AI';

  @override
  String get settings => 'સેટિંગ્સ';

  @override
  String get account => 'ખાતું';

  @override
  String get profile => 'પ્રોફાઇલ';

  @override
  String get manageProfile => 'તમારી પ્રોફાઇલ મેનેજ કરો';

  @override
  String get email => 'ઇમેઇલ';

  @override
  String get changeEmail => 'તમારો ઇમેઇલ બદલો';

  @override
  String get password => 'પાસવર્ડ';

  @override
  String get changePassword => 'તમારો પાસવર્ડ બદલો';

  @override
  String get preferences => 'પસંદગીઓ';

  @override
  String get language => 'ભાષા';

  @override
  String get chooseLanguage => 'તમારી પસંદીદા ભાષા પસંદ કરો';

  @override
  String get darkMode => 'ડાર્ક મોડ';

  @override
  String get darkModeDescription =>
      'આરામદાયક જોવાના અનુભવ માટે\nડાર્ક મોડ સક્ષમ કરો';

  @override
  String get apiConfiguration => 'API કોન્ફિગરેશન';

  @override
  String get aiProviderKeys => 'AI પ્રદાતા કીઓ';

  @override
  String get apiKeysDescription =>
      'AI-સંચાલિત શિક્ષણ સુવિધાઓ સક્ષમ કરવા માટે તમારી API કીઓ કોન્ફિગર કરો';

  @override
  String get openaiApiKey => 'OpenAI API કી';

  @override
  String get geminiApiKey => 'Google Gemini API કી';

  @override
  String get anthropicApiKey => 'Anthropic Claude API કી';

  @override
  String get openrouterApiKey => 'OpenRouter API કી';

  @override
  String get saveApiKeys => 'API કીઓ સેવ કરો';

  @override
  String get notifications => 'સૂચનાઓ';

  @override
  String get appNotifications => 'એપ સૂચનાઓ';

  @override
  String get appNotificationsDescription =>
      'નવી સામગ્રી અને અપડેટ્સ માટે\nસૂચનાઓ પ્રાપ્ત કરો';

  @override
  String get emailNotifications => 'ઇમેઇલ સૂચનાઓ';

  @override
  String get emailNotificationsDescription =>
      'મહત્વપૂર્ણ અપડેટ્સ માટે\nઇમેઇલ સૂચનાઓ મેળવો';

  @override
  String get support => 'સપોર્ટ';

  @override
  String get helpCenter => 'હેલ્પ સેન્ટર';

  @override
  String get getHelp => 'મદદ અને સપોર્ટ મેળવો';

  @override
  String get contactUs => 'અમારો સંપર્ક કરો';

  @override
  String get contactSupport => 'સહાય માટે અમારો સંપર્ક કરો';

  @override
  String get home => 'હોમ';

  @override
  String get progress => 'પ્રગતિ';

  @override
  String get selectLanguage => 'ભાષા પસંદ કરો';

  @override
  String currentLanguage(Object languageName) {
    return 'વર્તમાન: $languageName';
  }

  @override
  String languageChanged(Object languageName) {
    return 'ભાષા $languageName માં બદલાઈ';
  }

  @override
  String comingSoon(Object feature) {
    return '$feature જલ્દી આવી રહ્યું છે!';
  }

  @override
  String get apiKeysSaved => 'API કીઓ સફળતાપૂર્વક સેવ થઈ';

  @override
  String apiKeysLoadFailed(Object error) {
    return 'API કીઓ લોડ કરવામાં નિષ્ફળ: $error';
  }

  @override
  String apiKeysSaveFailed(Object error) {
    return 'API કીઓ સેવ કરવામાં નિષ્ફળ: $error';
  }

  @override
  String get progressTracking => 'પ્રગતિ ટ્રેકિંગ જલ્દી આવી રહ્યું છે!';

  @override
  String get swipeToSwitch => 'વિષયો બદલવા માટે સ્વાઇપ કરો';

  @override
  String get swipeInstructions =>
      'વિવિધ વિષયો એક્સપ્લોર કરવા માટે\nડાબે અથવા જમણે સ્વાઇપ કરો';

  @override
  String get skip => 'છોડો';

  @override
  String get math => 'ગણિત';

  @override
  String get science => 'વિજ્ઞાન';

  @override
  String get history => 'ઇતિહાસ';

  @override
  String get geography => 'ભૂગોળ';

  @override
  String get solveForX => 'x માટે ઉકેલો: 2x + 5 = 15';

  @override
  String get chemicalFormula => 'પાણીનું રાસાયણિક સૂત્ર શું છે?';

  @override
  String get worldWarEnd => 'બીજું વિશ્વયુદ્ધ કયા વર્ષે સમાપ્ત થયું?';

  @override
  String get australiaCapital => 'ઓસ્ટ્રેલિયાની રાજધાની શું છે?';

  @override
  String get enterAnswer => 'તમારો જવાબ નીચે દાખલ કરો:';

  @override
  String get answer => 'જવાબ';

  @override
  String get showSolution => 'ઉકેલ બતાવો';

  @override
  String get solution => 'ઉકેલ:';

  @override
  String switchedTo(Object subject) {
    return '$subject માં બદલાયું';
  }
}
