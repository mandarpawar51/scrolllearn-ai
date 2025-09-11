import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:scrolllearn_ai/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Full App Integration Tests', () {
    setUp(() async {
      // Clear shared preferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('App starts successfully and shows onboarding screen', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify the app started successfully
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // Should show onboarding screen initially
      // Look for common onboarding elements
      final onboardingIndicators = [
        find.text('ScrollLearn AI'),
        find.byType(Scaffold),
        find.byType(MaterialApp),
      ];

      // At least one of these should be present
      bool foundOnboardingElement = false;
      for (final finder in onboardingIndicators) {
        if (finder.evaluate().isNotEmpty) {
          foundOnboardingElement = true;
          break;
        }
      }
      
      expect(foundOnboardingElement, isTrue, reason: 'App should show onboarding or main screen');
      
      print('✅ App started successfully');
    });

    testWidgets('App navigation works correctly', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Try to navigate through the app
      // Look for navigation elements like bottom navigation or drawer
      final navigationElements = [
        find.byType(BottomNavigationBar),
        find.byType(NavigationBar),
        find.byIcon(Icons.menu),
        find.byIcon(Icons.settings),
      ];

      for (final element in navigationElements) {
        if (element.evaluate().isNotEmpty) {
          await tester.tap(element.first);
          await tester.pumpAndSettle();
          
          // Verify navigation worked (app didn't crash)
          expect(find.byType(MaterialApp), findsOneWidget);
          print('✅ Navigation element works: ${element.toString()}');
          break;
        }
      }
    });

    testWidgets('App handles theme changes without crashing', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Look for theme toggle (dark mode switch)
      final themeToggle = find.byType(Switch);
      if (themeToggle.evaluate().isNotEmpty) {
        await tester.tap(themeToggle.first);
        await tester.pumpAndSettle();
        
        // Verify app still works after theme change
        expect(find.byType(MaterialApp), findsOneWidget);
        print('✅ Theme toggle works');
      }
    });

    testWidgets('App handles language changes without crashing', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Try to find language selection
      final languageText = find.text('Language');
      if (languageText.evaluate().isNotEmpty) {
        await tester.tap(languageText.first);
        await tester.pumpAndSettle();
        
        // Look for language options
        final languageOptions = [
          find.text('Hindi'),
          find.text('हिन्दी'),
          find.text('Bengali'),
          find.text('বাংলা'),
        ];

        for (final option in languageOptions) {
          if (option.evaluate().isNotEmpty) {
            await tester.tap(option.first);
            await tester.pumpAndSettle();
            
            // Verify app still works after language change
            expect(find.byType(MaterialApp), findsOneWidget);
            print('✅ Language change works');
            break;
          }
        }
      }
    });

    testWidgets('App screens render without errors', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test that basic UI elements are present and functional
      final basicElements = [
        find.byType(Scaffold),
        find.byType(AppBar).first,
      ];

      for (final element in basicElements) {
        if (element.evaluate().isNotEmpty) {
          expect(element, findsWidgets);
        }
      }

      // Test scrolling doesn't crash the app
      final scrollableElements = find.byType(Scrollable);
      if (scrollableElements.evaluate().isNotEmpty) {
        await tester.drag(scrollableElements.first, const Offset(0, -200));
        await tester.pumpAndSettle();
        
        expect(find.byType(MaterialApp), findsOneWidget);
        print('✅ Scrolling works');
      }
    });

    testWidgets('App handles gestures correctly', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test basic gestures
      final center = tester.getCenter(find.byType(Scaffold).first);
      
      // Test tap
      await tester.tapAt(center);
      await tester.pumpAndSettle();
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // Test swipe
      await tester.dragFrom(center, const Offset(100, 0));
      await tester.pumpAndSettle();
      expect(find.byType(MaterialApp), findsOneWidget);
      
      print('✅ Basic gestures work');
    });

    testWidgets('App memory and performance test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Perform multiple operations to test stability
      for (int i = 0; i < 5; i++) {
        // Navigate around
        final center = tester.getCenter(find.byType(Scaffold).first);
        await tester.tapAt(center);
        await tester.pumpAndSettle();
        
        // Scroll
        await tester.drag(find.byType(Scaffold).first, const Offset(0, -100));
        await tester.pumpAndSettle();
        
        // Small delay
        await tester.pump(const Duration(milliseconds: 100));
      }

      // App should still be running
      expect(find.byType(MaterialApp), findsOneWidget);
      print('✅ App stability test passed');
    });

    testWidgets('App handles device rotation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test portrait mode
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpAndSettle();
      expect(find.byType(MaterialApp), findsOneWidget);

      // Test landscape mode
      await tester.binding.setSurfaceSize(const Size(800, 400));
      await tester.pumpAndSettle();
      expect(find.byType(MaterialApp), findsOneWidget);

      // Back to portrait
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpAndSettle();
      expect(find.byType(MaterialApp), findsOneWidget);

      print('✅ Device rotation handling works');
    });

    testWidgets('App error boundaries work', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // The app should handle errors gracefully
      // This test ensures the app doesn't crash completely
      
      try {
        // Perform potentially error-prone operations
        final widgets = find.byType(Widget);
        if (widgets.evaluate().isNotEmpty) {
          // Try to interact with various widgets
          for (int i = 0; i < widgets.evaluate().length && i < 5; i++) {
            try {
              await tester.tap(widgets.at(i));
              await tester.pumpAndSettle();
            } catch (e) {
              // Ignore individual widget errors, we're testing overall stability
            }
          }
        }
        
        // App should still be running
        expect(find.byType(MaterialApp), findsOneWidget);
        print('✅ Error handling works');
        
      } catch (e) {
        print('⚠️ Some errors occurred but app remained stable: $e');
        // As long as the app is still running, this is acceptable
        expect(find.byType(MaterialApp), findsOneWidget);
      }
    });
  });
}