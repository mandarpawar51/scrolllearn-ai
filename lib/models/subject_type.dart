import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubjectType {
  final String displayName;
  final IconData icon;
  final Color color;
  final String id;

  const SubjectType({
    required this.id,
    required this.displayName,
    required this.icon,
    required this.color,
  });

  String getLocalizedName(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return displayName;

    switch (id) {
      case 'math':
        return localizations.math;
      case 'science':
        return localizations.science;
      case 'history':
        return localizations.history;
      case 'geography':
        return localizations.geography;
      default:
        return displayName;
    }
  }

  static final SubjectType math = SubjectType(id: 'math', displayName: 'Math', icon: Icons.calculate, color: Color(0xFF4CAF50));
  static final SubjectType science = SubjectType(id: 'science', displayName: 'Science', icon: Icons.science, color: Color(0xFF2196F3));
  static final SubjectType history = SubjectType(id: 'history', displayName: 'History', icon: Icons.history_edu, color: Color(0xFFFF9800));
  static final SubjectType geography = SubjectType(id: 'geography', displayName: 'Geography', icon: Icons.public, color: Color(0xFF9C27B0));
  static final SubjectType none = SubjectType(id: 'none', displayName: 'None', icon: Icons.help_outline, color: Color(0xFF757575));

  static List<SubjectType> _userSubjects = [];

  static List<SubjectType> get allSubjects => [math, science, history, geography, ..._userSubjects];
  static List<SubjectType> get values => [math, science, history, geography, none, ..._userSubjects];

  static void addSubject(SubjectType subject) {
    _userSubjects.add(subject);
  }
}

enum GestureDirection {
  up(SubjectType.science),
  down(SubjectType.math),
  left(SubjectType.geography),
  right(SubjectType.history);

  const GestureDirection(this.subject);
  final SubjectType subject;
}