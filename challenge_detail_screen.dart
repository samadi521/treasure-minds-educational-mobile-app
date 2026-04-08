import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../../providers/auth_provider.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final Map<String, dynamic> challenge;
  final int challengeIndex;

  const ChallengeDetailScreen({
    super.key,
    required this.challenge,
    required this.challengeIndex,
  });

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  bool _isStarted = false;
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _lives = 3;
  int _combo = 0;
  int _multiplier = 1;
  int? _selectedAnswer;
  bool _showResult = false;
  bool _isGameOver = false;
  bool _isCompleted = false;
  
  List<Map<String, dynamic>> _questions = [];
  Map<String, dynamic>? _currentQuestion;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _loadChallengeQuestions();
  }

  void _loadChallengeQuestions() {
    // Load questions based on challenge type
    final challengeType = widget.challenge['type'];
    final difficulty = widget.challenge['difficulty'];
    
    _questions = _generateQuestions(challengeType, difficulty);
    _currentQuestion = _questions[_currentQuestionIndex];
  }

  List<Map<String, dynamic>> _generateQuestions(String type, String difficulty) {
    final questions = <Map<String, dynamic>>[];
    final questionCount = widget.challenge['questionCount'] ?? 10;
    
    for (int i = 0; i < questionCount; i++) {
      if (type == 'Math') {
        questions.add(_generateMathQuestion(difficulty));
      } else if (type == 'English') {
        questions.add(_generateEnglishQuestion(difficulty));
      } else {
        questions.add(_generateScienceQuestion(difficulty));
      }
    }
    return questions;
  }

  Map<String, dynamic> _generateMathQuestion(String difficulty) {
    final isHard = difficulty == 'Hard' || difficulty == 'Expert';
    final points = isHard ? 20 : 10;
    
    if (isHard) {
      return {
        'text': 'Solve: 2x + 5 = 15',
        'options': ['x = 3', 'x = 4', 'x = 5', 'x = 6'],
        'answer': 1,
        'points': points,
        'type': 'Algebra',
      };
    } else {
      return {
        'text': '12 × 8 = ?',
        'options': ['86', '96', '106', '88'],
        'answer': 1,
        'points': points,
        'type': 'Arithmetic',
      };
    }
  }

  Map<String, dynamic> _generateEnglishQuestion(String difficulty) {
    final isHard = difficulty == 'Hard' || difficulty == 'Expert';
    final points = isHard ? 20 : 10;
    
    if (isHard) {
      return {
        'text': 'What does "benevolent" mean?',
        'options': ['Evil', 'Kind', 'Angry', 'Lazy'],
        'answer': 1,
        'points': points,
        'type': 'Vocabulary',
      };
    } else {
      return {
        'text': 'She ___ to school every day.',
        'options': ['go', 'goes', 'going', 'went'],
        'answer': 1,
        'points': points,
        'type': 'Grammar',
      };
    }
  }

  Map<String, dynamic> _generateScienceQuestion(String difficulty) {
    final isHard = difficulty == 'Hard' || difficulty == 'Expert';
    final points = isHard ? 20 : 10;
    
    if (isHard) {
      return {
        'text': 'What is the powerhouse of the cell?',
        'options': ['Nucleus', 'Mitochondria', 'Ribosome', 'Chloroplast'],
        'answer': 1,
        'points': points,
        'type': 'Biology',
      };
    } else {
      return {
        'text': 'What is H2O?',
        'options': ['Salt', 'Water', 'Oxygen', 'Hydrogen'],
        'answer': 1,
        'points': points,
        'type': 'Chemistry',
      };
    }
  }

  void _checkAnswer(int index) {
    if (_showResult || _isGameOver) return;
    
    final bool isCorrect = index == _currentQuestion!['answer'];
    
    setState(() {
      _showResult = true;
      _selectedAnswer = index;
      
      if (isCorrect) {
        int points = _currentQuestion!['points'] * _multiplier;
        _score += points;
        _combo++;
        _multiplier = (_combo ~/ 3) + 1;
        _confettiController.play();
        _pulseController.forward().then((_) => _pulseController.reverse());
      } else {
        _lives--;
        _combo = 0;
        _multiplier = 1;
      }
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      if (_lives <= 0) {
        _endChallenge(false);
      } else if (_currentQuestionIndex + 1 >= _questions.length) {
        _endChallenge(true);
      } else {
        setState(() {
          _currentQuestionIndex++;
          _currentQuestion = _questions[_currentQuestionIndex];
          _showResult = false;
          _selectedAnswer = null;
        });
      }
    });
  }

  void _endChallenge(bool victory) async {
    _isGameOver = true;
    
    if (victory) {
      final reward = widget.challenge['reward'] as int;
      _score += reward;
      await Provider.of<GameProvider>(context, listen: false).addScore(_score, 'Challenge');
      _showVictoryDialog();
    } else {
      _showDefeatDialog();
    }
  }

  void _showVictoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: const Text('Challenge Complete! 🎉', style: TextStyle(color: AppColors.gold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 60, color: AppColors.gold),
            const SizedBox(height: 10),
            Text('Score: $_score', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Combo: x$_multiplier', style: const TextStyle(color: AppColors.mintGreen)),
            const SizedBox(height: 10),
            Text('Reward: +${widget.challenge['reward']} XP', style: const TextStyle(color: AppColors.gold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mintGreen,
            ),
            child: const Text('Back to Challenges'),
          ),
        ],
      ),
    );
  }

  void _showDefeatDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: const Text('Challenge Failed', style: TextStyle(color: AppColors.errorRed)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sentiment_dissatisfied, size: 60, color: AppColors.errorRed),
            const SizedBox(height: 10),
            Text('Score: $_score', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Questions: $_currentQuestionIndex/${_questions.length}'),
            const SizedBox(height: 10),
            const Text('Keep practicing and try again!', style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _isStarted = false;
                _currentQuestionIndex = 0;
                _score = 0;
                _lives = 3;
                _combo = 0;
                _multiplier = 1;
                _isGameOver = false;
                _loadChallengeQuestions();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mathOrange,
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: _isStarted ? _buildGameScreen() : _buildDetailScreen(),
    );
  }

  Widget _buildDetailScreen() {
    final color = widget.challenge['color'] as Color;
    
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: color,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.challenge['icon'],
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.challenge['title'],
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.challenge['difficulty'],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(),
                const SizedBox(height: 20),
                _buildRewardsCard(),
                const SizedBox(height: 20),
                _buildRequirementsCard(),
                const SizedBox(height: 30),
                _buildStartButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
              Icon(Icons.info, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Challenge Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow(Icons.quiz, 'Questions', '${widget.challenge['questionCount']} questions'),
          _buildDetailRow(Icons.timer, 'Time Limit', widget.challenge['timeLimit'] ?? 'No limit'),
          _buildDetailRow(Icons.favorite, 'Lives', '3 lives'),
          _buildDetailRow(Icons.flash_on, 'Multiplier', 'Combo multiplier up to x4'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gold.withValues(alpha: 0.1), AppColors.warningOrange.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.card_giftcard, color: AppColors.gold),
              SizedBox(width: 8),
              Text(
                'Rewards',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRewardItem(Icons.star, '+${widget.challenge['xpReward']}', 'XP'),
              _buildRewardItem(Icons.monetization_on, '+${widget.challenge['coinReward']}', 'Coins'),
              _buildRewardItem(Icons.emoji_events, widget.challenge['badge'] ?? 'Badge', 'Special'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRewardItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 30, color: AppColors.gold),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.gold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildRequirementsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
              Icon(Icons.assignment, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Requirements',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildRequirementItem('Minimum Level: ${widget.challenge['minLevel'] ?? 1}', true),
          const SizedBox(height: 8),
          _buildRequirementItem('Previous challenges completed', true),
          const SizedBox(height: 8),
          _buildRequirementItem('Internet connection required', true),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.lock,
          size: 18,
          color: isMet ? AppColors.mintGreen : Colors.grey,
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: isMet ? Colors.black87 : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _isStarted = true;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.challenge['color'],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'START CHALLENGE',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildGameScreen() {
    if (_currentQuestion == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    final q = _currentQuestion!;
    final options = q['options'] as List<String>;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [widget.challenge['color'].withValues(alpha: 0.1), AppColors.backgroundLight],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildGameHeader(),
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

  Widget _buildGameHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: widget.challenge['color'],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _isStarted = false;
                  });
                },
              ),
              Text(
                widget.challenge['title'],
                style: const TextStyle(
                  fontSize: 18,
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
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
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
          scale: _pulseAnimation.value,
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
            child: Text(
              q['text'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
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