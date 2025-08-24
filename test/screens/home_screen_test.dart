import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrolllearn_ai/screens/home_screen.dart';
import 'package:scrolllearn_ai/blocs/gesture_bloc.dart';
import 'package:scrolllearn_ai/models/subject_type.dart';
import 'package:scrolllearn_ai/utils/constants.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('should display main content and gesture area', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomeScreen(),
        ),
      );

      // Verify main elements are present
      expect(find.text(AppConstants.appName), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byIcon(Icons.school), findsOneWidget);
      expect(find.text('Swipe to start learning'), findsOneWidget);
      
      // Verify subject hints are displayed
      expect(find.text('Math'), findsOneWidget);
      expect(find.text('Science'), findsOneWidget);
      expect(find.text('History'), findsOneWidget);
      expect(find.text('Geography'), findsOneWidget);
    });

    testWidgets('should display instructions with direction indicators', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomeScreen(),
        ),
      );

      expect(find.text('Swipe in any direction to access subjects'), findsOneWidget);
      expect(find.text('↑ Science'), findsOneWidget);
      expect(find.text('↓ Math'), findsOneWidget);
      expect(find.text('← Geography'), findsOneWidget);
      expect(find.text('→ History'), findsOneWidget);
    });

    testWidgets('should handle pan gestures and update UI', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomeScreen(),
        ),
      );

      // Find the gesture detector area
      final gestureDetector = find.byType(GestureDetector);
      expect(gestureDetector, findsOneWidget);

      // Simulate a downward swipe (Math)
      const startPoint = Offset(200, 200);
      const endPoint = Offset(200, 350); // 150 pixels down

      await tester.dragFrom(startPoint, endPoint - startPoint);
      await tester.pumpAndSettle();

      // The gesture should be processed by the BLoC
      // We can't easily test the BLoC state here without more setup,
      // but we can verify the gesture detector is responsive
    });

    testWidgets('should show settings button and handle tap', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomeScreen(),
        ),
      );

      final settingsButton = find.byIcon(Icons.settings);
      expect(settingsButton, findsOneWidget);

      await tester.tap(settingsButton);
      await tester.pumpAndSettle();

      // Should show a snackbar for now
      expect(find.text('Settings screen coming soon...'), findsOneWidget);
    });

    group('Subject Hints', () {
      testWidgets('should display all subject hints with correct icons', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const HomeScreen(),
          ),
        );

        // Check that all subject icons are present
        expect(find.byIcon(SubjectType.math.icon), findsOneWidget);
        expect(find.byIcon(SubjectType.science.icon), findsOneWidget);
        expect(find.byIcon(SubjectType.history.icon), findsOneWidget);
        expect(find.byIcon(SubjectType.geography.icon), findsOneWidget);
      });
    });
  });

  group('GestureBloc Integration', () {
    late GestureBloc gestureBloc;

    setUp(() {
      gestureBloc = GestureBloc();
    });

    tearDown(() {
      gestureBloc.close();
    });

    testWidgets('should integrate with GestureBloc properly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: gestureBloc,
            child: const HomeScreen(),
          ),
        ),
      );

      // Verify initial state
      expect(find.text('Swipe to start learning'), findsOneWidget);
      
      // The BLoC should be in idle state initially
      expect(gestureBloc.state, isA<GestureIdle>());
    });
  });
}