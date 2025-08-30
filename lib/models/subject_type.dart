import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/localization_service.dart';

enum SubjectType {
  math('Math', Icons.calculate, Color(0xFF4CAF50)),
  science('Science', Icons.science, Color(0xFF2196F3)),
  history('History', Icons.history_edu, Color(0xFFFF9800)),
  geography('Geography', Icons.public, Color(0xFF9C27B0));

  const SubjectType(this.displayName, this.icon, this.color);
  
  final String displayName;
  final IconData icon;
  final Color color;
  
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
    }
  }
  
  static List<SubjectType> get allSubjects => SubjectType.values;
}

enum GestureDirection {
  up(SubjectType.science),
  down(SubjectType.math),
  left(SubjectType.geography),
  right(SubjectType.history);

  const GestureDirection(this.subject);
  final SubjectType subject;
}