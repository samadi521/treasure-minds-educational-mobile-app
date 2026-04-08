import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../../providers/auth_provider.dart';
import '../games/math_game_screen.dart';
import '../games/english_game_screen.dart';
import '../games/science_game_screen.dart';

class QuickPlayScreen extends StatefulWidget {
  const QuickPlayScreen({super.key});

  @override
  State<QuickPlayScreen> createState() => _QuickPlayScreenState();
}

class _QuickPlayScreenState extends State<QuickPlayScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  int _selectedQuestionCount = 5;
  int _selectedDifficulty = 1; // 0 = Easy, 1 = Mixed, 2 = Hard
  String _selectedSubject = 'Mixed';
  bool _isPlaying = false;
  
  final List<int> _questionCounts = [5, 10, 15, 20];
  final List<String> _subjects = ['Mixed', 'Math', 'English', 'Science'];
  final List<String> _difficulties = ['Easy', 'Mixed', 'Hard'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Quick Play'),
        backgroundColor: AppColors.neonGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _isPlaying ? _buildGameScreen() : _buildSetupScreen(),
      ),
    );
  }

  Widget _buildSetupScreen() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildQuestionCountSelector(),
          const SizedBox(height: 24),
          _buildSubjectSelector(),
          const SizedBox(height: 24),
          _buildDifficultySelector(),
          const SizedBox(height: 32),
          _buildStartButton(),
          const SizedBox(height: 20),
          _buildDailyChallengeCard(),
          const SizedBox(height: 20),
          _buildRecentGamesCard(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.neonGreen, AppColors.mintGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonGreen.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.flash_on, color: Colors.white, size: 35),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Quick Play',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Jump straight into the action!',
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCountSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.quiz, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Number of Questions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _questionCounts.map((count) {
              final isSelected = _selectedQuestionCount == count;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedQuestionCount = count;
                  });
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.neonGreen : Colors.grey.shade200,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: AppColors.neonGreen, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.subject, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Select Subject',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _subjects.map((subject) {
              final isSelected = _selectedSubject == subject;
              Color getColor() {
                switch (subject) {
                  case 'Math': return AppColors.mathOrange;
                  case 'English': return AppColors.englishGreen;
                  case 'Science': return AppColors.sciencePurple;
                  default: return AppColors.neonBlue;
                }
              }
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSubject = subject;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? getColor() : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getSubjectIcon(subject),
                        size: 18,
                        color: isSelected ? Colors.white : getColor(),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        subject,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultySelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.speed, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Difficulty',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: _difficulties.asMap().entries.map((entry) {
              final index = entry.key;
              final difficulty = entry.value;
              final isSelected = _selectedDifficulty == index;
              Color getColor() {
                if (index == 0) return AppColors.mintGreen;
                if (index == 1) return AppColors.warningOrange;
                return AppColors.errorRed;
              }
              
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDifficulty = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? getColor() : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        difficulty,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _isPlaying = true;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_arrow, size: 28),
            SizedBox(width: 8),
            Text(
              'START QUICK PLAY',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyChallengeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gold.withValues(alpha: 0.1), AppColors.warningOrange.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_events, color: AppColors.gold, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Daily Challenge Available!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Complete today\'s challenge for bonus rewards',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Play', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentGamesCard() {
    final recentGames = [
      {'subject': 'Math', 'score': 85, 'date': 'Today', 'icon': Icons.calculate, 'color': AppColors.mathOrange},
      {'subject': 'English', 'score': 92, 'date': 'Yesterday', 'icon': Icons.menu_book, 'color': AppColors.englishGreen},
      {'subject': 'Science', 'score': 78, 'date': '2 days ago', 'icon': Icons.science, 'color': AppColors.sciencePurple},
    ];
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.history, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Recent Games',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...recentGames.map((game) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (game['color'] as Color).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(game['icon'] as IconData, color: game['color'] as Color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game['subject'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        game['date'] as String,
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: (game['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    '${game['score']}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: game['color'] as Color,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildGameScreen() {
    // Generate questions based on selections
    final questions = _generateQuestions();
    
    return QuickPlayGameScreen(
      questions: questions,
      subject: _selectedSubject,
      onComplete: () {
        setState(() {
          _isPlaying = false;
        });
      },
    );
  }

  List<Map<String, dynamic>> _generateQuestions() {
    final questions = <Map<String, dynamic>>[];
    final isMixed = _selectedSubject == 'Mixed';
    final isHard = _selectedDifficulty == 2;
    final isEasy = _selectedDifficulty == 0;
    
    for (int i = 0; i < _selectedQuestionCount; i++) {
      String subject;
      if (isMixed) {
        final subjects = ['Math', 'English', 'Science'];
        subject = subjects[i % subjects.length];
      } else {
        subject = _selectedSubject;
      }
      
      Map<String, dynamic> question;
      if (subject == 'Math') {
        question = _generateMathQuestion(isHard, isEasy);
      } else if (subject == 'English') {
        question = _generateEnglishQuestion(isHard, isEasy);
      } else {
        question = _generateScienceQuestion(isHard, isEasy);
      }
      
      questions.add(question);
    }
    
    return questions;
  }

  Map<String, dynamic> _generateMathQuestion(bool isHard, bool isEasy) {
    if (isHard) {
      return {
        'text': 'Solve: 3x + 7 = 22',
        'options': ['x = 3', 'x = 4', 'x = 5', 'x = 6'],
        'answer': 2,
        'points': 20,
        'type': 'Algebra',
      };
    } else if (isEasy) {
      return {
        'text': '5 + 3 = ?',
        'options': ['6', '7', '8', '9'],
        'answer': 2,
        'points': 10,
        'type': 'Arithmetic',
      };
    } else {
      return {
        'text': '12 × 8 = ?',
        'options': ['86', '96', '106', '88'],
        'answer': 1,
        'points': 15,
        'type': 'Arithmetic',
      };
    }
  }

  Map<String, dynamic> _generateEnglishQuestion(bool isHard, bool isEasy) {
    if (isHard) {
      return {
        'text': 'What does "benevolent" mean?',
        'options': ['Evil', 'Kind', 'Angry', 'Lazy'],
        'answer': 1,
        'points': 20,
        'type': 'Vocabulary',
      };
    } else if (isEasy) {
      return {
        'text': 'What is the opposite of "hot"?',
        'options': ['Warm', 'Cold', 'Cool', 'Fire'],
        'answer': 1,
        'points': 10,
        'type': 'Vocabulary',
      };
    } else {
      return {
        'text': 'She ___ to school every day.',
        'options': ['go', 'goes', 'going', 'went'],
        'answer': 1,
        'points': 15,
        'type': 'Grammar',
      };
    }
  }

  Map<String, dynamic> _generateScienceQuestion(bool isHard, bool isEasy) {
    if (isHard) {
      return {
        'text': 'What is the powerhouse of the cell?',
        'options': ['Nucleus', 'Mitochondria', 'Ribosome', 'Chloroplast'],
        'answer': 1,
        'points': 20,
        'type': 'Biology',
      };
    } else if (isEasy) {
      return {
        'text': 'What is H2O?',
        'options': ['Salt', 'Water', 'Oxygen', 'Hydrogen'],
        'answer': 1,
        'points': 10,
        'type': 'Chemistry',
      };
    } else {
      return {
        'text': 'What planet is known as the Red Planet?',
        'options': ['Venus', 'Mars', 'Jupiter', 'Saturn'],
        'answer': 1,
        'points': 15,
        'type': 'Astronomy',
      };
    }
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject) {
      case 'Math': return Icons.calculate;
      case 'English': return Icons.menu_book;
      case 'Science': return Icons.science;
      default: return Icons.shuffle;
    }
  }
}

class QuickPlayGameScreen extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final String subject;
  final VoidCallback onComplete;

  const QuickPlayGameScreen({
    super.key,
    required this.questions,
    required this.subject,
    required this.onComplete,
  });

  @override
  State<QuickPlayGameScreen> createState() => _QuickPlayGameScreenState();
}

