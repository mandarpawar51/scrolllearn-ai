import 'package:flutter/material.dart';

class LocalizationService {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'ScrollLearn AI',
      'settings': 'Settings',
      'account': 'Account',
      'preferences': 'Preferences',
      'language': 'Language',
      'currentLanguage': 'Current',
      'darkMode': 'Dark Mode',
      'darkModeDescription': 'Enable dark mode for a comfortable viewing experience',
      'apiConfiguration': 'API Configuration',
      'notifications': 'Notifications',
      'support': 'Support',
      'home': 'Home',
      'progress': 'Progress',
      'math': 'Math',
      'science': 'Science',
      'history': 'History',
      'geography': 'Geography',
      'selectLanguage': 'Select Language',
      'languageChanged': 'Language changed to',
      'swipeToSwitch': 'Swipe to Switch Subjects',
      'swipeInstructions': 'Swipe left or right to explore different subjects',
      'skip': 'Skip',
      'solveForX': 'Solve for x: 2x + 5 = 15',
      'chemicalFormula': 'What is the chemical formula for water?',
      'worldWarEnd': 'In which year did World War II end?',
      'australiaCapital': 'What is the capital of Australia?',
      'switchedTo': 'Switched to',
    },
    'hi': {
      'appTitle': 'स्क्रॉलर्न एआई',
      'settings': 'सेटिंग्स',
      'account': 'खाता',
      'preferences': 'प्राथमिकताएं',
      'language': 'भाषा',
      'currentLanguage': 'वर्तमान',
      'darkMode': 'डार्क मोड',
      'darkModeDescription': 'आरामदायक देखने के अनुभव के लिए डार्क मोड सक्षम करें',
      'apiConfiguration': 'एपीआई कॉन्फ़िगरेशन',
      'notifications': 'सूचनाएं',
      'support': 'सहायता',
      'home': 'होम',
      'progress': 'प्रगति',
      'math': 'गणित',
      'science': 'विज्ञान',
      'history': 'इतिहास',
      'geography': 'भूगोल',
      'selectLanguage': 'भाषा चुनें',
      'languageChanged': 'भाषा बदलकर',
      'swipeToSwitch': 'विषय बदलने के लिए स्वाइप करें',
      'swipeInstructions': 'विभिन्न विषयों का अन्वेषण करने के लिए बाएं या दाएं स्वाइप करें',
      'skip': 'छोड़ें',
      'solveForX': 'x के लिए हल करें: 2x + 5 = 15',
      'chemicalFormula': 'पानी का रासायनिक सूत्र क्या है?',
      'worldWarEnd': 'द्वितीय विश्व युद्ध किस वर्ष समाप्त हुआ?',
      'australiaCapital': 'ऑस्ट्रेलिया की राजधानी क्या है?',
      'switchedTo': 'पर स्विच किया गया',
    },
  };

  static String translate(String key, String languageCode) {
    return _localizedValues[languageCode]?[key] ?? 
           _localizedValues['en']?[key] ?? 
           key;
  }
}