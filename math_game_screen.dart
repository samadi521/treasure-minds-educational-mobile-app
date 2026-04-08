import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/quiz_provider.dart';
import '../../widgets/question_card.dart';
import '../../widgets/answer_button.dart';
import '../../widgets/timer_widget.dart';
import 'game_result_screen.dart';

class MathGameScreen extends StatefulWidget {
  final int gradeLevel;
  final int level;
  
  const MathGameScreen({
    super.key, 
    this.gradeLevel = 3,
    this.level = 1,
  });

  @override
  State<MathGameScreen> createState() => _MathGameScreenState();
}

class _MathGameScreenState extends State<MathGameScreen> with TickerProviderStateMixin {
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
  
  int _timeRemaining = 30;
  bool _timerActive = true;
  
  List<Map<String, dynamic>> _questions = [];
  final Random _random = Random();
  
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
    final quizProvider = QuizProvider();
    
    if (auth.userAge >= 12) {
      _questions = _generateAdvancedMathQuestions(10, auth.userAge);
    } else {
      _questions = quizProvider.generateMathQuestions(10, auth.userAge);
    }
  }
  
  List<Map<String, dynamic>> _generateAdvancedMathQuestions(int count, int userAge) {
    final questions = <Map<String, dynamic>>[];
    final quizProvider = QuizProvider();
    
    for (int i = 0; i < count; i++) {
      if (i % 2 == 0) {
        questions.add(quizProvider.generateMathQuestions(1, userAge)[0]);
      } else {
        questions.add(_generateAlgebraQuestion());
      }
    }
    return questions;
  }
  
  Map<String, dynamic> _generateAlgebraQuestion() {
    final types = [
      'x + a = b', 
      'x - a = b', 
      'a × x = b', 
      'x ÷ a = b',
      'ax + b = c',
      'ax - b = c',
    ];
    final type = types[_random.nextInt(types.length)];
    
    int x, a, b, c;
    String question;
    
    switch (type) {
      case 'x + a = b':
        x = _random.nextInt(20) + 1;
        a = _random.nextInt(15) + 1;
        b = x + a;
        question = 'Find x: x + $a = $b';
        break;
      case 'x - a = b':
        x = _random.nextInt(30) + 10;
        a = _random.nextInt(15) + 1;
        b = x - a;
        question = 'Find x: x - $a = $b';
        break;
      case 'a × x = b':
        x = _random.nextInt(12) + 1;
        a = _random.nextInt(10) + 2;
        b = a * x;
        question = 'Find x: $a × x = $b';
        break;
      case 'x ÷ a = b':
        b = _random.nextInt(12) + 1;
        a = _random.nextInt(10) + 2;
        x = a * b;
        question = 'Find x: x ÷ $a = $b';
        break;
      case 'ax + b = c':
        x = _random.nextInt(10) + 1;
        a = _random.nextInt(8) + 2;
        b = _random.nextInt(10) + 1;
        c = a * x + b;
        question = 'Solve: ${a}x + $b = $c';
        break;
      default:
        x = _random.nextInt(10) + 1;
        a = _random.nextInt(8) + 2;
        b = _random.nextInt(10) + 1;
        c = a * x - b;
        question = 'Solve: ${a}x - $b = $c';
        break;
    }
    
    final options = _generateAlgebraOptions(x);
    
    return {
      'text': question,
      'options': options,
      'answer': options.indexOf(x.toString()),
      'points': 20,
      'type': 'Algebra',
    };
  }
  
  List<String> _generateAlgebraOptions(int answer) {
    final options = <String>[answer.toString()];
    const offset = 5;
    
    while (options.length < 4) {
      int wrong;
      if (_random.nextBool()) {
        wrong = answer + _random.nextInt(offset) + 1;
      } else {
        wrong = answer - _random.nextInt(offset) - 1;
      }
      if (wrong > 0 && !options.contains(wrong.toString())) {
        options.add(wrong.toString());
      }
    }
    options.shuffle();
    return options;
  }
  
  void _checkAnswer(int index) {
    if (_showResult || _isGameOver) return;
    
    _timerActive = false;
    
    final bool isCorrect = index == (_questions[_currentIndex]['answer'] as int);
    _isCorrectAnswer = isCorrect;
    
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
      await Provider.of<GameProvider>(context, listen: false).addScore(_score, 'Math');
      
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
              subject: 'Math',
              questionsAnswered: _questionsAnswered,
              totalQuestions: _questions.length,
              multiplier: _multiplier,
            ),
          ),
        );
      }
    } else if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => GameResultScreen(
            score: _score,
            isVictory: false,
            subject: 'Math',
            questionsAnswered: _questionsAnswered,
            totalQuestions: _questions.length,
            multiplier: _multiplier,
          ),
        ),
      );
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
    final questionType = q['type'] as String? ?? 'Arithmetic';
    
    return Scaffold(
      body: AnimatedBuilder(
        animation: _shakeController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_shakeController.value * 5 * (_isCorrectAnswer ? 0 : 1), 0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.mathOrange.withAlpha(38), AppColors.backgroundLight],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    _buildHeader(q, questionType),
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
                              AppColors.mathOrange,
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
                          AppColors.mathOrange,
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

  Widget _buildHeader(Map<String, dynamic> q, String questionType) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.mathOrange, Color(0xFFFFB74D)],
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
                'Math Adventure',
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
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  questionType == 'Algebra' ? Icons.functions : Icons.calculate,
                  size: 14,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                Text(
                  questionType,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
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