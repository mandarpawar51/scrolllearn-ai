// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Assamese (`as`).
class AppLocalizationsAs extends AppLocalizations {
  AppLocalizationsAs([String locale = 'as']) : super(locale);

  @override
  String get appTitle => 'স্ক্ৰললাৰ্ণ AI';

  @override
  String get settings => 'ছেটিংছ';

  @override
  String get account => 'একাউণ্ট';

  @override
  String get profile => 'প্ৰফাইল';

  @override
  String get manageProfile => 'আপোনাৰ প্ৰফাইল পৰিচালনা কৰক';

  @override
  String get email => 'ইমেইল';

  @override
  String get changeEmail => 'আপোনাৰ ইমেইল সলনি কৰক';

  @override
  String get password => 'পাছৱৰ্ড';

  @override
  String get changePassword => 'আপোনাৰ পাছৱৰ্ড সলনি কৰক';

  @override
  String get preferences => 'পছন্দসমূহ';

  @override
  String get language => 'ভাষা';

  @override
  String get chooseLanguage => 'আপোনাৰ পছন্দৰ ভাষা বাছনি কৰক';

  @override
  String get darkMode => 'ডাৰ্ক মোড';

  @override
  String get darkModeDescription =>
      'আৰামদায়ক দৰ্শন অভিজ্ঞতাৰ বাবে\nডাৰ্ক মোড সক্ৰিয় কৰক';

  @override
  String get apiConfiguration => 'API কনফিগাৰেচন';

  @override
  String get aiProviderKeys => 'AI প্ৰদানকাৰী কী';

  @override
  String get apiKeysDescription =>
      'AI-চালিত শিক্ষণ বৈশিষ্ট্যসমূহ সক্ৰিয় কৰিবলৈ আপোনাৰ API কীসমূহ কনফিগাৰ কৰক';

  @override
  String get openaiApiKey => 'OpenAI API কী';

  @override
  String get geminiApiKey => 'Google Gemini API কী';

  @override
  String get anthropicApiKey => 'Anthropic Claude API কী';

  @override
  String get openrouterApiKey => 'OpenRouter API কী';

  @override
  String get saveApiKeys => 'API কীসমূহ ছেভ কৰক';

  @override
  String get notifications => 'জাননী';

  @override
  String get appNotifications => 'এপ জাননী';

  @override
  String get appNotificationsDescription =>
      'নতুন বিষয়বস্তু আৰু আপডেটৰ বাবে\nজাননী গ্ৰহণ কৰক';

  @override
  String get emailNotifications => 'ইমেইল জাননী';

  @override
  String get emailNotificationsDescription =>
      'গুৰুত্বপূৰ্ণ আপডেটৰ বাবে\nইমেইল জাননী লাভ কৰক';

  @override
  String get support => 'সহায়';

  @override
  String get helpCenter => 'সহায় কেন্দ্ৰ';

  @override
  String get getHelp => 'সহায় আৰু সমৰ্থন লাভ কৰক';

  @override
  String get contactUs => 'আমাৰ সৈতে যোগাযোগ কৰক';

  @override
  String get contactSupport => 'সহায়ৰ বাবে আমাৰ সৈতে যোগাযোগ কৰক';

  @override
  String get home => 'ঘৰ';

  @override
  String get progress => 'অগ্ৰগতি';

  @override
  String get selectLanguage => 'ভাষা বাছনি কৰক';

  @override
  String currentLanguage(Object languageName) {
    return 'বৰ্তমান: $languageName';
  }

  @override
  String languageChanged(Object languageName) {
    return 'ভাষা $languageNameলৈ সলনি কৰা হৈছে';
  }

  @override
  String comingSoon(Object feature) {
    return '$feature শীঘ্ৰেই আহিছে!';
  }

  @override
  String get apiKeysSaved => 'API কীসমূহ সফলভাৱে ছেভ কৰা হৈছে';

  @override
  String apiKeysLoadFailed(Object error) {
    return 'API কীসমূহ লোড কৰিবলৈ ব্যৰ্থ: $error';
  }

  @override
  String apiKeysSaveFailed(Object error) {
    return 'API কীসমূহ ছেভ কৰিবলৈ ব্যৰ্থ: $error';
  }

  @override
  String get progressTracking => 'অগ্ৰগতি ট্ৰেকিং শীঘ্ৰেই আহিছে!';

  @override
  String get swipeToSwitch => 'বিষয় সলনি কৰিবলৈ স্বাইপ কৰক';

  @override
  String get swipeInstructions =>
      'বিভিন্ন বিষয় অন্বেষণ কৰিবলৈ\nবাওঁ বা সোঁফালে স্বাইপ কৰক';

  @override
  String get skip => 'এৰি দিয়ক';

  @override
  String get math => 'গণিত';

  @override
  String get science => 'বিজ্ঞান';

  @override
  String get history => 'ইতিহাস';

  @override
  String get geography => 'ভূগোল';

  @override
  String get solveForX => 'x ৰ বাবে সমাধান কৰক: 2x + 5 = 15';

  @override
  String get chemicalFormula => 'পানীৰ ৰাসায়নিক সূত্ৰ কি?';

  @override
  String get worldWarEnd => 'দ্বিতীয় বিশ্বযুদ্ধ কোন বছৰত শেষ হৈছিল?';

  @override
  String get australiaCapital => 'অষ্ট্ৰেলিয়াৰ ৰাজধানী কি?';

  @override
  String get enterAnswer => 'আপোনাৰ উত্তৰ তলত প্ৰবিষ্ট কৰক:';

  @override
  String get answer => 'উত্তৰ';

  @override
  String get showSolution => 'সমাধান দেখুৱাওক';

  @override
  String get solution => 'সমাধান:';

  @override
  String switchedTo(Object subject) {
    return '$subjectলৈ সলনি কৰা হৈছে';
  }
}
