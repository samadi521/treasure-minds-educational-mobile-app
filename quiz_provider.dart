import 'dart:math';
import 'package:flutter/material.dart';
import '../config/app_constants.dart';

class QuizProvider extends ChangeNotifier {
  final Random _random = Random();
  
  // Question banks by subject and difficulty
  final Map<String, List<Map<String, dynamic>>> _questionBanks = {
    'math_easy': [],
    'math_medium': [],
    'math_hard': [],
    'english_easy': [],
    'english_medium': [],
    'english_hard': [],
    'science_easy': [],
    'science_medium': [],
    'science_hard': [],
  };
  
  // Current quiz state
  List<Map<String, dynamic>> _currentQuestions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _lives = AppConstants.maxLives;
  int _combo = 0;
  int _multiplier = 1;
  bool _isQuizActive = false;
  String _currentSubject = '';
  String _currentDifficulty = '';
  
  // Statistics
  int _totalQuestionsAnswered = 0;
  int _correctAnswers = 0;
  int _totalTimeSpent = 0;
  
  // Getter methods
  List<Map<String, dynamic>> get currentQuestions => _currentQuestions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  int get lives => _lives;
  int get combo => _combo;
  int get multiplier => _multiplier;
  bool get isQuizActive => _isQuizActive;
  String get currentSubject => _currentSubject;
  String get currentDifficulty => _currentDifficulty;
  int get totalQuestionsAnswered => _totalQuestionsAnswered;
  int get correctAnswers => _correctAnswers;
  double get accuracy => _totalQuestionsAnswered > 0 
      ? (_correctAnswers / _totalQuestionsAnswered) * 100 
      : 0;
  int get totalTimeSpent => _totalTimeSpent;
  Map<String, dynamic>? get currentQuestion => 
      _currentQuestionIndex < _currentQuestions.length 
          ? _currentQuestions[_currentQuestionIndex] 
          : null;
  
  // Constructor
  QuizProvider() {
    _initializeQuestionBanks();
  }
  
