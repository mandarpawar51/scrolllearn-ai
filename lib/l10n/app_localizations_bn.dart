// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'স্ক্রলার্ন এআই';

  @override
  String get settings => 'সেটিংস';

  @override
  String get account => 'অ্যাকাউন্ট';

  @override
  String get profile => 'প্রোফাইল';

  @override
  String get manageProfile => 'আপনার প্রোফাইল পরিচালনা করুন';

  @override
  String get email => 'ইমেইল';

  @override
  String get changeEmail => 'আপনার ইমেইল পরিবর্তন করুন';

  @override
  String get password => 'পাসওয়ার্ড';

  @override
  String get changePassword => 'আপনার পাসওয়ার্ড পরিবর্তন করুন';

  @override
  String get preferences => 'পছন্দসমূহ';

  @override
  String get language => 'ভাষা';

  @override
  String get chooseLanguage => 'আপনার পছন্দের ভাষা বেছে নিন';

  @override
  String get darkMode => 'ডার্ক মোড';

  @override
  String get darkModeDescription =>
      'আরামদায়ক দেখার অভিজ্ঞতার জন্য\nডার্ক মোড সক্ষম করুন';

  @override
  String get apiConfiguration => 'এপিআই কনফিগারেশন';

  @override
  String get aiProviderKeys => 'এআই প্রদানকারী কী';

  @override
  String get apiKeysDescription =>
      'এআই-চালিত শিক্ষার বৈশিষ্ট্য সক্ষম করতে আপনার এপিআই কী কনফিগার করুন';

  @override
  String get openaiApiKey => 'ওপেনএআই এপিআই কী';

  @override
  String get geminiApiKey => 'গুগল জেমিনি এপিআই কী';

  @override
  String get anthropicApiKey => 'অ্যানথ্রোপিক ক্লড এপিআই কী';

  @override
  String get openrouterApiKey => 'ওপেনরাউটার এপিআই কী';

  @override
  String get saveApiKeys => 'এপিআই কী সংরক্ষণ করুন';

  @override
  String get notifications => 'বিজ্ঞপ্তি';

  @override
  String get appNotifications => 'অ্যাপ বিজ্ঞপ্তি';

  @override
  String get appNotificationsDescription =>
      'নতুন বিষয়বস্তু এবং আপডেটের জন্য\nবিজ্ঞপ্তি পান';

  @override
  String get emailNotifications => 'ইমেইল বিজ্ঞপ্তি';

  @override
  String get emailNotificationsDescription =>
      'গুরুত্বপূর্ণ আপডেটের জন্য\nইমেইল বিজ্ঞপ্তি পান';

  @override
  String get support => 'সহায়তা';

  @override
  String get helpCenter => 'সহায়তা কেন্দ্র';

  @override
  String get getHelp => 'সহায়তা এবং সমর্থন পান';

  @override
  String get contactUs => 'যোগাযোগ করুন';

  @override
  String get contactSupport => 'সহায়তার জন্য আমাদের সাথে যোগাযোগ করুন';

  @override
  String get home => 'হোম';

  @override
  String get progress => 'অগ্রগতি';

  @override
  String get selectLanguage => 'ভাষা নির্বাচন করুন';

  @override
  String currentLanguage(Object languageName) {
    return 'বর্তমান: $languageName';
  }

  @override
  String languageChanged(Object languageName) {
    return 'ভাষা $languageName এ পরিবর্তিত হয়েছে';
  }

  @override
  String comingSoon(Object feature) {
    return '$feature শীঘ্রই আসছে!';
  }

  @override
  String get apiKeysSaved => 'এপিআই কী সফলভাবে সংরক্ষিত হয়েছে';

  @override
  String apiKeysLoadFailed(Object error) {
    return 'এপিআই কী লোড করতে ব্যর্থ: $error';
  }

  @override
  String apiKeysSaveFailed(Object error) {
    return 'এপিআই কী সংরক্ষণ করতে ব্যর্থ: $error';
  }

  @override
  String get progressTracking => 'অগ্রগতি ট্র্যাকিং শীঘ্রই আসছে!';

  @override
  String get swipeToSwitch => 'বিষয় পরিবর্তন করতে স্বাইপ করুন';

  @override
  String get swipeInstructions =>
      'বিভিন্ন বিষয় অন্বেষণ করতে\nবাম বা ডানে স্বাইপ করুন';

  @override
  String get skip => 'এড়িয়ে যান';

  @override
  String get math => 'গণিত';

  @override
  String get science => 'বিজ্ঞান';

  @override
  String get history => 'ইতিহাস';

  @override
  String get geography => 'ভূগোল';

  @override
  String get solveForX => 'x এর জন্য সমাধান করুন: 2x + 5 = 15';

  @override
  String get chemicalFormula => 'পানির রাসায়নিক সূত্র কী?';

  @override
  String get worldWarEnd => 'দ্বিতীয় বিশ্বযুদ্ধ কোন বছর শেষ হয়েছিল?';

  @override
  String get australiaCapital => 'অস্ট্রেলিয়ার রাজধানী কী?';

  @override
  String get enterAnswer => 'নিচে আপনার উত্তর লিখুন:';

  @override
  String get answer => 'উত্তর';

  @override
  String get showSolution => 'সমাধান দেখান';

  @override
  String get solution => 'সমাধান:';

  @override
  String switchedTo(Object subject) {
    return '$subject এ স্যুইচ করা হয়েছে';
  }
}
