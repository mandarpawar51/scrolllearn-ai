import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrolllearn_ai/screens/api_keys_screen.dart';
import 'package:scrolllearn_ai/screens/home_screen.dart';
import 'package:scrolllearn_ai/repositories/secure_storage_repository.dart';

void main() {
  group('API Keys Flow Integration Tests', () {
    late SecureStorageRepository repository;

    setUp(() {
      repository = SecureStorageRepository();
    });

    tearDown(() async {
      await repository.clearAllKeys();
    });

    testWidgets('should complete full API key configuration flow', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: APIKeysScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.text('Configure AI Providers'), findsOneWidget);
      expect(find.text('Save & Continue'), findsOneWidget);

      // Enter API keys
      await tester.enterText(
        find.widgetWithText(TextFormField, 'sk-...').first,
        'sk-test-openai-key-1234567890123456789',
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your Gemini API key').first,
        'gemini-test-key-1234567890123456789',
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'sk-ant-...').first,
        'sk-ant-test-anthropic-key-1234567890123456789',
      );

      // Scroll to make the save button visible
      await tester.ensureVisible(find.text('Save & Continue'));

      // Tap Save & Continue
      await tester.tap(find.text('Save & Continue'));
      await tester.pumpAndSettle();

      // Verify success message appears and navigation to gesture tutorial
      expect(find.text('API keys saved successfully!'), findsOneWidget);
      
      // Wait a bit more for navigation to complete
      await tester.pumpAndSettle();
      
      // Verify we're now on the home screen
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('should show validation errors for invalid API keys', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: APIKeysScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Enter invalid OpenAI key
      await tester.enterText(
        find.widgetWithText(TextFormField, 'sk-...').first,
        'invalid-key',
      );

      // Tap Save & Continue
      await tester.tap(find.text('Save & Continue'));
      await tester.pump();

      // Verify validation error appears
      expect(find.text('Invalid openai API key format'), findsOneWidget);
    });

    testWidgets('should allow skipping API key configuration', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: APIKeysScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Scroll to make the skip button visible
      await tester.ensureVisible(find.text('Skip for now'));

      // Tap Skip
      await tester.tap(find.text('Skip for now'));
      await tester.pumpAndSettle();

      // Verify navigation to home screen
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: APIKeysScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Enter a test key
      const testKey = 'sk-test-key-1234567890123456789';
      final textField = find.widgetWithText(TextFormField, 'sk-...').first;
      
      await tester.enterText(textField, testKey);
      await tester.pump();

      // Find the visibility toggle button for the first field
      final visibilityToggle = find.descendant(
        of: textField,
        matching: find.byIcon(Icons.visibility),
      );

      // Initially should be obscured (visibility icon shown)
      expect(visibilityToggle, findsOneWidget);

      // Tap to show text
      await tester.tap(visibilityToggle);
      await tester.pump();

      // Now should show visibility_off icon
      expect(find.descendant(
        of: textField,
        matching: find.byIcon(Icons.visibility_off),
      ), findsOneWidget);
    });

    testWidgets('should show loading state during save', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: APIKeysScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Enter valid API key
      await tester.enterText(
        find.widgetWithText(TextFormField, 'sk-...').first,
        'sk-test-openai-key-1234567890123456789',
      );

      // Tap Save & Continue
      await tester.tap(find.text('Save & Continue'));
      await tester.pump(); // Don't settle to catch loading state

      // Verify loading indicator appears
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}