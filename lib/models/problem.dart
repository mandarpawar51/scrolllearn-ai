import 'subject_type.dart';

enum DifficultyLevel {
  beginner,
  intermediate,
  advanced,
}

class Problem {
  final String id;
  final SubjectType subject;
  final String question;
  final String? solution;
  final String? explanation;
  final DifficultyLevel difficulty;
  final DateTime createdAt;
  final List<String>? multipleChoiceOptions;
  final String? correctAnswer;

  Problem({
    required this.id,
    required this.subject,
    required this.question,
    this.solution,
    this.explanation,
    this.difficulty = DifficultyLevel.intermediate,
    DateTime? createdAt,
    this.multipleChoiceOptions,
    this.correctAnswer,
  }) : createdAt = createdAt ?? DateTime.now();

  // Create a problem from AI-generated text
  factory Problem.fromAIResponse({
    required String id,
    required SubjectType subject,
    required String aiResponse,
    DifficultyLevel difficulty = DifficultyLevel.intermediate,
  }) {
    // Parse the AI response to extract question and solution if available
    String question = aiResponse;
    String? solution;
    String? explanation;

    // Try to split by "Solution:" or "Answer:"
    final solutionMarkers = ['Solution:', 'Answer:', 'solution:', 'answer:'];
    
    for (String marker in solutionMarkers) {
      if (aiResponse.contains(marker)) {
        final parts = aiResponse.split(marker);
        if (parts.length >= 2) {
          question = parts[0].trim();
          solution = parts[1].trim();
          break;
        }
      }
    }

    // If no solution found, try splitting by line breaks and look for patterns
    if (solution == null) {
      final lines = aiResponse.split('\n');
      int solutionStartIndex = -1;
      
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].toLowerCase();
        if (line.contains('solution') || line.contains('answer') || line.contains('explanation')) {
          solutionStartIndex = i;
          break;
        }
      }
      
      if (solutionStartIndex != -1) {
        question = lines.sublist(0, solutionStartIndex).join('\n').trim();
        solution = lines.sublist(solutionStartIndex).join('\n').trim();
      }
    }

    return Problem(
      id: id,
      subject: subject,
      question: question.trim(),
      solution: solution?.trim(),
      explanation: explanation?.trim(),
      difficulty: difficulty,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject.name,
      'question': question,
      'solution': solution,
      'explanation': explanation,
      'difficulty': difficulty.name,
      'createdAt': createdAt.toIso8601String(),
      'multipleChoiceOptions': multipleChoiceOptions,
      'correctAnswer': correctAnswer,
    };
  }

  // Create from JSON
  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
      id: json['id'],
      subject: SubjectType.values.firstWhere(
        (e) => e.name == json['subject'],
        orElse: () => SubjectType.none,
      ),
      question: json['question'],
      solution: json['solution'],
      explanation: json['explanation'],
      difficulty: DifficultyLevel.values.firstWhere(
        (e) => e.name == json['difficulty'],
        orElse: () => DifficultyLevel.intermediate,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      multipleChoiceOptions: json['multipleChoiceOptions']?.cast<String>(),
      correctAnswer: json['correctAnswer'],
    );
  }

  // Create a copy with updated fields
  Problem copyWith({
    String? id,
    SubjectType? subject,
    String? question,
    String? solution,
    String? explanation,
    DifficultyLevel? difficulty,
    DateTime? createdAt,
    List<String>? multipleChoiceOptions,
    String? correctAnswer,
  }) {
    return Problem(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      question: question ?? this.question,
      solution: solution ?? this.solution,
      explanation: explanation ?? this.explanation,
      difficulty: difficulty ?? this.difficulty,
      createdAt: createdAt ?? this.createdAt,
      multipleChoiceOptions: multipleChoiceOptions ?? this.multipleChoiceOptions,
      correctAnswer: correctAnswer ?? this.correctAnswer,
    );
  }

  @override
  String toString() {
    return 'Problem(id: $id, subject: $subject, question: ${question.substring(0, question.length > 50 ? 50 : question.length)}...)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Problem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class ProblemAttempt {
  final String problemId;
  final String userAnswer;
  final bool isCorrect;
  final DateTime attemptedAt;
  final Duration timeSpent;

  ProblemAttempt({
    required this.problemId,
    required this.userAnswer,
    required this.isCorrect,
    DateTime? attemptedAt,
    Duration? timeSpent,
  }) : attemptedAt = attemptedAt ?? DateTime.now(),
       timeSpent = timeSpent ?? Duration.zero;

  Map<String, dynamic> toJson() {
    return {
      'problemId': problemId,
      'userAnswer': userAnswer,
      'isCorrect': isCorrect,
      'attemptedAt': attemptedAt.toIso8601String(),
      'timeSpent': timeSpent.inMilliseconds,
    };
  }

  factory ProblemAttempt.fromJson(Map<String, dynamic> json) {
    return ProblemAttempt(
      problemId: json['problemId'],
      userAnswer: json['userAnswer'],
      isCorrect: json['isCorrect'],
      attemptedAt: DateTime.parse(json['attemptedAt']),
      timeSpent: Duration(milliseconds: json['timeSpent']),
    );
  }
}