  // Initialize all question banks
  void _initializeQuestionBanks() {
    // Math Easy Questions (Ages 6-8)
    _questionBanks['math_easy'] = [
      {'text': '2 + 2 = ?', 'options': ['3', '4', '5', '6'], 'answer': 1, 'points': 10, 'type': 'Addition'},
      {'text': '5 - 3 = ?', 'options': ['1', '2', '3', '4'], 'answer': 1, 'points': 10, 'type': 'Subtraction'},
      {'text': '3 × 2 = ?', 'options': ['4', '5', '6', '7'], 'answer': 2, 'points': 10, 'type': 'Multiplication'},
      {'text': '8 ÷ 2 = ?', 'options': ['2', '3', '4', '5'], 'answer': 2, 'points': 10, 'type': 'Division'},
      {'text': 'What is 10 + 7?', 'options': ['15', '16', '17', '18'], 'answer': 2, 'points': 10, 'type': 'Addition'},
      {'text': '9 - 4 = ?', 'options': ['4', '5', '6', '7'], 'answer': 1, 'points': 10, 'type': 'Subtraction'},
      {'text': '4 × 3 = ?', 'options': ['10', '11', '12', '13'], 'answer': 2, 'points': 10, 'type': 'Multiplication'},
      {'text': '15 ÷ 3 = ?', 'options': ['3', '4', '5', '6'], 'answer': 2, 'points': 10, 'type': 'Division'},
    ];
    
    // Math Medium Questions (Ages 9-11)
    _questionBanks['math_medium'] = [
      {'text': '15 + 27 = ?', 'options': ['40', '41', '42', '43'], 'answer': 2, 'points': 15, 'type': 'Addition'},
      {'text': '84 - 39 = ?', 'options': ['44', '45', '46', '47'], 'answer': 1, 'points': 15, 'type': 'Subtraction'},
      {'text': '12 × 8 = ?', 'options': ['86', '96', '106', '88'], 'answer': 1, 'points': 15, 'type': 'Multiplication'},
      {'text': '144 ÷ 12 = ?', 'options': ['10', '11', '12', '13'], 'answer': 2, 'points': 15, 'type': 'Division'},
      {'text': 'What is 25% of 80?', 'options': ['15', '20', '25', '30'], 'answer': 1, 'points': 15, 'type': 'Percentage'},
      {'text': '3/4 + 1/4 = ?', 'options': ['1/2', '3/4', '1', '1 1/4'], 'answer': 2, 'points': 15, 'type': 'Fractions'},
    ];
    
    // Math Hard Questions (Ages 12-16) - Includes Algebra
    _questionBanks['math_hard'] = [
      {'text': 'Solve: x + 7 = 15', 'options': ['6', '7', '8', '9'], 'answer': 2, 'points': 20, 'type': 'Algebra'},
      {'text': 'If 3x = 24, what is x?', 'options': ['6', '7', '8', '9'], 'answer': 2, 'points': 20, 'type': 'Algebra'},
      {'text': 'Solve: 2x + 5 = 15', 'options': ['3', '4', '5', '6'], 'answer': 2, 'points': 20, 'type': 'Algebra'},
      {'text': 'What is the area of a circle with radius 5?', 'options': ['25π', '10π', '20π', '15π'], 'answer': 0, 'points': 20, 'type': 'Geometry'},
      {'text': 'Simplify: (x²)(x³)', 'options': ['x⁵', 'x⁶', '2x⁵', 'x⁸'], 'answer': 0, 'points': 20, 'type': 'Algebra'},
      {'text': 'What is the square root of 144?', 'options': ['10', '11', '12', '13'], 'answer': 2, 'points': 20, 'type': 'Algebra'},
      {'text': 'Solve: 5x - 3 = 2x + 12', 'options': ['3', '4', '5', '6'], 'answer': 2, 'points': 25, 'type': 'Algebra'},
      {'text': 'What is the value of π?', 'options': ['3.12', '3.14', '3.16', '3.18'], 'answer': 1, 'points': 20, 'type': 'Geometry'},
    ];
    
    // English Easy Questions (Ages 6-8)
    _questionBanks['english_easy'] = [
      {'text': 'What is the opposite of "hot"?', 'options': ['Warm', 'Cold', 'Cool', 'Fire'], 'answer': 1, 'points': 10, 'type': 'Antonyms'},
      {'text': 'What is the synonym of "big"?', 'options': ['Small', 'Tiny', 'Large', 'Little'], 'answer': 2, 'points': 10, 'type': 'Synonyms'},
      {'text': 'She ___ to school every day.', 'options': ['go', 'goes', 'going', 'went'], 'answer': 1, 'points': 10, 'type': 'Grammar'},
      {'text': 'What is the plural of "cat"?', 'options': ['cat\'s', 'cats', 'cates', 'caties'], 'answer': 1, 'points': 10, 'type': 'Plurals'},
      {'text': 'The ___ is shining in the sky.', 'options': ['Moon', 'Stars', 'Sun', 'Clouds'], 'answer': 2, 'points': 10, 'type': 'Vocabulary'},
      {'text': 'I ___ a student.', 'options': ['is', 'am', 'are', 'be'], 'answer': 1, 'points': 10, 'type': 'Grammar'},
    ];
    
    // English Medium Questions (Ages 9-11)
    _questionBanks['english_medium'] = [
      {'text': 'What is the past tense of "run"?', 'options': ['Ran', 'Runned', 'Running', 'Runs'], 'answer': 0, 'points': 15, 'type': 'Grammar'},
      {'text': 'What does "brave" mean?', 'options': ['Scared', 'Courageous', 'Weak', 'Sad'], 'answer': 1, 'points': 15, 'type': 'Vocabulary'},
      {'text': 'Choose the correct spelling:', 'options': ['Recieve', 'Receive', 'Recive', 'Receeve'], 'answer': 1, 'points': 15, 'type': 'Spelling'},
      {'text': 'What is an adjective?', 'options': ['Action word', 'Describing word', 'Person/place/thing', 'Connecting word'], 'answer': 1, 'points': 15, 'type': 'Grammar'},
      {'text': 'What is the synonym of "happy"?', 'options': ['Sad', 'Joyful', 'Angry', 'Tired'], 'answer': 1, 'points': 15, 'type': 'Synonyms'},
    ];
    
    // English Hard Questions (Ages 12-16)
    _questionBanks['english_hard'] = [
      {'text': 'What does "benevolent" mean?', 'options': ['Evil', 'Kind', 'Angry', 'Lazy'], 'answer': 1, 'points': 20, 'type': 'Vocabulary'},
      {'text': 'Identify the correct sentence:', 'options': ['Neither of them are coming', 'Neither of them is coming', 'Neither of them be coming', 'Neither of them am coming'], 'answer': 1, 'points': 20, 'type': 'Grammar'},
      {'text': 'What is an idiom?', 'options': ['A type of poem', 'A figure of speech', 'A grammar rule', 'A punctuation mark'], 'answer': 1, 'points': 20, 'type': 'Idioms'},
      {'text': 'What does "break the ice" mean?', 'options': ['Break something frozen', 'Start a conversation', 'Get angry', 'Leave quickly'], 'answer': 1, 'points': 20, 'type': 'Idioms'},
      {'text': 'What is a metaphor?', 'options': ['A comparison using like/as', 'A direct comparison', 'An exaggeration', 'A sound word'], 'answer': 1, 'points': 20, 'type': 'Literature'},
    ];
    
    // Science Easy Questions (Ages 6-8)
    _questionBanks['science_easy'] = [
      {'text': 'What is the closest star to Earth?', 'options': ['Moon', 'Sun', 'Mars', 'Venus'], 'answer': 1, 'points': 10, 'type': 'Astronomy'},
      {'text': 'What gas do humans breathe in?', 'options': ['CO2', 'O2', 'N2', 'H2'], 'answer': 1, 'points': 10, 'type': 'Biology'},
      {'text': 'What is H2O?', 'options': ['Salt', 'Water', 'Oxygen', 'Hydrogen'], 'answer': 1, 'points': 10, 'type': 'Chemistry'},
      {'text': 'What is the hardest natural substance?', 'options': ['Iron', 'Gold', 'Diamond', 'Platinum'], 'answer': 2, 'points': 10, 'type': 'Geology'},
      {'text': 'What planet is known as the Red Planet?', 'options': ['Venus', 'Mars', 'Jupiter', 'Saturn'], 'answer': 1, 'points': 10, 'type': 'Astronomy'},
    ];
    
    // Science Medium Questions (Ages 9-11)
    _questionBanks['science_medium'] = [
      {'text': 'What is the process of plants making food called?', 'options': ['Respiration', 'Photosynthesis', 'Digestion', 'Evaporation'], 'answer': 1, 'points': 15, 'type': 'Biology'},
      {'text': 'What is the largest organ in the human body?', 'options': ['Heart', 'Brain', 'Liver', 'Skin'], 'answer': 3, 'points': 15, 'type': 'Biology'},
      {'text': 'What is the boiling point of water?', 'options': ['0°C', '50°C', '100°C', '212°C'], 'answer': 2, 'points': 15, 'type': 'Chemistry'},
      {'text': 'What force pulls objects toward Earth?', 'options': ['Magnetism', 'Friction', 'Gravity', 'Electricity'], 'answer': 2, 'points': 15, 'type': 'Physics'},
      {'text': 'What is the fastest animal on land?', 'options': ['Lion', 'Cheetah', 'Leopard', 'Horse'], 'answer': 1, 'points': 15, 'type': 'Biology'},
    ];
    
    // Science Hard Questions (Ages 12-16)
    _questionBanks['science_hard'] = [
      {'text': 'What is the powerhouse of the cell?', 'options': ['Nucleus', 'Mitochondria', 'Ribosome', 'Chloroplast'], 'answer': 1, 'points': 20, 'type': 'Biology'},
      {'text': 'What is the chemical symbol for Gold?', 'options': ['Go', 'Gd', 'Au', 'Ag'], 'answer': 2, 'points': 20, 'type': 'Chemistry'},
      {'text': 'What is Newton\'s first law also known as?', 'options': ['Law of Acceleration', 'Law of Inertia', 'Law of Action-Reaction', 'Law of Gravity'], 'answer': 1, 'points': 20, 'type': 'Physics'},
      {'text': 'What is the pH of pure water?', 'options': ['5', '6', '7', '8'], 'answer': 2, 'points': 20, 'type': 'Chemistry'},
      {'text': 'What is DNA short for?', 'options': ['Deoxyribonucleic Acid', 'Ribonucleic Acid', 'Deoxynucleic Acid', 'Ribonuclear Acid'], 'answer': 0, 'points': 20, 'type': 'Biology'},
    ];
  }
  
