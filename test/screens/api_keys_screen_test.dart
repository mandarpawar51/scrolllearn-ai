import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrolllearn_ai/screens/api_keys_screen.dart';
import 'package:scrolllearn_ai/screens/gesture_tutorial_screen.dart';

void main() {
  group('APIKeysScreen', () {
    testWidgets('should display API keys screen with proper title and fields', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: APIKeysScreen(),
        ),
      );

      // Wait for animations to complete
      await tester.pumpAndSettle();

      // Verify the screen title is displayed
      expect(find.text('API Keys'), findsOneWidget);
      expect(find.text('Configure AI Providers'), findsOneWidget);

      // Verify all three API key fields are present
      expect(find.text('OpenAI API Key'), findsOneWidget);
      expect(find.text('Google Gemini API Key'), findsOneWidget);
      expect(find.text('Anthropic (Claude) API Key'), findsOneWidget);

      // Verify action buttons are present
      expect(find.text('Save & Continue'), findsOneWidget);
      expect(find.text('Skip for now'), findsOneWidget);

      // Verify back button is present
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should show/hide API key text when visibility toggle is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: APIKeysScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Find the first visibility toggle button (OpenAI field)
      final visibilityToggle = find.byIcon(Icons.visibility).first;
      expect(visibilityToggle, findsOneWidget);

      // Tap the visibility toggle
      await tester.tap(visibilityToggle);
      await tester.pump();

      // Verify the icon changed to visibility_off
      expect(find.byIcon(Icons.visibility_off), findsAtLeastNWidgets(1));
    });

    testWidgets('should navigate back when back button is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const APIKeysScreen()),
                ),
                child: const Text('Go to API Keys'),
              ),
            ),
          ),
        ),
      );

      // Navigate to API keys screen
      await tester.tap(find.text('Go to API Keys'));
      await tester.pumpAndSettle();

      // Verify we're on the API keys screen
      expect(find.text('API Keys'), findsOneWidget);

      // Tap the back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify we're back to the original screen
      expect(find.text('Go to API Keys'), findsOneWidget);
      expect(find.text('API Keys'), findsNothing);
    });

    testWidgets('should navigate to gesture tutorial when skip is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: APIKeysScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify we're on the API keys screen
      expect(find.text('API Keys'), findsOneWidget);

      // Scroll to make the skip button visible
      await tester.ensureVisible(find.text('Skip for now'));

      // Tap the skip button
      await tester.tap(find.text('Skip for now'));
      await tester.pumpAndSettle();

      // Verify we're now on the gesture tutorial screen
      expect(find.text('Welcome to ScrollLearn AI'), findsOneWidget);
      expect(find.byType(GestureTutorialScreen), findsOneWidget);
    });

    testWidgets('should navigate to gesture tutorial after saving valid API keys', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: APIKeysScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Enter a valid OpenAI API key
      final openaiField = find.byType(TextFormField).first;
      await tester.enterText(openaiField, 'sk-test1234567890abcdefghijklmnopqrstuvwxyz');

      // Scroll to make the save button visible
      await tester.ensureVisible(find.text('Save & Continue'));

      // Tap save and continue
      await tester.tap(find.text('Save & Continue'));
      await tester.pumpAndSettle();

      // Verify we're now on the gesture tutorial screen
      expect(find.text('Welcome to ScrollLearn AI'), findsOneWidget);
      expect(find.byType(GestureTutorialScreen), findsOneWidget);
    });
  });
}