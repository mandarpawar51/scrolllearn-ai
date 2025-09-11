import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/gesture_models.dart';
import '../models/subject_type.dart';
import '../utils/constants.dart';

// Events
abstract class GestureEvent extends Equatable {
  const GestureEvent();

  @override
  List<Object?> get props => [];
}

class GesturePanStart extends GestureEvent {
  final Offset position;

  const GesturePanStart(this.position);

  @override
  List<Object> get props => [position];
}

class GesturePanUpdate extends GestureEvent {
  final Offset position;
  final Offset delta;

  const GesturePanUpdate(this.position, this.delta);

  @override
  List<Object> get props => [position, delta];
}

class GesturePanEnd extends GestureEvent {
  final Offset velocity;

  const GesturePanEnd(this.velocity);

  @override
  List<Object> get props => [velocity];
}

class GestureReset extends GestureEvent {
  const GestureReset();
}

// States
abstract class GestureBlocState extends Equatable {
  const GestureBlocState();

  @override
  List<Object?> get props => [];
}

class GestureIdle extends GestureBlocState {
  const GestureIdle();
}

class GestureDetecting extends GestureBlocState {
  final GestureData gestureData;

  const GestureDetecting(this.gestureData);

  @override
  List<Object> get props => [gestureData];
}

class GestureRecognized extends GestureBlocState {
  final GestureResult result;

  const GestureRecognized(this.result);

  @override
  List<Object> get props => [result];
}

class GestureInvalid extends GestureBlocState {
  final String reason;

  const GestureInvalid(this.reason);

  @override
  List<Object> get props => [reason];
}

// BLoC
class GestureBloc extends Bloc<GestureEvent, GestureBlocState> {
  Offset? _startPosition;
  Offset? _currentPosition;
  Timer? _debounceTimer;

  GestureBloc() : super(const GestureIdle()) {
    on<GesturePanStart>(_onPanStart);
    on<GesturePanUpdate>(_onPanUpdate);
    on<GesturePanEnd>(_onPanEnd);
    on<GestureReset>(_onReset);
  }

  void _onPanStart(GesturePanStart event, Emitter<GestureBlocState> emit) {
    _startPosition = event.position;
    _cancelDebounceTimer();
  }

  void _onPanUpdate(GesturePanUpdate event, Emitter<GestureBlocState> emit) {
    if (_startPosition == null) return;

    _currentPosition = event.position;
    final delta = event.position - _startPosition!;
    final distance = delta.distance;
    final angle = _calculateAngle(delta);
    final detectedDirection = _detectDirection(delta, distance);

    final gestureData = GestureData(
      startPosition: _startPosition!,
      currentPosition: event.position,
      delta: delta,
      distance: distance,
      angle: angle,
      detectedDirection: detectedDirection,
    );

    emit(GestureDetecting(gestureData));
  }

  void _onPanEnd(GesturePanEnd event, Emitter<GestureBlocState> emit) {
    if (_startPosition == null || _currentPosition == null) {
      emit(const GestureIdle());
      return;
    }

    // Calculate final gesture data from start to current position
    final delta = _currentPosition! - _startPosition!;
    final distance = delta.distance;
    final detectedDirection = _detectDirection(delta, distance);

    // Check if gesture meets minimum requirements
    if (distance < AppConstants.minSwipeDistance) {
      print('Gesture too short: ${distance.toStringAsFixed(1)}px < ${AppConstants.minSwipeDistance}px');
      emit(const GestureInvalid('Swipe distance too short'));
      _startDebounceTimer();
      return;
    }

    if (detectedDirection == null) {
      print('Gesture direction unclear');
      emit(const GestureInvalid('Gesture direction unclear'));
      _startDebounceTimer();
      return;
    }

    // Calculate velocity
    final velocity = event.velocity.distance;

    final result = GestureResult(
      direction: detectedDirection,
      subject: detectedDirection.subject,
      velocity: velocity,
      distance: distance,
    );

    print('Gesture recognized: $detectedDirection -> ${detectedDirection.subject}');
    emit(GestureRecognized(result));
    _startDebounceTimer();
  }

  void _onReset(GestureReset event, Emitter<GestureBlocState> emit) {
    _startPosition = null;
    _currentPosition = null;
    _cancelDebounceTimer();
    emit(const GestureIdle());
  }

  double _calculateAngle(Offset delta) {
    return math.atan2(delta.dy, delta.dx) * 180 / math.pi;
  }

  GestureDirection? _detectDirection(Offset delta, double distance) {
    if (distance < AppConstants.minSwipeDistance * 0.3) {
      return null; // Too short to determine direction
    }

    final absX = delta.dx.abs();
    final absY = delta.dy.abs();
    
    // Use simple comparison instead of angle calculation for better performance
    if (absY > absX) {
      // Vertical gesture
      return delta.dy > 0 ? GestureDirection.down : GestureDirection.up;
    } else {
      // Horizontal gesture
      return delta.dx > 0 ? GestureDirection.right : GestureDirection.left;
    }
  }

  void _startDebounceTimer() {
    _cancelDebounceTimer();
    _debounceTimer = Timer(
      Duration(milliseconds: AppConstants.gestureDebounceMs),
      () => add(const GestureReset()),
    );
  }

  void _cancelDebounceTimer() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
  }

  @override
  Future<void> close() {
    _cancelDebounceTimer();
    return super.close();
  }
}