  // Generate math questions based on age
  List<Map<String, dynamic>> generateMathQuestions(int count, int userAge) {
    String difficulty;
    if (userAge <= 8) {
      difficulty = 'easy';
    } else if (userAge <= 11) {
      difficulty = 'medium';
    } else {
      difficulty = 'hard';
    }
    
    return _generateQuestionsFromBank('math_$difficulty', count);
  }
  
  // Generate English questions based on age
  List<Map<String, dynamic>> generateEnglishQuestions(int count, int userAge) {
    String difficulty;
    if (userAge <= 8) {
      difficulty = 'easy';
    } else if (userAge <= 11) {
      difficulty = 'medium';
    } else {
      difficulty = 'hard';
    }
    
    return _generateQuestionsFromBank('english_$difficulty', count);
  }
  
  // Generate Science questions based on age
  List<Map<String, dynamic>> generateScienceQuestions(int count, int userAge) {
    String difficulty;
    if (userAge <= 8) {
      difficulty = 'easy';
    } else if (userAge <= 11) {
      difficulty = 'medium';
    } else {
      difficulty = 'hard';
    }
    
    return _generateQuestionsFromBank('science_$difficulty', count);
  }
  
  // Generate questions from specific bank
  List<Map<String, dynamic>> _generateQuestionsFromBank(String bankKey, int count) {
    final bank = _questionBanks[bankKey] ?? [];
    if (bank.isEmpty) return [];
    
    final shuffled = List<Map<String, dynamic>>.from(bank);
    shuffled.shuffle(_random);
    
    return shuffled.take(count).toList();
  }
  
