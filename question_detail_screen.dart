import 'dart:async';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';

class QuestionDetailScreen extends StatefulWidget {
  final Map<String, dynamic> question;
  final String subject;
  final int currentIndex;
  final int totalQuestions;
  final VoidCallback onAnswer;

  const QuestionDetailScreen({
    super.key,
    required this.question,
    required this.subject,
    required this.currentIndex,
    required this.totalQuestions,
    required this.onAnswer,
  });

  @override
  State<QuestionDetailScreen> createState() => _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends State<QuestionDetailScreen> with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _shakeController;
  
  int? _selectedAnswer;
  bool _showResult = false;
  bool _isCorrect = false;
  int _timeSpent = 0;
  late Timer _timer;
  int _pointsEarned = 0;
  
  // Hints system
  int _hintsUsed = 0;
  final List<bool> _hintsRevealed = [false, false, false];
  
  final List<String> _hintMessages = [
    'Read the question carefully!',
    'Think about what you\'ve learned.',
    'Eliminate obvious wrong answers.',
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseController.repeat(reverse: true);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_showResult && mounted) {
        setState(() {
          _timeSpent++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _confettiController.dispose();
    _pulseController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _checkAnswer(int selectedIndex) {
    if (_showResult) return;
    
    _timer.cancel();
    final bool isCorrect = selectedIndex == widget.question['answer'];
    
    // Calculate points based on time and hints
    int basePoints = widget.question['points'] as int;
    int timeBonus = (_timeSpent < 10) ? 10 : (_timeSpent < 20 ? 5 : 0);
    int hintPenalty = _hintsUsed * 5;
    _pointsEarned = basePoints + timeBonus - hintPenalty;
    if (_pointsEarned < basePoints ~/ 2) _pointsEarned = basePoints ~/ 2;
    
    setState(() {
      _selectedAnswer = selectedIndex;
      _showResult = true;
      _isCorrect = isCorrect;
    });
    
    if (isCorrect) {
      _confettiController.play();
      _pulseController.stop();
      
      // Add points to game provider
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          Provider.of<GameProvider>(context, listen: false).addScore(_pointsEarned, widget.subject);
        }
      });
    } else {
      _shakeController.forward().then((_) => _shakeController.reverse());
    }
    
    // Auto-advance after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        widget.onAnswer();
      }
    });
  }

  void _useHint(int hintIndex) {
    if (_hintsRevealed[hintIndex]) return;
    
    setState(() {
      _hintsRevealed[hintIndex] = true;
      _hintsUsed++;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.lightbulb, color: AppColors.gold),
              const SizedBox(width: 10),
              Expanded(child: Text(_hintMessages[hintIndex])),
            ],
          ),
          backgroundColor: AppColors.neonBlue,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _fiftyFifty() {
    if (_hintsUsed >= 2) return;
    
    setState(() {
      _hintsUsed++;
    });
    
    // Get correct answer and random wrong answers
    final correctIndex = widget.question['answer'] as int;
    final List<String> options = List.from(widget.question['options']);
    final List<int> wrongIndices = [];
    
    for (int i = 0; i < options.length; i++) {
      if (i != correctIndex) {
        wrongIndices.add(i);
      }
    }
    
    // Remove two wrong options (keep one wrong + correct)
    wrongIndices.shuffle();
    final List<int> toRemove = wrongIndices.take(2).toList();
    
    // Show which options are eliminated
    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('50:50 Lifeline Used!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.remove_circle, size: 50, color: AppColors.errorRed),
              const SizedBox(height: 10),
              const Text('Two incorrect answers have been eliminated.'),
              const SizedBox(height: 10),
              ...toRemove.map((index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  '❌ ${options[index]}',
                  style: const TextStyle(color: AppColors.errorRed),
                ),
              )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Got it!'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.question['options'] as List<String>;
    final questionType = widget.question['type'] as String? ?? 'Standard';
    final difficulty = widget.question['difficulty'] as String? ?? 'Medium';
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(questionType, difficulty),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildQuestionCard(),
                    const SizedBox(height: 24),
                    _buildAnswerOptions(options),
                    const SizedBox(height: 20),
                    if (!_showResult) _buildHintsSection(),
                    if (_showResult) _buildResultCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String questionType, String difficulty) {
    Color getDifficultyColor() {
      switch (difficulty) {
        case 'Easy': return AppColors.mintGreen;
        case 'Medium': return AppColors.warningOrange;
        case 'Hard': return AppColors.mathOrange;
        case 'Advanced': return AppColors.neonPurple;
        default: return AppColors.neonBlue;
      }
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
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
                icon: const Icon(Icons.close, color: AppColors.neonPurple),
                onPressed: () => Navigator.pop(context),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: getDifficultyColor().withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  difficulty,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: getDifficultyColor(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getSubjectColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(_getSubjectIcon(), size: 14, color: _getSubjectColor()),
                    const SizedBox(width: 4),
                    Text(
                      widget.subject,
                      style: TextStyle(
                        fontSize: 12,
                        color: _getSubjectColor(),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: AppColors.gold),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.question['points']} pts',
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
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${widget.currentIndex + 1} of ${widget.totalQuestions}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Row(
                children: [
                  const Icon(Icons.timer, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${_timeSpent}s',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (widget.currentIndex + 1) / widget.totalQuestions,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(_getSubjectColor()),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, _getSubjectColor().withValues(alpha: 0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Text(
              widget.question['text'],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnswerOptions(List<String> options) {
    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeController.value * 5, 0),
          child: Column(
            children: List.generate(options.length, (index) {
              final letter = String.fromCharCode(65 + index); // A, B, C, D
              final Color color = _getOptionColor(index);
              
              return GestureDetector(
                onTap: _showResult ? null : () => _checkAnswer(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withValues(alpha: 0.1), Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _selectedAnswer == index
                          ? (_isCorrect ? AppColors.mintGreen : AppColors.errorRed)
                          : Colors.grey.shade200,
                      width: _selectedAnswer == index ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            letter,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          options[index],
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (_selectedAnswer == index)
                        Icon(
                          _isCorrect ? Icons.check_circle : Icons.cancel,
                          color: _isCorrect ? AppColors.mintGreen : AppColors.errorRed,
                          size: 28,
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildHintsSection() {
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
              Icon(Icons.lightbulb, color: AppColors.gold, size: 20),
              SizedBox(width: 8),
              Text(
                'Need Help?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildHintButton('💡 Hint', 0, _hintsRevealed[0]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildHintButton('📖 Hint', 1, _hintsRevealed[1]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildHintButton('🎯 50:50', 2, _hintsRevealed[2], isFiftyFifty: true),
              ),
            ],
          ),
          if (_hintsUsed > 0)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '⚠️ Using hints reduces points earned',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHintButton(String label, int index, bool isRevealed, {bool isFiftyFifty = false}) {
    return ElevatedButton(
      onPressed: isRevealed ? null : () => isFiftyFifty ? _fiftyFifty() : _useHint(index),
      style: ElevatedButton.styleFrom(
        backgroundColor: isRevealed ? Colors.grey.shade300 : AppColors.gold,
        foregroundColor: isRevealed ? Colors.grey : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        isRevealed ? 'Used' : label,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isCorrect
              ? [AppColors.mintGreen.withValues(alpha: 0.1), Colors.white]
              : [AppColors.errorRed.withValues(alpha: 0.1), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isCorrect ? AppColors.mintGreen : AppColors.errorRed,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            _isCorrect ? Icons.check_circle : Icons.cancel,
            size: 50,
            color: _isCorrect ? AppColors.mintGreen : AppColors.errorRed,
          ),
          const SizedBox(height: 12),
          Text(
            _isCorrect ? 'Correct!' : 'Incorrect',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _isCorrect ? AppColors.mintGreen : AppColors.errorRed,
            ),
          ),
          const SizedBox(height: 8),
          if (_isCorrect)
            Text(
              '+$_pointsEarned points',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.gold,
              ),
            ),
          if (!_isCorrect)
            Text(
              'Correct answer: ${widget.question['options'][widget.question['answer']]}',
              style: const TextStyle(fontSize: 14),
            ),
          const SizedBox(height: 8),
          if (_timeSpent > 0 && _isCorrect)
            Text(
              'Time bonus: ${_timeSpent < 10 ? '+10' : (_timeSpent < 20 ? '+5' : '0')}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          if (_hintsUsed > 0 && _isCorrect)
            Text(
              'Hint penalty: -${_hintsUsed * 5}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Color _getOptionColor(int index) {
    if (_showResult && _selectedAnswer == index) {
      return _isCorrect ? AppColors.mintGreen : AppColors.errorRed;
    }
    if (_showResult && index == widget.question['answer']) {
      return AppColors.mintGreen;
    }
    final List<Color> colors = [
      AppColors.mathOrange,
      AppColors.englishGreen,
      AppColors.sciencePurple,
      AppColors.neonBlue,
    ];
    return colors[index % colors.length];
  }

  Color _getSubjectColor() {
    switch (widget.subject) {
      case 'Math': return AppColors.mathOrange;
      case 'English': return AppColors.englishGreen;
      case 'Science': return AppColors.sciencePurple;
      default: return AppColors.neonBlue;
    }
  }

  IconData _getSubjectIcon() {
    switch (widget.subject) {
      case 'Math': return Icons.calculate;
      case 'English': return Icons.menu_book;
      case 'Science': return Icons.science;
      default: return Icons.quiz;
    }
  }
}