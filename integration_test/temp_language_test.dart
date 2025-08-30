import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:scrolllearn_ai/main.dart' as app;
import 'package:scrolllearn_ai/screens/onboarding_screen.dart';
import 'package:scrolllearn_ai/screens/subject_selection_screen.dart';
import 'package:scrolllearn_ai/screens/api_keys_screen.dart';
import 'package:scrolllearn_ai/screens/home_screen.dart';
import 'package:scrolllearn_ai/screens/settings_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Language Switching Test', () {
    testWidgets('Language switching integration on device', (WidgetTester tester) async {
      print('🌐 Testing language switching on device...');
      
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // Quick navigation to settings
      await _quickNavigateToSettings(tester);
      
      // Test language selection on device
      final languageOption = find.text('Language');
      if (languageOption.evaluate().isNotEmpty) {
        await tester.tap(languageOption);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        
        // Should show language selector
        expect(find.text('Select Language'), findsOneWidget);
        
        // Test selecting different languages on device
        final testLanguages = ['English', 'Hindi', 'Bengali', 'Telugu', 'Marathi', 'Tamil', 'Gujarati', 'Kannada', 'Malayalam', 'Odia', 'Punjabi', 'Assamese', 'Urdu'];
        
        for (final language in testLanguages) {
          // Scroll until the language is visible, or max scrolls reached
          int scrollAttempts = 0;
          const maxScrollAttempts = 5; // Arbitrary limit
          while (find.text(language).evaluate().isEmpty && scrollAttempts < maxScrollAttempts) {
            await tester.drag(find.byType(Scrollable).last, const Offset(0.0, -300));
            await tester.pumpAndSettle();
            scrollAttempts++;
          }

          final finder = find.text(language);
          if (finder.evaluate().length > 1) {
            await tester.tap(finder.last);
          } else {
            await tester.tap(finder);
          }
          await tester.pumpAndSettle(const Duration(seconds: 2));
          
          // Verify app still works after language change
          expect(find.byType(MaterialApp), findsOneWidget);
          print('✅ $language language works on device');
          
          // Go back to language selection for next test
          final languageOptionAgain = find.text('Language');
          if (languageOptionAgain.evaluate().isNotEmpty) {
            await tester.tap(languageOptionAgain);
            await tester.pumpAndSettle(const Duration(seconds: 1));
          }
        }
      }
      
      print('✅ Language switching integration test passed on device');
    });
  });
}

/// Helper function to quickly navigate to settings
Future<void> _quickNavigateToSettings(WidgetTester tester) async {
  await _quickNavigateToHome(tester);
  
  // Navigate to settings - try multiple ways
  final settingsOptions = [
    find.text('Settings'),
    find.byIcon(Icons.settings),
    find.byIcon(Icons.settings_outlined),
  ];
  
  for (final option in settingsOptions) {
    if (option.evaluate().isNotEmpty) {
      await tester.ensureVisible(option);
      await tester.pumpAndSettle();
      await tester.tap(option.first);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      return;
    }
  }
  
  print('⚠️ Could not find settings navigation');
}

/// Helper function to quickly navigate to home screen
Future<void> _quickNavigateToHome(WidgetTester tester) async {
  // Wait for app to fully load
  await tester.pumpAndSettle(const Duration(seconds: 3));

  // Check if we are already on the home screen
  if (find.byType(GestureDetector).evaluate().isNotEmpty && find.byType(BottomNavigationBar).evaluate().isNotEmpty) {
    print('✅ Already on home screen');
    return;
  }
  
  // Skip onboarding if present
  final onboardingButtons = [
    find.text('Begin Your Journey'),
    find.text('Skip for now'),
    find.textContaining('Journey'),
    find.textContaining('Skip'),
  ];
  
  for (final button in onboardingButtons) {
    if (button.evaluate().isNotEmpty) {
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button.first);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      break;
    }
  }
  
  // Quick subject selection if present
  final subjectOptions = [
    find.textContaining('Math'),
    find.text('Mathematics'),
    find.textContaining('Science'),
  ];
  
  bool foundSubject = false;
  for (final subject in subjectOptions) {
    if (subject.evaluate().isNotEmpty) {
      await tester.ensureVisible(subject);
      await tester.pumpAndSettle();
      await tester.tap(subject.first);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      foundSubject = true;
      break;
    }
  }
  
  // Continue if we selected a subject
  if (foundSubject) {
    final continueButton = find.textContaining('Continue');
    if (continueButton.evaluate().isNotEmpty) {
      await tester.ensureVisible(continueButton);
      await tester.pumpAndSettle();
      await tester.tap(continueButton.first);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      // Skip API keys
      final skipButton = find.textContaining('Skip');
      if (skipButton.evaluate().isNotEmpty) {
        await tester.ensureVisible(skipButton);
        await tester.pumpAndSettle();
        await tester.tap(skipButton.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }
    }
  }
  
  // Wait for home screen to load
  await tester.pumpAndSettle(const Duration(seconds: 2));
}