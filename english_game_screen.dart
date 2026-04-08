import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/question_card.dart';
import '../../widgets/answer_button.dart';
import '../../widgets/timer_widget.dart';
import 'game_result_screen.dart';

class EnglishGameScreen extends StatefulWidget {
  final int gradeLevel;
  final int level;
  
  const EnglishGameScreen({
    super.key,
    this.gradeLevel = 3,
    this.level = 1,
  });

  @override
  State<EnglishGameScreen> createState() => _EnglishGameScreenState();
}

class _EnglishGameScreenState extends State<EnglishGameScreen> with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _bounceController;
  late AnimationController _shakeController;
  
  int _currentIndex = 0;
  int _score = 0;
  int _lives = 3;
  int _multiplier = 1;
  int _combo = 0;
  int? _selectedAnswer;
  bool _showResult = false;
  bool _isGameOver = false;
  int _questionsAnswered = 0;
  bool _isCorrectAnswer = false;
  
  // Timer variables
  int _timeRemaining = 30;
  bool _timerActive = true;
  
  List<Map<String, dynamic>> _questions = [];
  final Random _random = Random();
  
  // English question categories with extensive questions
  
  // Vocabulary Questions (Ages 6-11)
  final List<Map<String, dynamic>> _vocabQuestionsEasy = [
    {'text': 'What is the meaning of "enormous"?', 'options': ['Small', 'Huge', 'Fast', 'Bright'], 'answer': 1, 'points': 10, 'category': 'Vocabulary', 'difficulty': 'Easy'},
    {'text': 'What is the synonym of "quick"?', 'options': ['Slow', 'Fast', 'Large', 'Small'], 'answer': 1, 'points': 10, 'category': 'Vocabulary', 'difficulty': 'Easy'},
    {'text': 'What is the antonym of "dark"?', 'options': ['Night', 'Light', 'Black', 'Shadow'], 'answer': 1, 'points': 10, 'category': 'Vocabulary', 'difficulty': 'Easy'},
    {'text': 'What does "brave" mean?', 'options': ['Scared', 'Courageous', 'Weak', 'Sad'], 'answer': 1, 'points': 10, 'category': 'Vocabulary', 'difficulty': 'Easy'},
    {'text': 'What is the meaning of "ancient"?', 'options': ['New', 'Modern', 'Very old', 'Future'], 'answer': 2, 'points': 10, 'category': 'Vocabulary', 'difficulty': 'Easy'},
    {'text': 'What does "joyful" mean?', 'options': ['Sad', 'Happy', 'Angry', 'Tired'], 'answer': 1, 'points': 10, 'category': 'Vocabulary', 'difficulty': 'Easy'},
    {'text': 'What is the synonym of "big"?', 'options': ['Tiny', 'Small', 'Large', 'Little'], 'answer': 2, 'points': 10, 'category': 'Vocabulary', 'difficulty': 'Easy'},
    {'text': 'What is the antonym of "hot"?', 'options': ['Warm', 'Cold', 'Cool', 'Fire'], 'answer': 1, 'points': 10, 'category': 'Vocabulary', 'difficulty': 'Easy'},
    {'text': 'What does "fragile" mean?', 'options': ['Strong', 'Breakable', 'Heavy', 'Light'], 'answer': 1, 'points': 10, 'category': 'Vocabulary', 'difficulty': 'Easy'},
    {'text': 'What is the meaning of "gigantic"?', 'options': ['Tiny', 'Huge', 'Fast', 'Slow'], 'answer': 1, 'points': 10, 'category': 'Vocabulary', 'difficulty': 'Easy'},
  ];
  
  // Vocabulary Questions (Ages 12-16)
  final List<Map<String, dynamic>> _vocabQuestionsHard = [
    {'text': 'What does "benevolent" mean?', 'options': ['Evil', 'Kind', 'Angry', 'Lazy'], 'answer': 1, 'points': 15, 'category': 'Vocabulary', 'difficulty': 'Hard'},
    {'text': 'What is the meaning of "meticulous"?', 'options': ['Careless', 'Detailed', 'Fast', 'Slow'], 'answer': 1, 'points': 15, 'category': 'Vocabulary', 'difficulty': 'Hard'},
    {'text': 'What does "eloquent" describe?', 'options': ['Ugly', 'Beautiful speech', 'Quiet', 'Loud'], 'answer': 1, 'points': 15, 'category': 'Vocabulary', 'difficulty': 'Hard'},
    {'text': 'What is the synonym of "ubiquitous"?', 'options': ['Rare', 'Everywhere', 'Nowhere', 'Hidden'], 'answer': 1, 'points': 15, 'category': 'Vocabulary', 'difficulty': 'Hard'},
    {'text': 'What does "ephemeral" mean?', 'options': ['Permanent', 'Short-lived', 'Eternal', 'Strong'], 'answer': 1, 'points': 15, 'category': 'Vocabulary', 'difficulty': 'Hard'},
  ];
  
  // Grammar Questions (Ages 6-11)
  final List<Map<String, dynamic>> _grammarQuestionsEasy = [
    {'text': 'Choose the correct sentence:', 'options': ['She go to school', 'She goes to school', 'She going to school', 'She gone to school'], 'answer': 1, 'points': 10, 'category': 'Grammar', 'difficulty': 'Easy'},
    {'text': 'What is the past tense of "eat"?', 'options': ['Eated', 'Ate', 'Eating', 'Eaten'], 'answer': 1, 'points': 10, 'category': 'Grammar', 'difficulty': 'Easy'},
    {'text': 'Fill in the blank: "I ___ a student."', 'options': ['is', 'am', 'are', 'be'], 'answer': 1, 'points': 10, 'category': 'Grammar', 'difficulty': 'Easy'},
    {'text': 'Which word is an adjective?', 'options': ['Run', 'Beautiful', 'Quickly', 'House'], 'answer': 1, 'points': 10, 'category': 'Grammar', 'difficulty': 'Easy'},
    {'text': 'What is the correct spelling?', 'options': ['Recieve', 'Receive', 'Recive', 'Receeve'], 'answer': 1, 'points': 10, 'category': 'Spelling', 'difficulty': 'Easy'},
    {'text': 'Choose the correct article: ___ apple', 'options': ['A', 'An', 'The', 'None'], 'answer': 1, 'points': 10, 'category': 'Grammar', 'difficulty': 'Easy'},
    {'text': 'What is the plural of "child"?', 'options': ['Childs', 'Childes', 'Children', 'Child\'s'], 'answer': 2, 'points': 10, 'category': 'Grammar', 'difficulty': 'Easy'},
    {'text': 'This is ___ book.', 'options': ['I', 'Me', 'My', 'Mine'], 'answer': 2, 'points': 10, 'category': 'Grammar', 'difficulty': 'Easy'},
    {'text': 'Which sentence is correct?', 'options': ['He dont like pizza', 'He doesn\'t like pizza', 'He don\'t like pizza', 'He not like pizza'], 'answer': 1, 'points': 10, 'category': 'Grammar', 'difficulty': 'Easy'},
    {'text': 'What is the past tense of "go"?', 'options': ['Goed', 'Went', 'Gone', 'Going'], 'answer': 1, 'points': 10, 'category': 'Grammar', 'difficulty': 'Easy'},
  ];
  
  // Grammar Questions (Ages 12-16)
  final List<Map<String, dynamic>> _grammarQuestionsHard = [
    {'text': 'Identify the correct sentence:', 'options': ['Neither of them are coming', 'Neither of them is coming', 'Neither of them be coming', 'Neither of them am coming'], 'answer': 1, 'points': 15, 'category': 'Grammar', 'difficulty': 'Hard'},
    {'text': 'What is the passive voice of "She wrote a letter"?', 'options': ['A letter is written by her', 'A letter was written by her', 'A letter was being written by her', 'A letter has been written by her'], 'answer': 1, 'points': 15, 'category': 'Grammar', 'difficulty': 'Hard'},
    {'text': 'Which word is a conjunction?', 'options': ['Run', 'And', 'Beautiful', 'Quickly'], 'answer': 1, 'points': 15, 'category': 'Grammar', 'difficulty': 'Hard'},
    {'text': 'What is the correct form: "If I ___ you, I would go"', 'options': ['was', 'were', 'am', 'is'], 'answer': 1, 'points': 15, 'category': 'Grammar', 'difficulty': 'Hard'},
    {'text': 'Identify the adverb in: "She runs very fast"', 'options': ['She', 'Runs', 'Very', 'Fast'], 'answer': 2, 'points': 15, 'category': 'Grammar', 'difficulty': 'Hard'},
  ];
  
  // Reading Comprehension Questions
  final List<Map<String, dynamic>> _comprehensionQuestions = [
    {'text': 'Reading: "The sun rises in the east and sets in the west." Where does the sun rise?', 'options': ['West', 'North', 'East', 'South'], 'answer': 2, 'points': 15, 'category': 'Reading', 'difficulty': 'Medium'},
    {'text': 'Reading: "Water freezes at 0 degrees Celsius." What temperature does water freeze?', 'options': ['100°C', '0°C', '50°C', '25°C'], 'answer': 1, 'points': 15, 'category': 'Reading', 'difficulty': 'Medium'},
    {'text': 'Reading: "Cats are mammals that love to sleep." What do cats love to do?', 'options': ['Run', 'Eat', 'Sleep', 'Play'], 'answer': 2, 'points': 15, 'category': 'Reading', 'difficulty': 'Medium'},
    {'text': 'Reading: "The Amazon rainforest produces 20% of the world\'s oxygen." What percentage of oxygen does the Amazon produce?', 'options': ['10%', '15%', '20%', '25%'], 'answer': 2, 'points': 15, 'category': 'Reading', 'difficulty': 'Medium'},
    {'text': 'Reading: "Mount Everest is the tallest mountain in the world." What is the tallest mountain?', 'options': ['K2', 'Mount Everest', 'Kilimanjaro', 'Denali'], 'answer': 1, 'points': 15, 'category': 'Reading', 'difficulty': 'Medium'},
  ];
  
  // Idioms and Phrases (Ages 12-16)
  final List<Map<String, dynamic>> _idiomQuestions = [
    {'text': 'What does "break the ice" mean?', 'options': ['Break something frozen', 'Start a conversation', 'Get angry', 'Leave quickly'], 'answer': 1, 'points': 20, 'category': 'Idioms', 'difficulty': 'Hard'},
    {'text': 'What does "hit the books" mean?', 'options': ['Fight books', 'Study hard', 'Read quickly', 'Throw books'], 'answer': 1, 'points': 20, 'category': 'Idioms', 'difficulty': 'Hard'},
    {'text': 'What does "spill the beans" mean?', 'options': ['Drop food', 'Reveal a secret', 'Make a mess', 'Cook dinner'], 'answer': 1, 'points': 20, 'category': 'Idioms', 'difficulty': 'Hard'},
    {'text': 'What does "piece of cake" mean?', 'options': ['A dessert', 'Something easy', 'A small piece', 'Delicious food'], 'answer': 1, 'points': 20, 'category': 'Idioms', 'difficulty': 'Hard'},
    {'text': 'What does "cost an arm and a leg" mean?', 'options': ['Expensive', 'Cheap', 'Painful', 'Free'], 'answer': 0, 'points': 20, 'category': 'Idioms', 'difficulty': 'Hard'},
  ];
  
  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _generateQuestions();
    _startTimer();
  }
  
  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _timerActive && !_isGameOver && !_showResult) {
        setState(() {
          if (_timeRemaining > 0) {
            _timeRemaining--;
            _startTimer();
          } else {
            _handleTimeout();
          }
        });
      }
    });
  }
  
  void _handleTimeout() {
    if (_showResult || _isGameOver) return;
    
    setState(() {
      _showResult = true;
      _lives--;
      _combo = 0;
      _multiplier = 1;
      _selectedAnswer = null;
      _isCorrectAnswer = false;
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        if (_lives <= 0) {
          _endGame(false);
        } else if (_currentIndex + 1 >= _questions.length) {
          _endGame(true);
        } else {
          setState(() {
            _currentIndex++;
            _showResult = false;
            _selectedAnswer = null;
            _timeRemaining = 30;
            _timerActive = true;
          });
          _startTimer();
        }
      }
    });
  }
  
  void _generateQuestions() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    
    // Generate age-appropriate English questions
    if (auth.userAge >= 12) {
      // For ages 12-16: Include advanced vocabulary, grammar, and idioms
      _questions = _generateAdvancedEnglishQuestions(10);
    } else {
      // For younger children: Basic vocabulary, grammar, and comprehension
      _questions = _generateBasicEnglishQuestions(10);
    }
  }
  
  List<Map<String, dynamic>> _generateBasicEnglishQuestions(int count) {
    final questions = <Map<String, dynamic>>[];
    
    // Mix of vocabulary, grammar, and comprehension
    final allQuestions = <Map<String, dynamic>>[];
    allQuestions.addAll(_vocabQuestionsEasy);
    allQuestions.addAll(_grammarQuestionsEasy);
    allQuestions.addAll(_comprehensionQuestions.take(3));
    allQuestions.shuffle(_random);
    
    for (int i = 0; i < count && i < allQuestions.length; i++) {
      questions.add(allQuestions[i]);
    }
    
    return questions;
  }
  
  List<Map<String, dynamic>> _generateAdvancedEnglishQuestions(int count) {
    final questions = <Map<String, dynamic>>[];
    
    // Mix of advanced vocabulary, grammar, idioms, and comprehension
    final allQuestions = <Map<String, dynamic>>[];
    allQuestions.addAll(_vocabQuestionsHard);
    allQuestions.addAll(_grammarQuestionsHard);
    allQuestions.addAll(_idiomQuestions);
    allQuestions.addAll(_comprehensionQuestions);
    allQuestions.shuffle(_random);
    
    for (int i = 0; i < count && i < allQuestions.length; i++) {
      questions.add(allQuestions[i]);
    }
    
    return questions;
  }
  
  void _checkAnswer(int index) {
    if (_showResult || _isGameOver) return;
    
    _timerActive = false;
    
    final bool isCorrect = index == (_questions[_currentIndex]['answer'] as int);
    _isCorrectAnswer = isCorrect;
    
    // Time bonus for quick answers
    int timeBonus = 0;
    if (isCorrect) {
      timeBonus = ((30 - _timeRemaining) ~/ 3) * 2;
    }
    
    setState(() {
      _showResult = true;
      _selectedAnswer = index;
      _questionsAnswered++;
      
      if (isCorrect) {
        int points = (_questions[_currentIndex]['points'] as int) * _multiplier + timeBonus;
        _score += points;
        _combo++;
        _multiplier = (_combo ~/ 3) + 1;
        _confettiController.play();
        _bounceController.forward().then((_) => _bounceController.reverse());
      } else {
        _lives--;
        _combo = 0;
        _multiplier = 1;
        _shakeController.forward().then((_) => _shakeController.reverse());
      }
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        if (_lives <= 0) {
          _endGame(false);
        } else if (_currentIndex + 1 >= _questions.length) {
          _endGame(true);
        } else {
          setState(() {
            _currentIndex++;
            _showResult = false;
            _selectedAnswer = null;
            _timeRemaining = 30;
            _timerActive = true;
          });
          _startTimer();
        }
      }
    });
  }
  
  void _endGame(bool victory) async {
    _isGameOver = true;
    _timerActive = false;
    
    if (victory) {
      await Provider.of<GameProvider>(context, listen: false).addScore(_score, 'English');
      
      // Check if level completed
      if (widget.level > 0) {
        await Provider.of<GameProvider>(context, listen: false).completeLevel(widget.level);
      }
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => GameResultScreen(
              score: _score,
              isVictory: true,
              subject: 'English',
              questionsAnswered: _questionsAnswered,
              totalQuestions: _questions.length,
              multiplier: _multiplier,
            ),
          ),
        );
      }
    } else {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => GameResultScreen(
              score: _score,
              isVictory: false,
              subject: 'English',
              questionsAnswered: _questionsAnswered,
              totalQuestions: _questions.length,
              multiplier: _multiplier,
            ),
          ),
        );
      }
    }
  }
  
  @override
  void dispose() {
    _confettiController.dispose();
    _bounceController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    final q = _questions[_currentIndex];
    final category = q['category'] as String? ?? 'English';
    final difficulty = q['difficulty'] as String? ?? 'Medium';
    
    return Scaffold(
      body: AnimatedBuilder(
        animation: _shakeController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_shakeController.value * 5 * (_isCorrectAnswer ? 0 : 1), 0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.englishGreen.withValues(alpha: 0.15), AppColors.backgroundLight],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    _buildHeader(q, category, difficulty),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: QuestionCard(
                        question: q['text'],
                        currentQuestion: _currentIndex + 1,
                        totalQuestions: _questions.length,
                        points: (q['points'] as int) * _multiplier,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                          ),
                          itemCount: q['options'].length,
                          itemBuilder: (ctx, i) {
                            final colors = [
                              AppColors.englishGreen,
                              AppColors.mintGreen,
                              AppColors.lavenderPurple,
                              AppColors.bubblegumPink,
                            ];
                            return AnswerButton(
                              text: q['options'][i],
                              index: i,
                              color: colors[i % colors.length],
                              onPressed: () => _checkAnswer(i),
                              isSelected: _selectedAnswer == i,
                              showResult: _showResult,
                              isCorrect: i == q['answer'],
                            );
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: ConfettiWidget(
                        confettiController: _confettiController,
                        blastDirectionality: BlastDirectionality.explosive,
                        shouldLoop: false,
                        colors: const [
                          AppColors.gold,
                          AppColors.englishGreen,
                          AppColors.mintGreen,
                          AppColors.lavenderPurple,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> q, String category, String difficulty) {
    Color getDifficultyColor() {
      switch (difficulty) {
        case 'Easy': return AppColors.mintGreen;
        case 'Medium': return AppColors.warningOrange;
        case 'Hard': return AppColors.mathOrange;
        default: return AppColors.englishGreen;
      }
    }
    
    IconData getCategoryIcon() {
      switch (category) {
        case 'Vocabulary': return Icons.menu_book;
        case 'Grammar': return Icons.rule;
        case 'Reading': return Icons.description;
        case 'Idioms': return Icons.psychology;
        default: return Icons.abc;
      }
    }
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.englishGreen, Color(0xFF81C784)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                'English Quest',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.gold, size: 20),
                    const SizedBox(width: 5),
                    Text(
                      '$_score',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.englishGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(getCategoryIcon(), size: 14, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(
                      category,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: getDifficultyColor().withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      difficulty == 'Easy' ? Icons.sentiment_satisfied :
                      difficulty == 'Medium' ? Icons.sentiment_neutral :
                      Icons.sentiment_very_dissatisfied,
                      size: 14,
                      color: getDifficultyColor(),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      difficulty,
                      style: TextStyle(color: getDifficultyColor(), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Lives:', style: TextStyle(color: Colors.white70)),
              const SizedBox(width: 10),
              ...List.generate(3, (i) => Icon(
                i < _lives ? Icons.favorite : Icons.favorite_border,
                color: AppColors.errorRed,
                size: 24,
              )),
              const Spacer(),
              TimerWidget(
                seconds: _timeRemaining,
                maxSeconds: 30,
                isActive: _timerActive && !_showResult && !_isGameOver,
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.flash_on, color: Colors.white, size: 16),
                    const SizedBox(width: 5),
                    Text(
                      'x$_multiplier',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}