import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrolllearn_ai/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen should build without errors', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    // Just verify the screen builds without throwing errors
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}