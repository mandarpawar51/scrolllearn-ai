import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:scrolllearn_ai/providers/language_provider.dart';
import 'package:scrolllearn_ai/providers/theme_provider.dart';
import 'package:scrolllearn_ai/screens/onboarding_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('Simple Widget Tests', () {
    testWidgets('OnboardingScreen renders without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LanguageProvider.supportedLocales,
            home: const OnboardingScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the screen rendered
      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      
      print('✅ OnboardingScreen renders successfully');
    });

    testWidgets('MaterialApp with providers works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LanguageProvider.supportedLocales,
            home: const Scaffold(
              body: Center(
                child: Text('Test App'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test App'), findsOneWidget);
      expect(find.byType(MaterialApp), findsOneWidget);
      
      print('✅ Basic app structure works');
    });
  });
}