// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Oriya (`or`).
class AppLocalizationsOr extends AppLocalizations {
  AppLocalizationsOr([String locale = 'or']) : super(locale);

  @override
  String get appTitle => 'ସ୍କ୍ରୋଲଲର୍ନ AI';

  @override
  String get settings => 'ସେଟିଂସ';

  @override
  String get account => 'ଖାତା';

  @override
  String get profile => 'ପ୍ରୋଫାଇଲ';

  @override
  String get manageProfile => 'ଆପଣଙ୍କ ପ୍ରୋଫାଇଲ ପରିଚାଳନା କରନ୍ତୁ';

  @override
  String get email => 'ଇମେଲ';

  @override
  String get changeEmail => 'ଆପଣଙ୍କ ଇମେଲ ପରିବର୍ତ୍ତନ କରନ୍ତୁ';

  @override
  String get password => 'ପାସୱାର୍ଡ';

  @override
  String get changePassword => 'ଆପଣଙ୍କ ପାସୱାର୍ଡ ପରିବର୍ତ୍ତନ କରନ୍ତୁ';

  @override
  String get preferences => 'ପସନ୍ଦ';

  @override
  String get language => 'ଭାଷା';

  @override
  String get chooseLanguage => 'ଆପଣଙ୍କ ପସନ୍ଦର ଭାଷା ବାଛନ୍ତୁ';

  @override
  String get darkMode => 'ଡାର୍କ ମୋଡ';

  @override
  String get darkModeDescription =>
      'ଆରାମଦାୟକ ଦେଖିବା ଅନୁଭବ ପାଇଁ\nଡାର୍କ ମୋଡ ସକ୍ରିୟ କରନ୍ତୁ';

  @override
  String get apiConfiguration => 'API କନଫିଗରେସନ';

  @override
  String get aiProviderKeys => 'AI ପ୍ରଦାନକାରୀ କି';

  @override
  String get apiKeysDescription =>
      'AI-ଚାଳିତ ଶିକ୍ଷା ବୈଶିଷ୍ଟ୍ୟ ସକ୍ରିୟ କରିବାକୁ ଆପଣଙ୍କ API କି କନଫିଗର କରନ୍ତୁ';

  @override
  String get openaiApiKey => 'OpenAI API କି';

  @override
  String get geminiApiKey => 'Google Gemini API କି';

  @override
  String get anthropicApiKey => 'Anthropic Claude API କି';

  @override
  String get openrouterApiKey => 'OpenRouter API କି';

  @override
  String get saveApiKeys => 'API କି ସେଭ କରନ୍ତୁ';

  @override
  String get notifications => 'ବିଜ୍ଞପ୍ତି';

  @override
  String get appNotifications => 'ଆପ ବିଜ୍ଞପ୍ତି';

  @override
  String get appNotificationsDescription =>
      'ନୂତନ ବିଷୟବସ୍ତୁ ଏବଂ ଅପଡେଟ ପାଇଁ\nବିଜ୍ଞପ୍ତି ଗ୍ରହଣ କରନ୍ତୁ';

  @override
  String get emailNotifications => 'ଇମେଲ ବିଜ୍ଞପ୍ତି';

  @override
  String get emailNotificationsDescription =>
      'ଗୁରୁତ୍ୱପୂର୍ଣ୍ଣ ଅପଡେଟ ପାଇଁ\nଇମେଲ ବିଜ୍ଞପ୍ତି ପାଆନ୍ତୁ';

  @override
  String get support => 'ସହାୟତା';

  @override
  String get helpCenter => 'ସହାୟତା କେନ୍ଦ୍ର';

  @override
  String get getHelp => 'ସହାୟତା ଏବଂ ସମର୍ଥନ ପାଆନ୍ତୁ';

  @override
  String get contactUs => 'ଆମକୁ ଯୋଗାଯୋଗ କରନ୍ତୁ';

  @override
  String get contactSupport => 'ସହାୟତା ପାଇଁ ଆମକୁ ଯୋଗାଯୋଗ କରନ୍ତୁ';

  @override
  String get home => 'ଘର';

  @override
  String get progress => 'ଅଗ୍ରଗତି';

  @override
  String get selectLanguage => 'ଭାଷା ବାଛନ୍ତୁ';

  @override
  String currentLanguage(Object languageName) {
    return 'ବର୍ତ୍ତମାନ: $languageName';
  }

  @override
  String languageChanged(Object languageName) {
    return 'ଭାଷା $languageNameକୁ ପରିବର୍ତ୍ତନ ହୋଇଛି';
  }

  @override
  String comingSoon(Object feature) {
    return '$feature ଶୀଘ୍ର ଆସୁଛି!';
  }

  @override
  String get apiKeysSaved => 'API କି ସଫଳତାର ସହିତ ସେଭ ହୋଇଛି';

  @override
  String apiKeysLoadFailed(Object error) {
    return 'API କି ଲୋଡ କରିବାରେ ବିଫଳ: $error';
  }

  @override
  String apiKeysSaveFailed(Object error) {
    return 'API କି ସେଭ କରିବାରେ ବିଫଳ: $error';
  }

  @override
  String get progressTracking => 'ଅଗ୍ରଗତି ଟ୍ରାକିଂ ଶୀଘ୍ର ଆସୁଛି!';

  @override
  String get swipeToSwitch => 'ବିଷୟ ବଦଳାଇବାକୁ ସ୍ୱାଇପ କରନ୍ତୁ';

  @override
  String get swipeInstructions =>
      'ବିଭିନ୍ନ ବିଷୟ ଅନ୍ୱେଷଣ କରିବାକୁ\nବାମ କିମ୍ବା ଡାହାଣକୁ ସ୍ୱାଇପ କରନ୍ତୁ';

  @override
  String get skip => 'ଛାଡନ୍ତୁ';

  @override
  String get math => 'ଗଣିତ';

  @override
  String get science => 'ବିଜ୍ଞାନ';

  @override
  String get history => 'ଇତିହାସ';

  @override
  String get geography => 'ଭୂଗୋଳ';

  @override
  String get solveForX => 'x ପାଇଁ ସମାଧାନ କରନ୍ତୁ: 2x + 5 = 15';

  @override
  String get chemicalFormula => 'ପାଣିର ରାସାୟନିକ ସୂତ୍ର କ\'ଣ?';

  @override
  String get worldWarEnd => 'ଦ୍ୱିତୀୟ ବିଶ୍ୱଯୁଦ୍ଧ କେଉଁ ବର୍ଷରେ ଶେଷ ହୋଇଥିଲା?';

  @override
  String get australiaCapital => 'ଅଷ୍ଟ୍ରେଲିଆର ରାଜଧାନୀ କ\'ଣ?';

  @override
  String get enterAnswer => 'ଆପଣଙ୍କ ଉତ୍ତର ତଳେ ପ୍ରବେଶ କରନ୍ତୁ:';

  @override
  String get answer => 'ଉତ୍ତର';

  @override
  String get showSolution => 'ସମାଧାନ ଦେଖାନ୍ତୁ';

  @override
  String get solution => 'ସମାଧାନ:';

  @override
  String switchedTo(Object subject) {
    return '$subjectକୁ ବଦଳାଯାଇଛି';
  }
}
