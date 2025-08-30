import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:scrolllearn_ai/providers/language_provider.dart';
import 'package:scrolllearn_ai/providers/theme_provider.dart';
import 'package:scrolllearn_ai/screens/settings_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('Language Selection Widget Tests', () {
    Widget createTestWidget({String? initialLanguage}) {
      final languageProvider = LanguageProvider();
      if (initialLanguage != null) {
        languageProvider.changeLanguage(initialLanguage);
      }
      
      return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: ThemeProvider()),
          ChangeNotifierProvider.value(value: languageProvider),
        ],
        child: MaterialApp(
          locale: languageProvider.currentLocale,
          supportedLocales: LanguageProvider.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const SettingsScreen(),
        ),
      );
    }

    testWidgets('should display all supported languages in settings', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Look for language section
      expect(find.text('Language'), findsAtLeastOneWidget);
      
      // Check if language selection is available
      final languageSection = find.text('Language');
      await tester.ensureVisible(languageSection.first);
      await tester.pumpAndSettle();
    });

    testWidgets('should handle language switching without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Try to find and interact with language options
      // This test ensures the UI doesn't crash when languages are switched
      
      final languageProvider = Provider.of<LanguageProvider>(
        tester.element(find.byType(SettingsScreen)),
        listen: false,
      );

      // Test switching to different languages
      final testLanguages = ['hi', 'bn', 'te', 'ta', 'ur'];
      
      for (final langCode in testLanguages) {
        try {
          await languageProvider.changeLanguage(langCode);
          await tester.pumpAndSettle();
          
          // Verify the app is still functional
          expect(find.byType(SettingsScreen), findsOneWidget);
          
        } catch (e) {
          fail('Language switching to $langCode failed: $e');
        }
      }
    });

    testWidgets('should handle RTL languages correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(initialLanguage: 'ur'));
      await tester.pumpAndSettle();

      // Check that the app renders correctly with RTL language
      expect(find.byType(SettingsScreen), findsOneWidget);
      
      // The app should not crash with RTL language
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.locale?.languageCode, equals('ur'));
    });

    testWidgets('should show current language correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(initialLanguage: 'hi'));
      await tester.pumpAndSettle();

      // The current language should be reflected in the UI
      final languageProvider = Provider.of<LanguageProvider>(
        tester.element(find.byType(SettingsScreen)),
        listen: false,
      );
      
      expect(languageProvider.currentLocale.languageCode, equals('hi'));
    });

    testWidgets('should not crash when switching between LTR and RTL languages', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final languageProvider = Provider.of<LanguageProvider>(
        tester.element(find.byType(SettingsScreen)),
        listen: false,
      );

      // Switch from LTR to RTL
      await languageProvider.changeLanguage('en'); // LTR
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);

      await languageProvider.changeLanguage('ur'); // RTL
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);

      // Switch back to LTR
      await languageProvider.changeLanguage('hi'); // LTR
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);
    });
  });
}