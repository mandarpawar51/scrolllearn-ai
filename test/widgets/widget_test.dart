// This is a basic Flutter widget test for ScrollLearn AI onboarding screen.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:scrolllearn_ai/main.dart';
import 'package:scrolllearn_ai/repositories/secure_storage_repository.dart'; // Added

// Mock SecureStorageRepository for testing
class MockSecureStorageRepository implements SecureStorageRepository {
  final Map<String, String> _mockStorage = {};

  @override
  Future<void> setOpenAIKey(String key) async {
    _mockStorage['openai_api_key'] = key;
  }

  @override
  Future<void> setGeminiKey(String key) async {
    _mockStorage['gemini_api_key'] = key;
  }

  @override
  Future<void> setAnthropicKey(String key) async {
    _mockStorage['anthropic_api_key'] = key;
  }

  @override
  Future<void> setOpenRouterKey(String key) async {
    _mockStorage['openrouter_api_key'] = key;
  }

  @override
  Future<String?> getOpenAIKey() async {
    return _mockStorage['openai_api_key'];
  }

  @override
  Future<String?> getGeminiKey() async {
    return _mockStorage['gemini_api_key'];
  }

  @override
  Future<String?> getAnthropicKey() async {
    return _mockStorage['anthropic_api_key'];
  }

  @override
  Future<String?> getOpenRouterKey() async {
    return _mockStorage['openrouter_api_key'];
  }

  @override
  Future<bool> hasAnyApiKey() async {
    return _mockStorage.isNotEmpty;
  }

  @override
  Future<void> clearAllKeys() async {
    _mockStorage.clear();
  }
}

void main() {
  testWidgets('Onboarding screen displays correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ScrollLearnApp(secureStorageRepository: MockSecureStorageRepository()));

    // Wait for animations to complete
    await tester.pumpAndSettle();

    // Verify that the onboarding screen elements are present
    expect(find.text('Unlock Your Learning Potential'), findsOneWidget);
    expect(find.text('Begin Your Journey'), findsOneWidget);
    expect(find.text('Skip for now'), findsOneWidget);
    
    // Verify that feature highlights are present
    expect(find.text('Gesture Navigation'), findsOneWidget);
    expect(find.text('AI-Powered'), findsOneWidget);
    expect(find.text('Multi-Subject'), findsOneWidget);

    // Verify that the school icon is present
    expect(find.byIcon(Icons.school_outlined), findsOneWidget);
  });

  testWidgets('Begin Journey button shows snackbar', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ScrollLearnApp(secureStorageRepository: MockSecureStorageRepository()));

    // Wait for animations to complete
    await tester.pumpAndSettle();

    // Tap the 'Begin Your Journey' button
    await tester.tap(find.text('Begin Your Journey'));
    await tester.pump();

    // Verify that the snackbar appears with the expected message
    expect(find.text('Subject selection screen will be implemented next'), findsOneWidget);
  });

  testWidgets('Skip button shows snackbar', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ScrollLearnApp(secureStorageRepository: MockSecureStorageRepository()));

    // Wait for animations to complete
    await tester.pumpAndSettle();

    // Tap the 'Skip for now' button
    await tester.tap(find.text('Skip for now'));
    await tester.pump();

    // Verify that the snackbar appears with the expected message
    expect(find.text('Subject selection screen will be implemented next'), findsOneWidget);
  });
}
