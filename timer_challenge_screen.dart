import 'dart:async';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../../widgets/answer_button.dart';
import '../game_modes/game_mode_selection.dart';

class TimerChallengeScreen extends StatefulWidget {
  const TimerChallengeScreen({super.key});

  @override
  State<TimerChallengeScreen> createState() => _TimerChallengeScreenState();
}

class _TimerChallengeScreenState extends State<TimerChallengeScreen> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  int _timeLeft = 60;
  int _score = 0;
  int _questionsAnswered = 0;
  int _correctAnswers = 0;
  Timer? _timer;
  bool _isGameActive = true;
  int? _selectedAnswer;
  bool _showResult = false;
  int _streak = 0;
  int _bestStreak = 0;
  
  List<Map<String, dynamic>> _questions = [];
  Map<String, dynamic>? _currentQuestion;
  List<String> _options = [];
  
  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.elasticOut),
    );
    _generateQuestions();
    _startTimer();
  }
  
  void _generateQuestions() {
    final allQuestions = <Map<String, dynamic>>[];
    
    // Generate mixed questions from all subjects
    // Math Questions
    allQuestions.addAll([
      {'text': '5 + 7 = ?', 'options': ['10', '11', '12', '13'], 'answer': 2, 'points': 10, 'subject': 'Math'},
      {'text': '15 - 8 = ?', 'options': ['5', '6', '7', '8'], 'answer': 2, 'points': 10, 'subject': 'Math'},
      {'text': '9 × 6 = ?', 'options': ['54', '56', '52', '58'], 'answer': 0, 'points': 10, 'subject': 'Math'},
      {'text': '24 ÷ 4 = ?', 'options': ['4', '5', '6', '7'], 'answer': 2, 'points': 10, 'subject': 'Math'},
      {'text': 'What is 20% of 50?', 'options': ['5', '10', '15', '20'], 'answer': 1, 'points': 15, 'subject': 'Math'},
      {'text': 'If x + 5 = 12, what is x?', 'options': ['5', '6', '7', '8'], 'answer': 2, 'points': 15, 'subject': 'Math'},
    ]);
    
    // English Questions
    allQuestions.addAll([
      {'text': 'What is the synonym of "happy"?', 'options': ['Sad', 'Joyful', 'Angry', 'Tired'], 'answer': 1, 'points': 10, 'subject': 'English'},
      {'text': 'What is the antonym of "fast"?', 'options': ['Quick', 'Rapid', 'Slow', 'Speedy'], 'answer': 2, 'points': 10, 'subject': 'English'},
      {'text': 'She ___ to school every day.', 'options': ['go', 'goes', 'going', 'went'], 'answer': 1, 'points': 10, 'subject': 'English'},
      {'text': 'What is the past tense of "run"?', 'options': ['Ran', 'Runned', 'Running', 'Runs'], 'answer': 0, 'points': 10, 'subject': 'English'},
      {'text': 'What does "brave" mean?', 'options': ['Scared', 'Courageous', 'Weak', 'Sad'], 'answer': 1, 'points': 10, 'subject': 'English'},
    ]);
    
    // Science Questions
    allQuestions.addAll([
      {'text': 'What is the closest star to Earth?', 'options': ['Moon', 'Sun', 'Mars', 'Venus'], 'answer': 1, 'points': 10, 'subject': 'Science'},
      {'text': 'What gas do humans breathe in?', 'options': ['CO2', 'O2', 'N2', 'H2'], 'answer': 1, 'points': 10, 'subject': 'Science'},
      {'text': 'What is the hardest natural substance?', 'options': ['Iron', 'Gold', 'Diamond', 'Platinum'], 'answer': 2, 'points': 10, 'subject': 'Science'},
      {'text': 'What planet is known as the Red Planet?', 'options': ['Venus', 'Mars', 'Jupiter', 'Saturn'], 'answer': 1, 'points': 10, 'subject': 'Science'},
      {'text': 'What is H2O?', 'options': ['Salt', 'Water', 'Oxygen', 'Hydrogen'], 'answer': 1, 'points': 10, 'subject': 'Science'},
    ]);
    
    allQuestions.shuffle();
    _questions = allQuestions.take(20).toList();
  }
  
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft > 0 && _isGameActive) {
            _timeLeft--;
          } else if (_timeLeft <= 0 && _isGameActive) {
            _endGame();
          }
        });
      }
    });
  }
  
  void _loadQuestion() {
    if (_questionsAnswered < _questions.length && _isGameActive) {
      setState(() {
        _currentQuestion = _questions[_questionsAnswered];
        _options = List<String>.from(_currentQuestion!['options']);
        _selectedAnswer = null;
        _showResult = false;
      });
      _pulseController.forward().then((_) => _pulseController.reverse());
    } else if (_questionsAnswered >= _questions.length) {
      _endGame();
    }
  }
  
  void _checkAnswer(int selectedIndex) {
    if (_showResult || !_isGameActive) return;
    
    final bool isCorrect = selectedIndex == _currentQuestion!['answer'];
    
    setState(() {
      _showResult = true;
      _selectedAnswer = selectedIndex;
      _questionsAnswered++;
      
      if (isCorrect) {
        _correctAnswers++;
        _streak++;
        if (_streak > _bestStreak) _bestStreak = _streak;
        
        // Calculate points with streak bonus
        int points = _currentQuestion!['points'] as int;
        int streakBonus = (_streak ~/ 3) * 5;
        int timeBonus = ((60 - _timeLeft) ~/ 10) * 2;
        int totalPoints = points + streakBonus + timeBonus;
        
        _score += totalPoints;
        _confettiController.play();
      } else {
        _streak = 0;
      }
    });
    
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted && _isGameActive) {
        if (_questionsAnswered >= _questions.length) {
          _endGame();
        } else {
          _loadQuestion();
        }
      }
    });
  }
  
  void _endGame() async {
    if (_timer != null) {
      _timer!.cancel();
    }
    
    if (!_isGameActive) return;
    
    setState(() {
      _isGameActive = false;
    });
    
    // Add bonus points for remaining time
    int timeBonus = _timeLeft * 2;
    _score += timeBonus;
    
    // Add score to game provider
    await Provider.of<GameProvider>(context, listen: false).addScore(_score, 'Timer Challenge');
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TimerResultScreen(
            score: _score,
            questionsAnswered: _questionsAnswered,
            correctAnswers: _correctAnswers,
            timeLeft: _timeLeft,
            bestStreak: _bestStreak,
            totalQuestions: _questions.length,
          ),
        ),
      );
    }
  }
  
  Color _getTimerColor() {
    if (_timeLeft > 30) return AppColors.mintGreen;
    if (_timeLeft > 15) return AppColors.warningOrange;
    return AppColors.errorRed;
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _confettiController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty || _currentQuestion == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    final String subject = _currentQuestion!['subject'] as String? ?? 'Quiz';
    IconData subjectIcon;
    Color subjectColor;
    
    switch (subject) {
      case 'Math':
        subjectIcon = Icons.calculate;
        subjectColor = AppColors.mathOrange;
        break;
      case 'English':
        subjectIcon = Icons.menu_book;
        subjectColor = AppColors.englishGreen;
        break;
      case 'Science':
        subjectIcon = Icons.science;
        subjectColor = AppColors.sciencePurple;
        break;
      default:
        subjectIcon = Icons.quiz;
        subjectColor = AppColors.neonBlue;
    }
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.warningOrange.withValues(alpha: 0.15), AppColors.backgroundLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(subject, subjectIcon, subjectColor),
              const SizedBox(height: 20),
              _buildQuestionCard(),
              const SizedBox(height: 20),
              Expanded(
                child: _buildAnswerOptions(),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [
                    AppColors.gold,
                    AppColors.warningOrange,
                    AppColors.mintGreen,
                    AppColors.lavenderPurple,
                  ],
                  numberOfParticles: 30,
                  gravity: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader(String subject, IconData subjectIcon, Color subjectColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [subjectColor, subjectColor.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: subjectColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
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
                "⚡ Timer Challenge",
                style: TextStyle(
                  fontSize: 22,
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
                      "$_score",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.warningOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          
          // Timer Circle
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _getTimerColor().withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$_timeLeft",
                    style: TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      color: _getTimerColor(),
                    ),
                  ),
                  const Text(
                    "seconds left",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 15),
          
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatChip(Icons.quiz, "${_questionsAnswered}/${_questions.length}", "Questions"),
              _buildStatChip(Icons.local_fire_department, "$_streak", "Streak"),
              _buildStatChip(Icons.bolt, "${(_streak ~/ 3) * 5}+", "Bonus"),
            ],
          ),
          
          const SizedBox(height: 10),
          
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _questionsAnswered / _questions.length,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(subjectColor),
              minHeight: 8,
            ),
          ),
          
          const SizedBox(height: 5),
          Text(
            "Question ${_questionsAnswered + 1} of ${_questions.length}",
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatChip(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuestionCard() {
    final String subjectValue = _currentQuestion!['subject'] as String? ?? 'Quiz';
    Color getSubjectColor() {
      if (subjectValue == 'Math') return AppColors.mathOrange;
      if (subjectValue == 'English') return AppColors.englishGreen;
      if (subjectValue == 'Science') return AppColors.sciencePurple;
      return AppColors.neonBlue;
    }
    
    IconData getSubjectIcon() {
      if (subjectValue == 'Math') return Icons.calculate;
      if (subjectValue == 'English') return Icons.menu_book;
      if (subjectValue == 'Science') return Icons.science;
      return Icons.quiz;
    }
    
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
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
                  // Subject Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: getSubjectColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          getSubjectIcon(),
                          size: 14,
                          color: getSubjectColor(),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          subjectValue,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: getSubjectColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _currentQuestion!['text'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: AppColors.gold, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          "+${_currentQuestion!['points']} + ${(_streak ~/ 3) * 5} streak + ${((60 - _timeLeft) ~/ 10) * 2} time",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.gold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildAnswerOptions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: _options.length,
        itemBuilder: (context, index) {
          final colors = [
            AppColors.mathOrange,
            AppColors.mintGreen,
            AppColors.lavenderPurple,
            AppColors.bubblegumPink,
          ];
          
          // Add highlight for correct answer when showing result
          Color buttonColor = colors[index % colors.length];
          if (_showResult) {
            if (index == _currentQuestion!['answer']) {
              buttonColor = Colors.green;
            } else if (_selectedAnswer == index) {
              buttonColor = Colors.red;
            }
          }
          
          return AnswerButton(
            text: _options[index],
            index: index,
            color: buttonColor,
            onPressed: () => _checkAnswer(index),
            isSelected: _selectedAnswer == index,
            showResult: _showResult,
            isCorrect: index == _currentQuestion!['answer'],
          );
        },
      ),
    );
  }
}

