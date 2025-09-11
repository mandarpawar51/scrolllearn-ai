import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrolllearn_ai/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

/// Simple smoke test to verify the app starts without crashing
/// This is the most basic test to ensure your app is functional
void main() {
  group('Smoke Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('App starts without crashing', (WidgetTester tester) async {
      // This is the most basic test - just start the app
      app.main();
      
      // Wait for the app to initialize
      await tester.pumpAndSettle(const Duration(seconds: 5));
      
      // Verify the app created a MaterialApp widget
      expect(find.byType(MaterialApp), findsOneWidget);
      
      print('✅ App started successfully without crashing');
    });

    testWidgets('App shows some content', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // Verify there's at least a Scaffold (basic screen structure)
      expect(find.byType(Scaffold), findsWidgets);
      
      print('✅ App displays basic UI structure');
    });

    testWidgets('App responds to basic interaction', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // Try a basic tap interaction
      final scaffold = find.byType(Scaffold);
      if (scaffold.evaluate().isNotEmpty) {
        await tester.tap(scaffold.first);
        await tester.pump();
        
        // App should still be running after interaction
        expect(find.byType(MaterialApp), findsOneWidget);
      }
      
      print('✅ App responds to basic user interaction');
    });

    testWidgets('App handles multiple pumps without issues', (WidgetTester tester) async {
      app.main();
      
      // Pump multiple times to simulate time passing
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      
      await tester.pumpAndSettle();
      
      // App should still be stable
      expect(find.byType(MaterialApp), findsOneWidget);
      
      print('✅ App remains stable over time');
    });
  });
}