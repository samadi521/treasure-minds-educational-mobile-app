import 'package:flutter/material.dart';
import '../config/theme.dart';

class QuestionModel {
  final String id;
  final String text;
  final List<String> options;
  final int answerIndex;
  final int points;
  final String subject;
  final String difficulty;
  final String type;
  final String? explanation;
  final String? imageUrl;
  final List<String>? tags;
  final int timeLimit;
  final int timesAnswered;
  final int timesCorrect;
  final double averageTime;

  QuestionModel({
    required this.id,
    required this.text,
    required this.options,
    required this.answerIndex,
    required this.points,
    required this.subject,
    required this.difficulty,
    required this.type,
    this.explanation,
    this.imageUrl,
    this.tags,
    this.timeLimit = 30,
    this.timesAnswered = 0,
    this.timesCorrect = 0,
    this.averageTime = 0,
  });

  // Create from JSON
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String? ?? '',
      text: json['text'] as String? ?? '',
      options: List<String>.from(json['options'] as List? ?? []),
      answerIndex: json['answerIndex'] as int? ?? 0,
      points: json['points'] as int? ?? 10,
      subject: json['subject'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? 'Medium',
      type: json['type'] as String? ?? 'Multiple Choice',
      explanation: json['explanation'] as String?,
      imageUrl: json['imageUrl'] as String?,
      tags: json['tags'] != null ? List<String>.from(json['tags'] as List) : null,
      timeLimit: json['timeLimit'] as int? ?? 30,
      timesAnswered: json['timesAnswered'] as int? ?? 0,
      timesCorrect: json['timesCorrect'] as int? ?? 0,
      averageTime: json['averageTime'] as double? ?? 0,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'options': options,
      'answerIndex': answerIndex,
      'points': points,
      'subject': subject,
      'difficulty': difficulty,
      'type': type,
      'explanation': explanation,
      'imageUrl': imageUrl,
      'tags': tags,
      'timeLimit': timeLimit,
      'timesAnswered': timesAnswered,
      'timesCorrect': timesCorrect,
      'averageTime': averageTime,
    };
  }

  // Copy with modifications
  QuestionModel copyWith({
    String? id,
    String? text,
    List<String>? options,
    int? answerIndex,
    int? points,
    String? subject,
    String? difficulty,
    String? type,
    String? explanation,
    String? imageUrl,
    List<String>? tags,
    int? timeLimit,
    int? timesAnswered,
    int? timesCorrect,
    double? averageTime,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      text: text ?? this.text,
      options: options ?? this.options,
      answerIndex: answerIndex ?? this.answerIndex,
      points: points ?? this.points,
      subject: subject ?? this.subject,
      difficulty: difficulty ?? this.difficulty,
      type: type ?? this.type,
      explanation: explanation ?? this.explanation,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      timeLimit: timeLimit ?? this.timeLimit,
      timesAnswered: timesAnswered ?? this.timesAnswered,
      timesCorrect: timesCorrect ?? this.timesCorrect,
      averageTime: averageTime ?? this.averageTime,
    );
  }

  // Computed properties
  String get correctAnswer => options[answerIndex];
  
  double get successRate => timesAnswered > 0 ? (timesCorrect / timesAnswered) * 100 : 0;
  
  String get successRateLabel => '${successRate.toStringAsFixed(1)}%';
  
  Color get difficultyColor {
    switch (difficulty.toLowerCase()) {
      case 'easy': return AppColors.mintGreen;
      case 'medium': return AppColors.warningOrange;
      case 'hard': return AppColors.mathOrange;
      case 'expert': return AppColors.neonPurple;
      default: return AppColors.neonBlue;
    }
  }
  
  IconData get difficultyIcon {
    switch (difficulty.toLowerCase()) {
      case 'easy': return Icons.sentiment_satisfied;
      case 'medium': return Icons.sentiment_neutral;
      case 'hard': return Icons.sentiment_very_dissatisfied;
      case 'expert': return Icons.psychology;
      default: return Icons.help;
    }
  }
  
  Color get subjectColor {
    switch (subject.toLowerCase()) {
      case 'math': return AppColors.mathOrange;
      case 'english': return AppColors.englishGreen;
      case 'science': return AppColors.sciencePurple;
      default: return AppColors.neonBlue;
    }
  }
  
  IconData get subjectIcon {
    switch (subject.toLowerCase()) {
      case 'math': return Icons.calculate;
      case 'english': return Icons.menu_book;
      case 'science': return Icons.science;
      default: return Icons.quiz;
    }
  }

  // Methods
  bool isCorrect(int selectedIndex) => selectedIndex == answerIndex;
  
  QuestionModel recordAnswer(bool isCorrect, int timeSpent) {
    final newTimesAnswered = timesAnswered + 1;
    final newTimesCorrect = timesCorrect + (isCorrect ? 1 : 0);
    final newAverageTime = (averageTime * timesAnswered + timeSpent) / newTimesAnswered;
    
    return copyWith(
      timesAnswered: newTimesAnswered,
      timesCorrect: newTimesCorrect,
      averageTime: newAverageTime,
    );
  }
  
  List<String> getShuffledOptions() {
    final shuffled = List<String>.from(options);
    shuffled.shuffle();
    return shuffled;
  }
}