  // Start a new quiz
  void startQuiz(String subject, int questionCount, int userAge) {
    _currentSubject = subject;
    
    switch (subject) {
      case 'Math':
        _currentQuestions = generateMathQuestions(questionCount, userAge);
        break;
      case 'English':
        _currentQuestions = generateEnglishQuestions(questionCount, userAge);
        break;
      case 'Science':
        _currentQuestions = generateScienceQuestions(questionCount, userAge);
        break;
      default:
        _currentQuestions = [];
    }
    
    _currentQuestionIndex = 0;
    _score = 0;
    _lives = AppConstants.maxLives;
    _combo = 0;
    _multiplier = 1;
    _isQuizActive = true;
    
    notifyListeners();
  }
  
  // Check answer and update score
  bool checkAnswer(int selectedIndex) {
    if (!_isQuizActive) return false;
    if (currentQuestion == null) return false;
    
    final isCorrect = selectedIndex == currentQuestion!['answer'];
    final points = currentQuestion!['points'] as int;
    
    if (isCorrect) {
      // Add points with multiplier
      final earnedPoints = points * _multiplier;
      _score += earnedPoints;
      _correctAnswers++;
      
      // Update combo and multiplier
      _combo++;
      _multiplier = 1 + (_combo ~/ 3);
    } else {
      // Wrong answer - lose a life and reset combo
      _lives--;
      _combo = 0;
      _multiplier = 1;
    }
    
    _totalQuestionsAnswered++;
    
    notifyListeners();
    return isCorrect;
  }
  
  // Move to next question
  bool nextQuestion() {
    if (_currentQuestionIndex + 1 < _currentQuestions.length) {
      _currentQuestionIndex++;
      notifyListeners();
      return true;
    } else {
      _isQuizActive = false;
      notifyListeners();
      return false;
    }
  }
  
  // Check if quiz is completed
  bool isQuizCompleted() {
    return _currentQuestionIndex >= _currentQuestions.length - 1;
  }
  
  // Check if game over (no lives left)
  bool isGameOver() {
    return _lives <= 0;
  }
  
  // Reset quiz state
  void resetQuiz() {
    _currentQuestions = [];
    _currentQuestionIndex = 0;
    _score = 0;
    _lives = AppConstants.maxLives;
    _combo = 0;
    _multiplier = 1;
    _isQuizActive = false;
    _totalQuestionsAnswered = 0;
    _correctAnswers = 0;
    
    notifyListeners();
  }
  
  // Get random question from any subject
  Map<String, dynamic> getRandomQuestion() {
    final subjects = ['math_medium', 'english_medium', 'science_medium'];
    final randomSubject = subjects[_random.nextInt(subjects.length)];
    final bank = _questionBanks[randomSubject] ?? [];
    
    if (bank.isNotEmpty) {
      return bank[_random.nextInt(bank.length)];
    }
    
    return {
      'text': '2 + 2 = ?',
      'options': ['3', '4', '5', '6'],
      'answer': 1,
      'points': 10,
      'type': 'Arithmetic',
    };
  }
  
  // Get questions for timer challenge
  List<Map<String, dynamic>> getTimerChallengeQuestions(int count) {
    final allQuestions = <Map<String, dynamic>>[];
    
    // Mix questions from all subjects
    allQuestions.addAll(_questionBanks['math_medium'] ?? []);
    allQuestions.addAll(_questionBanks['english_medium'] ?? []);
    allQuestions.addAll(_questionBanks['science_medium'] ?? []);
    
    allQuestions.shuffle(_random);
    return allQuestions.take(count).toList();
  }
  
  // Get hint for current question
  String? getHintForCurrentQuestion() {
    if (currentQuestion == null) return null;
    
    final questionText = currentQuestion!['text'];
    final options = currentQuestion!['options'] as List<String>;
    final correctAnswer = options[currentQuestion!['answer']];
    
    return 'The correct answer is related to "${correctAnswer.substring(0, correctAnswer.length ~/ 3)}..."';
  }
  
  // Record time spent on question
  void recordTimeSpent(int seconds) {
    _totalTimeSpent += seconds;
    notifyListeners();
  }
  
  // Get average time per question
  double getAverageTimePerQuestion() {
    if (_totalQuestionsAnswered == 0) return 0;
    return _totalTimeSpent / _totalQuestionsAnswered;
  }
  
  // Get performance summary
  Map<String, dynamic> getPerformanceSummary() {
    return {
      'score': _score,
      'accuracy': accuracy,
      'questionsAnswered': _totalQuestionsAnswered,
      'correctAnswers': _correctAnswers,
      'maxCombo': _combo,
      'maxMultiplier': _multiplier,
      'averageTime': getAverageTimePerQuestion(),
      'livesRemaining': _lives,
    };
  }
}