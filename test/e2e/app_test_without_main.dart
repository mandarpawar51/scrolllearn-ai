import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:scrolllearn_ai/providers/language_provider.dart';
import 'package:scrolllearn_ai/providers/theme_provider.dart';
import 'package:scrolllearn_ai/screens/onboarding_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Test the app functionality without importing main.dart directly
void main() {
  group('App Functionality Tests', () {
    Widget createTestApp() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ],
        child: Consumer2<ThemeProvider, LanguageProvider>(
          builder: (context, themeProvider, languageProvider, child) {
            return MaterialApp(
              title: 'ScrollLearn AI Test',
              theme: themeProvider.lightTheme,
              darkTheme: themeProvider.darkTheme,
              themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              locale: languageProvider.currentLocale,
              supportedLocales: LanguageProvider.supportedLanguages
                  .map((lang) => LanguageProvider.getLocaleFromCode(lang['code']!))
                  .toList(),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              builder: (context, child) {
                final locale = Localizations.localeOf(context);
                final isRTL = _isRTLLanguage(locale.languageCode);
                
                return Directionality(
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                  child: child!,
                );
              },
              home: const OnboardingScreen(),
            );
          },
        ),
      );
    }

    testWidgets('App structure works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Verify basic app structure
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(OnboardingScreen), findsOneWidget);
      
      print('✅ App structure test passed');
    });

    testWidgets('Language switching works', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      final languageProvider = Provider.of<LanguageProvider>(
        tester.element(find.byType(MaterialApp)),
        listen: false,
      );

      // Test switching to different languages
      final testLanguages = ['hi', 'bn', 'te', 'ur'];
      
      for (final langCode in testLanguages) {
        await languageProvider.changeLanguage(langCode);
        await tester.pumpAndSettle();
        
        // Verify app still works after language change
        expect(find.byType(MaterialApp), findsOneWidget);
        expect(languageProvider.currentLocale.languageCode, equals(langCode));
      }
      
      print('✅ Language switching test passed');
    });

    testWidgets('RTL languages work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      final languageProvider = Provider.of<LanguageProvider>(
        tester.element(find.byType(MaterialApp)),
        listen: false,
      );

      // Switch to Urdu (RTL language)
      await languageProvider.changeLanguage('ur');
      await tester.pumpAndSettle();
      
      // Verify app handles RTL correctly
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Directionality), findsOneWidget);
      
      final directionality = tester.widget<Directionality>(find.byType(Directionality));
      expect(directionality.textDirection, equals(TextDirection.rtl));
      
      print('✅ RTL language test passed');
    });

    testWidgets('Theme switching works', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      final themeProvider = Provider.of<ThemeProvider>(
        tester.element(find.byType(MaterialApp)),
        listen: false,
      );

      // Toggle theme
      final originalMode = themeProvider.isDarkMode;
      themeProvider.toggleTheme();
      await tester.pumpAndSettle();
      
      // Verify theme changed
      expect(themeProvider.isDarkMode, equals(!originalMode));
      expect(find.byType(MaterialApp), findsOneWidget);
      
      print('✅ Theme switching test passed');
    });

    testWidgets('App handles basic interactions', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Test basic tap interaction
      final scaffold = find.byType(Scaffold);
      if (scaffold.evaluate().isNotEmpty) {
        await tester.tap(scaffold.first);
        await tester.pumpAndSettle();
        
        // App should still be functional
        expect(find.byType(MaterialApp), findsOneWidget);
      }
      
      // Test scrolling if there are scrollable widgets
      final scrollable = find.byType(Scrollable);
      if (scrollable.evaluate().isNotEmpty) {
        await tester.drag(scrollable.first, const Offset(0, -100));
        await tester.pumpAndSettle();
        
        expect(find.byType(MaterialApp), findsOneWidget);
      }
      
      print('✅ Basic interactions test passed');
    });
  });
}

// Helper function to determine if a language is RTL
bool _isRTLLanguage(String languageCode) {
  const rtlLanguages = ['ur', 'ar', 'fa', 'he'];
  return rtlLanguages.contains(languageCode);
}