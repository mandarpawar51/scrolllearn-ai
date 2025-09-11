import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  // Convert to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'iconCodePoint': icon.codePoint,
      'colorValue': color.value,
    };
  }

  // Create from JSON
  factory SubjectType.fromJson(Map<String, dynamic> json) {
    return SubjectType(
      id: json['id'],
      displayName: json['displayName'],
      icon: IconData(json['iconCodePoint'], fontFamily: 'MaterialIcons'),
      color: Color(json['colorValue']),
    );
  }

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
  static bool _isLoaded = false;

  static List<SubjectType> get allSubjects => [math, science, history, geography, ..._userSubjects];
  static List<SubjectType> get values => [math, science, history, geography, none, ..._userSubjects];

  static Future<void> addSubject(SubjectType subject) async {
    _userSubjects.add(subject);
    await _saveUserSubjects();
  }

  static Future<void> loadUserSubjects() async {
    if (_isLoaded) return;
    
    final prefs = await SharedPreferences.getInstance();
    final subjectsJson = prefs.getString('user_subjects');
    
    if (subjectsJson != null) {
      final List<dynamic> subjectsList = jsonDecode(subjectsJson);
      _userSubjects = subjectsList.map((json) => SubjectType.fromJson(json)).toList();
    }
    
    _isLoaded = true;
  }

  static Future<void> _saveUserSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    final subjectsJson = jsonEncode(_userSubjects.map((s) => s.toJson()).toList());
    await prefs.setString('user_subjects', subjectsJson);
  }

  static Future<void> removeSubject(String subjectId) async {
    _userSubjects.removeWhere((s) => s.id == subjectId);
    await _saveUserSubjects();
  }
}

class GestureDirection {
  static final up = GestureDirection._('up', SubjectType.science);
  static final down = GestureDirection._('down', SubjectType.math);
  static final left = GestureDirection._('left', SubjectType.geography);
  static final right = GestureDirection._('right', SubjectType.history);

  static List<GestureDirection> get values => [up, down, left, right];

  String name;
  SubjectType subject;

  GestureDirection._(this.name, this.subject);
}