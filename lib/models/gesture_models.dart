import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'subject_type.dart';

/// Represents the state of gesture recognition
enum GestureState {
  idle,
  detecting,
  recognized,
  invalid
}

/// Gesture recognition result
class GestureResult extends Equatable {
  final GestureDirection direction;
  final SubjectType subject;
  final double velocity;
  final double distance;

  const GestureResult({
    required this.direction,
    required this.subject,
    required this.velocity,
    required this.distance,
  });

  @override
  List<Object> get props => [direction, subject, velocity, distance];
}

/// Gesture detection data during pan updates
class GestureData extends Equatable {
  final Offset startPosition;
  final Offset currentPosition;
  final Offset delta;
  final double distance;
  final double angle;
  final GestureDirection? detectedDirection;

  const GestureData({
    required this.startPosition,
    required this.currentPosition,
    required this.delta,
    required this.distance,
    required this.angle,
    this.detectedDirection,
  });

  @override
  List<Object?> get props => [
    startPosition,
    currentPosition,
    delta,
    distance,
    angle,
    detectedDirection,
  ];
}