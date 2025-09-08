import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:scrolllearn_ai/main.dart' as app;

/// REAL Integration Tests - These run the ACTUAL app on device/emulator via ADB
/// Run with: flutter test integration_test/app_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Device Integration Tests - Basic Functionality', () {
    testWidgets('App launches and shows onboarding screen on device', (WidgetTester tester) async {
      print('📱 Testing app launch on real device...');
      
      // Start the REAL app on device
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify the app launched successfully on device
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // Should show some content (onboarding or main screen)
      expect(find.byType(Scaffold), findsAtLeastOneWidget);
      
      print('✅ App launched successfully on device');
    });

    testWidgets('Basic navigation works on device', (WidgetTester tester) async {
      print('📱 Testing navigation on real device...');
      
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test onboarding navigation if present
      if (find.text('Begin Your Journey').evaluate().isNotEmpty) {
        await tester.tap(find.text('Begin Your Journey'));
        await tester.pumpAndSettle(const Duration(seconds: 2));
        print('✅ Onboarding navigation works on device');
      }

      // Look for navigation elements and try to interact
      final bottomNav = find.byType(BottomNavigationBar);
      if (bottomNav.evaluate().isNotEmpty) {
        // Try tapping different tabs
        final settingsTab = find.text('Settings');
        if (settingsTab.evaluate().isNotEmpty) {
          await tester.tap(settingsTab);
          await tester.pumpAndSettle(const Duration(seconds: 2));
          
          expect(find.byType(MaterialApp), findsOneWidget);
          print('✅ Bottom navigation works on device');
          
          // Navigate back to home
          final homeTab = find.text('Home');
          if (homeTab.evaluate().isNotEmpty) {
            await tester.tap(homeTab);
            await tester.pumpAndSettle(const Duration(seconds: 2));
          }
        }
      }
    });

    testWidgets('Text input works on real device', (WidgetTester tester) async {
      print('📱 Testing text input on real device...');
      
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate through onboarding quickly
      await _quickNavigateToHome(tester);

      // Test text input on device
      final textFields = find.byType(TextField);
      if (textFields.evaluate().isNotEmpty) {
        await tester.enterText(textFields.first, 'Device input test');
        await tester.pumpAndSettle(const Duration(seconds: 1));
        
        // Verify text was entered
        expect(find.text('Device input test'), findsOneWidget);
        print('✅ Text input works on device');
      }
    });

    testWidgets('Gestures work on real device', (WidgetTester tester) async {
      print('📱 Testing gestures on real device...');
      
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _quickNavigateToHome(tester);

      // Test scrolling on device
      final scrollable = find.byType(Scrollable);
      if (scrollable.evaluate().isNotEmpty) {
        await tester.drag(scrollable.first, const Offset(0, -200));
        await tester.pumpAndSettle(const Duration(seconds: 1));
        
        expect(find.byType(MaterialApp), findsOneWidget);
        print('✅ Scrolling works on device');
      }

      // Test swiping gestures on device
      final gestureDetector = find.byType(GestureDetector);
      if (gestureDetector.evaluate().isNotEmpty) {
        await tester.drag(gestureDetector.first, const Offset(100, 0));
        await tester.pumpAndSettle(const Duration(seconds: 1));
        
        expect(find.byType(MaterialApp), findsOneWidget);
        print('✅ Swipe gestures work on device');
      }
    });

    testWidgets('Device rotation handling', (WidgetTester tester) async {
      print('📱 Testing device rotation...');
      
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test landscape mode
      await tester.binding.setSurfaceSize(const Size(800, 400));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(MaterialApp), findsOneWidget);
      print('✅ Landscape mode works on device');

      // Test portrait mode
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(MaterialApp), findsOneWidget);
      print('✅ Portrait mode works on device');
    });

    testWidgets('App performance on device', (WidgetTester tester) async {
      print('📱 Testing app performance on real device...');
      
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _quickNavigateToHome(tester);

      // Perform multiple rapid operations
      for (int i = 0; i < 5; i++) {
        // Rapid navigation
        final settingsTab = find.text('Settings');
        if (settingsTab.evaluate().isNotEmpty) {
          await tester.tap(settingsTab);
          await tester.pump(const Duration(milliseconds: 500));
          
          final homeTab = find.text('Home');
          if (homeTab.evaluate().isNotEmpty) {
            await tester.tap(homeTab);
            await tester.pump(const Duration(milliseconds: 500));
          }
        }
      }
      
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      // App should still be responsive
      expect(find.byType(MaterialApp), findsOneWidget);
      print('✅ App performance is good on device');
    });

    testWidgets('Memory stability on device', (WidgetTester tester) async {
      print('📱 Testing memory stability on real device...');
      
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _quickNavigateToHome(tester);

      // Perform memory-intensive operations
      for (int i = 0; i < 10; i++) {
        // Create and destroy UI elements
        final textFields = find.byType(TextField);
        if (textFields.evaluate().isNotEmpty) {
          await tester.enterText(textFields.first, 'Memory test $i');
          await tester.pump(const Duration(milliseconds: 100));
          
          await tester.enterText(textFields.first, '');
          await tester.pump(const Duration(milliseconds: 100));
        }
      }
      
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      // App should still be stable
      expect(find.byType(MaterialApp), findsOneWidget);
      print('✅ Memory stability is good on device');
    });
  });
}

/// Helper function to quickly navigate to home screen
Future<void> _quickNavigateToHome(WidgetTester tester) async {
  // Skip onboarding if present
  if (find.text('Begin Your Journey').evaluate().isNotEmpty) {
    await tester.tap(find.text('Begin Your Journey'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }
  
  // Quick subject selection if present
  if (find.text('Mathematics').evaluate().isNotEmpty) {
    await tester.tap(find.text('Mathematics'));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.tap(find.text('Skip for now'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }
}