// Timer Result Screen
class TimerResultScreen extends StatelessWidget {
  final int score;
  final int questionsAnswered;
  final int correctAnswers;
  final int timeLeft;
  final int bestStreak;
  final int totalQuestions;

  const TimerResultScreen({
    super.key,
    required this.score,
    required this.questionsAnswered,
    required this.correctAnswers,
    required this.timeLeft,
    required this.bestStreak,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final double accuracy = questionsAnswered > 0 ? (correctAnswers / questionsAnswered) * 100 : 0;
    String performanceMessage;
    String emoji;
    Color color;

    if (accuracy >= 80) {
      performanceMessage = 'Lightning Fast! You\'re a champion!';
      emoji = '⚡🏆';
      color = AppColors.gold;
    } else if (accuracy >= 60) {
      performanceMessage = 'Great Speed! Keep practicing!';
      emoji = '🚀🎉';
      color = AppColors.mintGreen;
    } else if (accuracy >= 40) {
      performanceMessage = 'Good effort! Speed will come!';
      emoji = '💪👍';
      color = AppColors.warningOrange;
    } else {
      performanceMessage = 'Keep going! Practice makes perfect!';
      emoji = '🌟💫';
      color = AppColors.brightBlue;
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.2), AppColors.backgroundLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Trophy Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color,
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 60),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'TIME\'S UP!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: color,
                      shadows: const [Shadow(blurRadius: 4, color: Colors.black26)],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    performanceMessage,
                    style: const TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  const SizedBox(height: 30),
                  // Stats Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
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
                        const Text(
                          'Final Score',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          '$score',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppColors.gold,
                          ),
                        ),
                        const Divider(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildResultStat('Questions', '$questionsAnswered/$totalQuestions', Icons.quiz),
                            _buildResultStat('Correct', '$correctAnswers', Icons.check_circle),
                            _buildResultStat('Accuracy', '${accuracy.toInt()}%', Icons.percent),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildResultStat('Time Left', '${timeLeft}s', Icons.timer),
                            _buildResultStat('Best Streak', '$bestStreak', Icons.local_fire_department),
                            _buildResultStat('Time Bonus', '+${timeLeft * 2}', Icons.bolt),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const TimerChallengeScreen()),
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.replay),
                        label: const Text('Play Again'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.neonGreen,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const GameModeSelectionScreen()),
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.home),
                        label: const Text('Home'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.neonBlue,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.neonPurple, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }
}