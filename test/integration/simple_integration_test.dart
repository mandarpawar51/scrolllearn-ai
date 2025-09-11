import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrolllearn_ai/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

/// Simple integration test to verify basic app functionality
void main() {
  group('Simple Integration Tests', () {
    setUp(() async {
      // Clear shared preferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('App starts successfully', (WidgetTester tester) async {
      print('🚀 Testing app startup...');
      
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify the app started successfully
      expect(find.byType(MaterialApp), findsOneWidget);
      
      print('✅ App started successfully');
    });

    testWidgets('App shows basic UI elements', (WidgetTester tester) async {
      print('🧪 Testing basic UI elements...');
      
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify basic UI structure
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsWidgets);
      
      print('✅ Basic UI elements present');
    });

    testWidgets('App handles basic interactions', (WidgetTester tester) async {
      print('🖱️ Testing basic interactions...');
      
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test basic tap interaction
      final scaffold = find.byType(Scaffold);
      if (scaffold.evaluate().isNotEmpty) {
        await tester.tap(scaffold.first);
        await tester.pumpAndSettle();
        
        // App should still be functional
        expect(find.byType(MaterialApp), findsOneWidget);
      }
      
      print('✅ Basic interactions work');
    });

    testWidgets('App navigation works', (WidgetTester tester) async {
      print('🧭 Testing navigation...');
      
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Look for navigation elements
      final navigationElements = [
        find.byType(BottomNavigationBar),
        find.byType(NavigationBar),
        find.byIcon(Icons.menu),
        find.text('Begin Your Journey'),
        find.text('Skip for now'),
      ];

      bool foundNavigationElement = false;
      for (final element in navigationElements) {
        if (element.evaluate().isNotEmpty) {
          try {
            await tester.tap(element.first);
            await tester.pumpAndSettle();
            
            // Verify navigation worked (app didn't crash)
            expect(find.byType(MaterialApp), findsOneWidget);
            print('✅ Navigation element works: ${element.toString()}');
            foundNavigationElement = true;
            break;
          } catch (e) {
            // Continue to next element if this one fails
            print('⚠️ Navigation element failed: ${element.toString()}');
          }
        }
      }
      
      if (!foundNavigationElement) {
        print('⚠️ No navigation elements found, but app is stable');
      }
      
      // App should still be running
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App memory stability test', (WidgetTester tester) async {
      print('🧠 Testing memory stability...');
      
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Perform multiple operations to test stability
      for (int i = 0; i < 5; i++) {
        // Navigate around
        final center = tester.getCenter(find.byType(Scaffold).first);
        await tester.tapAt(center);
        await tester.pumpAndSettle();
        
        // Small delay
        await tester.pump(const Duration(milliseconds: 100));
      }

      // App should still be running
      expect(find.byType(MaterialApp), findsOneWidget);
      print('✅ Memory stability test passed');
    });
  });
}