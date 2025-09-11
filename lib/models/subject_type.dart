import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum SubjectType {
  math,
  science,
  history,
  geography,
  none;

  String get displayName {
    switch (this) {
      case SubjectType.math:
        return 'Math';
      case SubjectType.science:
        return 'Science';
      case SubjectType.history:
        return 'History';
      case SubjectType.geography:
        return 'Geography';
      case SubjectType.none:
        return 'None';
    }
  }

  IconData get icon {
    switch (this) {
      case SubjectType.math:
        return Icons.calculate;
      case SubjectType.science:
        return Icons.science;
      case SubjectType.history:
        return Icons.history_edu;
      case SubjectType.geography:
        return Icons.public;
      case SubjectType.none:
        return Icons.help_outline;
    }
  }

  Color get color {
    switch (this) {
      case SubjectType.math:
        return const Color(0xFF4CAF50);
      case SubjectType.science:
        return const Color(0xFF2196F3);
      case SubjectType.history:
        return const Color(0xFFFF9800);
      case SubjectType.geography:
        return const Color(0xFF9C27B0);
      case SubjectType.none:
        return const Color(0xFF757575);
    }
  }

  String get id => toString().split('.').last;

  String getLocalizedName(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return displayName;

    switch (this) {
      case SubjectType.math:
        return localizations.math;
      case SubjectType.science:
        return localizations.science;
      case SubjectType.history:
        return localizations.history;
      case SubjectType.geography:
        return localizations.geography;
      case SubjectType.none:
        return displayName;
    }
  }

  static List<SubjectType> get allSubjects => [math, science, history, geography];
}

enum GestureDirection {
  up,
  down,
  left,
  right;

  SubjectType get subject {
    switch (this) {
      case GestureDirection.up:
        return SubjectType.science;
      case GestureDirection.down:
        return SubjectType.math;
      case GestureDirection.left:
        return SubjectType.geography;
      case GestureDirection.right:
        return SubjectType.history;
    }
  }
}