import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrolllearn_ai/screens/gesture_tutorial_screen.dart';

void main() {
  group('GestureTutorialScreen Widget Tests', () {
    testWidgets('should display initial tutorial screen with welcome message', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: GestureTutorialScreen(),
        ),
      );
      
      // Wait for animations to complete
      await tester.pumpAndSettle();
      
      // Verify welcome screen elements
      expect(find.text('Welcome to ScrollLearn AI'), findsOneWidget);
      expect(find.text('Learn through intuitive gestures! Swipe in different directions to access subjects.'), findsOneWidget);
      expect(find.text('1/6'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
      
      // Verify progress indicator
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('should navigate through tutorial pages using Next button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: GestureTutorialScreen(),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Navigate to second page (Math)
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      
      expect(find.text('Swipe Down for Math'), findsOneWidget);
      expect(find.text('2/6'), findsOneWidget);
      expect(find.text('Previous'), findsOneWidget);
      
      // Navigate to third page (Science)
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      
      expect(find.text('Swipe Up for Science'), findsOneWidget);
      expect(find.text('3/6'), findsOneWidget);
    });

    testWidgets('should navigate backwards using Previous button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: GestureTutorialScreen(),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Navigate forward then backward
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Previous'));
      await tester.pumpAndSettle();
      
      expect(find.text('Welcome to ScrollLearn AI'), findsOneWidget);
      expect(find.text('1/6'), findsOneWidget);
      expect(find.text('Previous'), findsNothing);
    });

    testWidgets('should enter practice mode on final page', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: GestureTutorialScreen(),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Navigate to practice page (page 6)
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
      }
      
      expect(find.text('Practice Time!'), findsOneWidget);
      expect(find.text('Try swiping in\nany direction'), findsOneWidget);
      expect(find.text('Progress: 0/4 gestures completed'), findsOneWidget);
      
      // Verify Start Learning button is disabled initially
      final startButton = find.text('Start Learning');
      expect(startButton, findsOneWidget);
      
      final elevatedButton = tester.widget<ElevatedButton>(
        find.ancestor(
          of: startButton,
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(elevatedButton.onPressed, isNull);
    });

    testWidgets('should detect and track gesture completion in practice mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: GestureTutorialScreen(),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Navigate to practice page
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
      }
      
      // Find the practice area
      final practiceArea = find.byType(GestureDetector).last;
      expect(practiceArea, findsOneWidget);
      
      // Simulate a downward swipe (Math)
      await tester.fling(
        practiceArea,
        const Offset(0, 300), // Downward swipe
        1000, // Velocity
      );
      await tester.pumpAndSettle();
      
      // Verify progress updated
      expect(find.text('Progress: 1/4 gestures completed'), findsOneWidget);
      
      // Verify success message appears
      expect(find.text('✓ Math gesture completed!'), findsOneWidget);
    });

    testWidgets('should complete full tutorial flow', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: GestureTutorialScreen(),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Navigate through all tutorial pages
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
      }
      
      // Complete all practice gestures
      final practiceArea = find.byType(GestureDetector).last;
      final gestures = [
        const Offset(0, 300),   // Down - Math
        const Offset(0, -300),  // Up - Science
        const Offset(300, 0),   // Right - History
        const Offset(-300, 0),  // Left - Geography
      ];
      
      for (final gesture in gestures) {
        await tester.fling(practiceArea, gesture, 1000);
        await tester.pumpAndSettle();
      }
      
      // Tap Start Learning button
      await tester.tap(find.text('Start Learning'));
      await tester.pumpAndSettle();
      
      // Verify completion message appears
      expect(find.text('Tutorial completed! Ready to start learning.'), findsOneWidget);
    });
  });
}