class _QuickPlayGameScreenState extends State<QuickPlayGameScreen> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _pulseController;
  
  int _currentIndex = 0;
  int _score = 0;
  int _lives = 3;
  int _combo = 0;
  int _multiplier = 1;
  int? _selectedAnswer;
  bool _showResult = false;
  bool _isGameOver = false;
  
  Map<String, dynamic> get _currentQuestion => widget.questions[_currentIndex];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _checkAnswer(int index) {
    if (_showResult || _isGameOver) return;
    
    final bool isCorrect = index == _currentQuestion['answer'];
    
    setState(() {
      _showResult = true;
      _selectedAnswer = index;
      
      if (isCorrect) {
        int points = _currentQuestion['points'] * _multiplier;
        _score += points;
        _combo++;
        _multiplier = (_combo ~/ 3) + 1;
        _confettiController.play();
        _pulseController.stop();
      } else {
        _lives--;
        _combo = 0;
        _multiplier = 1;
      }
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      if (_lives <= 0) {
        _endGame(false);
      } else if (_currentIndex + 1 >= widget.questions.length) {
        _endGame(true);
      } else {
        setState(() {
          _currentIndex++;
          _showResult = false;
          _selectedAnswer = null;
        });
        _pulseController.repeat(reverse: true);
      }
    });
  }

  void _endGame(bool victory) async {
    _isGameOver = true;
    
    if (victory) {
      await Provider.of<GameProvider>(context, listen: false).addScore(_score, widget.subject);
      _showResultDialog(true);
    } else {
      _showResultDialog(false);
    }
  }

  void _showResultDialog(bool victory) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: Text(
          victory ? 'Victory! 🎉' : 'Game Over!',
          style: TextStyle(
            color: victory ? AppColors.gold : AppColors.errorRed,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              victory ? Icons.emoji_events : Icons.sentiment_dissatisfied,
              size: 60,
              color: victory ? AppColors.gold : AppColors.errorRed,
            ),
            const SizedBox(height: 10),
            Text(
              'Score: $_score',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Combo: x$_multiplier',
              style: const TextStyle(color: AppColors.mintGreen),
            ),
            const SizedBox(height: 10),
            Text(
              '${_currentIndex + 1}/${widget.questions.length} questions completed',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onComplete();
            },
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _currentIndex = 0;
                _score = 0;
                _lives = 3;
                _combo = 0;
                _multiplier = 1;
                _isGameOver = false;
                _showResult = false;
                _selectedAnswer = null;
              });
              _pulseController.repeat(reverse: true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonGreen,
            ),
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = _currentQuestion;
    final options = q['options'] as List<String>;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.neonGreen.withValues(alpha: 0.1), AppColors.backgroundLight],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildQuestionCard(q),
                      const SizedBox(height: 30),
                      ...List.generate(options.length, (index) {
                        return _buildAnswerButton(options[index], index, q);
                      }),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.neonGreen,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => widget.onComplete(),
              ),
              const Text(
                'Quick Play',
                style: TextStyle(
                  fontSize: 20,
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
                child: Text(
                  '$_score',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Lives:', style: TextStyle(color: Colors.white70)),
              const SizedBox(width: 8),
              ...List.generate(3, (i) => Icon(
                i < _lives ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
                size: 20,
              )),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'x$_multiplier',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (_currentIndex + 1) / widget.questions.length,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Question ${_currentIndex + 1} of ${widget.questions.length}',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> q) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1 + (_pulseController.value * 0.02),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.neonGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    q['type'],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  q['text'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnswerButton(String text, int index, Map<String, dynamic> q) {
    final colors = [
      AppColors.mathOrange,
      AppColors.englishGreen,
      AppColors.sciencePurple,
      AppColors.neonBlue,
    ];
    
    Color buttonColor = colors[index % colors.length];
    if (_showResult) {
      if (index == q['answer']) {
        buttonColor = AppColors.mintGreen;
      } else if (_selectedAnswer == index) {
        buttonColor = AppColors.errorRed;
      }
    }
    
    return GestureDetector(
      onTap: _showResult ? null : () => _checkAnswer(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [buttonColor, buttonColor.withValues(alpha: 0.8)],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            if (_showResult && (index == q['answer'] || _selectedAnswer == index))
              Icon(
                index == q['answer'] ? Icons.check_circle : Icons.cancel,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}