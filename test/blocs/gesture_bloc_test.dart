import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:scrolllearn_ai/blocs/gesture_bloc.dart';
import 'package:scrolllearn_ai/models/gesture_models.dart';
import 'package:scrolllearn_ai/models/subject_type.dart';
import 'package:scrolllearn_ai/utils/constants.dart';

void main() {
  group('GestureBloc', () {
    late GestureBloc gestureBloc;

    setUp(() {
      gestureBloc = GestureBloc();
    });

    tearDown(() {
      gestureBloc.close();
    });

    test('initial state is GestureIdle', () {
      expect(gestureBloc.state, equals(const GestureIdle()));
    });

    group('GesturePanStart', () {
      blocTest<GestureBloc, GestureBlocState>(
        'should handle pan start event',
        build: () => gestureBloc,
        act: (bloc) => bloc.add(const GesturePanStart(Offset(100, 100))),
        expect: () => [], // Pan start doesn't emit state changes
      );
    });

    group('GesturePanUpdate', () {
      blocTest<GestureBloc, GestureBlocState>(
        'should emit GestureDetecting when pan update occurs',
        build: () => gestureBloc,
        act: (bloc) {
          bloc.add(const GesturePanStart(Offset(100, 100)));
          bloc.add(const GesturePanUpdate(Offset(150, 100), Offset(50, 0)));
        },
        expect: () => [
          isA<GestureDetecting>(),
        ],
      );

      blocTest<GestureBloc, GestureBlocState>(
        'should detect right swipe direction for History',
        build: () => gestureBloc,
        act: (bloc) {
          bloc.add(const GesturePanStart(Offset(100, 100)));
          bloc.add(const GesturePanUpdate(Offset(200, 100), Offset(100, 0)));
        },
        expect: () => [
          predicate<GestureDetecting>((state) {
            return state.gestureData.detectedDirection == GestureDirection.right;
          }),
        ],
      );

      blocTest<GestureBloc, GestureBlocState>(
        'should detect left swipe direction for Geography',
        build: () => gestureBloc,
        act: (bloc) {
          bloc.add(const GesturePanStart(Offset(200, 100)));
          bloc.add(const GesturePanUpdate(Offset(100, 100), Offset(-100, 0)));
        },
        expect: () => [
          predicate<GestureDetecting>((state) {
            return state.gestureData.detectedDirection == GestureDirection.left;
          }),
        ],
      );

      blocTest<GestureBloc, GestureBlocState>(
        'should detect down swipe direction for Math',
        build: () => gestureBloc,
        act: (bloc) {
          bloc.add(const GesturePanStart(Offset(100, 100)));
          bloc.add(const GesturePanUpdate(Offset(100, 200), Offset(0, 100)));
        },
        expect: () => [
          predicate<GestureDetecting>((state) {
            return state.gestureData.detectedDirection == GestureDirection.down;
          }),
        ],
      );

      blocTest<GestureBloc, GestureBlocState>(
        'should detect up swipe direction for Science',
        build: () => gestureBloc,
        act: (bloc) {
          bloc.add(const GesturePanStart(Offset(100, 200)));
          bloc.add(const GesturePanUpdate(Offset(100, 100), Offset(0, -100)));
        },
        expect: () => [
          predicate<GestureDetecting>((state) {
            return state.gestureData.detectedDirection == GestureDirection.up;
          }),
        ],
      );
    });

    group('GesturePanEnd', () {
      blocTest<GestureBloc, GestureBlocState>(
        'should emit GestureRecognized for valid swipe',
        build: () => gestureBloc,
        act: (bloc) {
          bloc.add(const GesturePanStart(Offset(100, 100)));
          bloc.add(const GesturePanUpdate(Offset(250, 100), Offset(150, 0))); // Right swipe > min distance
          bloc.add(const GesturePanEnd(Offset(500, 0))); // Fast velocity
        },
        expect: () => [
          isA<GestureDetecting>(),
          predicate<GestureRecognized>((state) {
            return state.result.direction == GestureDirection.right &&
                   state.result.subject == SubjectType.history;
          }),
        ],
      );

      blocTest<GestureBloc, GestureBlocState>(
        'should emit GestureInvalid for short swipe',
        build: () => gestureBloc,
        act: (bloc) {
          bloc.add(const GesturePanStart(Offset(100, 100)));
          bloc.add(const GesturePanUpdate(Offset(120, 100), Offset(20, 0))); // Short swipe
          bloc.add(const GesturePanEnd(Offset(100, 0)));
        },
        expect: () => [
          isA<GestureDetecting>(),
          predicate<GestureInvalid>((state) {
            return state.reason == 'Swipe distance too short';
          }),
        ],
      );

      blocTest<GestureBloc, GestureBlocState>(
        'should emit GestureInvalid for diagonal swipe',
        build: () => gestureBloc,
        act: (bloc) {
          bloc.add(const GesturePanStart(Offset(100, 100)));
          bloc.add(const GesturePanUpdate(Offset(200, 200), Offset(100, 100))); // Diagonal
          bloc.add(const GesturePanEnd(Offset(500, 500)));
        },
        expect: () => [
          isA<GestureDetecting>(),
          predicate<GestureInvalid>((state) {
            return state.reason == 'Gesture direction unclear';
          }),
        ],
      );
    });

    group('GestureReset', () {
      blocTest<GestureBloc, GestureBlocState>(
        'should reset to idle state',
        build: () => gestureBloc,
        seed: () => const GestureRecognized(
          GestureResult(
            direction: GestureDirection.right,
            subject: SubjectType.history,
            velocity: 500,
            distance: 150,
          ),
        ),
        act: (bloc) => bloc.add(const GestureReset()),
        expect: () => [const GestureIdle()],
      );
    });

    group('Gesture Direction Detection', () {
      test('should correctly map directions to subjects', () {
        expect(GestureDirection.up.subject, equals(SubjectType.science));
        expect(GestureDirection.down.subject, equals(SubjectType.math));
        expect(GestureDirection.left.subject, equals(SubjectType.geography));
        expect(GestureDirection.right.subject, equals(SubjectType.history));
      });
    });

    group('Debounce Timer', () {
      blocTest<GestureBloc, GestureBlocState>(
        'should auto-reset after debounce period',
        build: () => gestureBloc,
        act: (bloc) {
          bloc.add(const GesturePanStart(Offset(100, 100)));
          bloc.add(const GesturePanUpdate(Offset(250, 100), Offset(150, 0)));
          bloc.add(const GesturePanEnd(Offset(500, 0)));
        },
        wait: Duration(milliseconds: AppConstants.gestureDebounceMs + 100),
        expect: () => [
          isA<GestureDetecting>(),
          isA<GestureRecognized>(),
          const GestureIdle(),
        ],
      );
    });
  });
}