// Question bank model
class QuestionBank {
  final String id;
  final String name;
  final String subject;
  final String difficulty;
  final List<QuestionModel> questions;
  final int? timeLimit;

  QuestionBank({
    required this.id,
    required this.name,
    required this.subject,
    required this.difficulty,
    required this.questions,
    this.timeLimit,
  });

  factory QuestionBank.fromJson(Map<String, dynamic> json) {
    return QuestionBank(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? 'Medium',
      questions: (json['questions'] as List?)
          ?.map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
          .toList() ?? [],
      timeLimit: json['timeLimit'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subject': subject,
      'difficulty': difficulty,
      'questions': questions.map((q) => q.toJson()).toList(),
      'timeLimit': timeLimit,
    };
  }

  int get questionCount => questions.length;
  
  List<QuestionModel> getRandomQuestions(int count) {
    final shuffled = List<QuestionModel>.from(questions);
    shuffled.shuffle();
    return shuffled.take(count.clamp(0, questions.length)).toList();
  }
  
  List<QuestionModel> getQuestionsByType(String type) {
    return questions.where((q) => q.type == type).toList();
  }
}

// Quiz session model
class QuizSession {
  final String id;
  final List<QuestionModel> questions;
  final DateTime startTime;
  final String subject;
  final String difficulty;
  int currentIndex;
  List<int?> userAnswers;
  List<int> timeSpent;
  bool isCompleted;

  QuizSession({
    required this.id,
    required this.questions,
    required this.startTime,
    required this.subject,
    required this.difficulty,
    this.currentIndex = 0,
    List<int?>? userAnswers,
    List<int>? timeSpent,
    this.isCompleted = false,
  }) : userAnswers = userAnswers ?? List.filled(questions.length, null),
       timeSpent = timeSpent ?? List.filled(questions.length, 0);

  factory QuizSession.fromJson(Map<String, dynamic> json) {
    return QuizSession(
      id: json['id'] as String? ?? '',
      questions: (json['questions'] as List?)
          ?.map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
          .toList() ?? [],
      startTime: DateTime.parse(json['startTime'] as String? ?? DateTime.now().toIso8601String()),
      subject: json['subject'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? 'Medium',
      currentIndex: json['currentIndex'] as int? ?? 0,
      userAnswers: json['userAnswers'] != null 
          ? List<int?>.from(json['userAnswers'] as List) 
          : null,
      timeSpent: json['timeSpent'] != null 
          ? List<int>.from(json['timeSpent'] as List) 
          : null,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questions': questions.map((q) => q.toJson()).toList(),
      'startTime': startTime.toIso8601String(),
      'subject': subject,
      'difficulty': difficulty,
      'currentIndex': currentIndex,
      'userAnswers': userAnswers,
      'timeSpent': timeSpent,
      'isCompleted': isCompleted,
    };
  }

  // Computed properties
  int get totalQuestions => questions.length;
  
  int get answeredCount => userAnswers.where((a) => a != null).length;
  
  int get correctCount {
    int correct = 0;
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] != null && questions[i].isCorrect(userAnswers[i]!)) {
        correct++;
      }
    }
    return correct;
  }
  
  int get score {
    int total = 0;
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] != null && questions[i].isCorrect(userAnswers[i]!)) {
        total += questions[i].points;
      }
    }
    return total;
  }
  
  double get accuracy => totalQuestions > 0 ? (correctCount / totalQuestions) * 100 : 0;
  
  int get totalTimeSpent => timeSpent.reduce((a, b) => a + b);
  
  double get averageTimePerQuestion => totalQuestions > 0 ? totalTimeSpent / totalQuestions : 0;
  
  QuestionModel get currentQuestion => questions[currentIndex];
  
  bool get hasNextQuestion => currentIndex < totalQuestions - 1;
  
  bool get isLastQuestion => currentIndex == totalQuestions - 1;

  // Methods
  QuizSession recordAnswer(int answerIndex, int timeSeconds) {
    final newUserAnswers = List<int?>.from(userAnswers);
    final newTimeSpent = List<int>.from(timeSpent);
    
    newUserAnswers[currentIndex] = answerIndex;
    newTimeSpent[currentIndex] = timeSeconds;
    
    return QuizSession(
      id: id,
      questions: questions,
      startTime: startTime,
      subject: subject,
      difficulty: difficulty,
      currentIndex: currentIndex,
      userAnswers: newUserAnswers,
      timeSpent: newTimeSpent,
      isCompleted: isCompleted,
    );
  }
  
  QuizSession nextQuestion() {
    if (!hasNextQuestion) return this;
    
    return QuizSession(
      id: id,
      questions: questions,
      startTime: startTime,
      subject: subject,
      difficulty: difficulty,
      currentIndex: currentIndex + 1,
      userAnswers: userAnswers,
      timeSpent: timeSpent,
      isCompleted: isCompleted,
    );
  }
  
  QuizSession complete() {
    return QuizSession(
      id: id,
      questions: questions,
      startTime: startTime,
      subject: subject,
      difficulty: difficulty,
      currentIndex: currentIndex,
      userAnswers: userAnswers,
      timeSpent: timeSpent,
      isCompleted: true,
    );
  }
  
  QuizSession reset() {
    return QuizSession(
      id: id,
      questions: questions,
      startTime: DateTime.now(),
      subject: subject,
      difficulty: difficulty,
      currentIndex: 0,
      userAnswers: List.filled(questions.length, null),
      timeSpent: List.filled(questions.length, 0),
      isCompleted: false,
    );
  }
  
  Map<String, dynamic> getResults() {
    return {
      'totalQuestions': totalQuestions,
      'answeredCount': answeredCount,
      'correctCount': correctCount,
      'score': score,
      'accuracy': accuracy,
      'totalTimeSpent': totalTimeSpent,
      'averageTimePerQuestion': averageTimePerQuestion,
      'completed': isCompleted,
    };
  }
}

// Question filter
class QuestionFilter {
  String? subject;
  String? difficulty;
  String? type;
  List<String>? tags;
  int? minPoints;
  int? maxPoints;
  bool? hasImage;
  bool? hasExplanation;

  QuestionFilter({
    this.subject,
    this.difficulty,
    this.type,
    this.tags,
    this.minPoints,
    this.maxPoints,
    this.hasImage,
    this.hasExplanation,
  });

  bool matches(QuestionModel question) {
    if (subject != null && question.subject != subject) return false;
    if (difficulty != null && question.difficulty != difficulty) return false;
    if (type != null && question.type != type) return false;
    if (tags != null && !tags!.any((t) => question.tags?.contains(t) ?? false)) return false;
    if (minPoints != null && question.points < minPoints!) return false;
    if (maxPoints != null && question.points > maxPoints!) return false;
    if (hasImage != null && (question.imageUrl != null) != hasImage) return false;
    if (hasExplanation != null && (question.explanation != null) != hasExplanation) return false;
    return true;
  }

  QuestionFilter copyWith({
    String? subject,
    String? difficulty,
    String? type,
    List<String>? tags,
    int? minPoints,
    int? maxPoints,
    bool? hasImage,
    bool? hasExplanation,
  }) {
    return QuestionFilter(
      subject: subject ?? this.subject,
      difficulty: difficulty ?? this.difficulty,
      type: type ?? this.type,
      tags: tags ?? this.tags,
      minPoints: minPoints ?? this.minPoints,
      maxPoints: maxPoints ?? this.maxPoints,
      hasImage: hasImage ?? this.hasImage,
      hasExplanation: hasExplanation ?? this.hasExplanation,
    );
  }
}