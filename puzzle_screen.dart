import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../../widgets/answer_button.dart';
import '../../widgets/question_card.dart';
import '../games/game_result_screen.dart';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({super.key});

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  int _currentIndex = 0;
  int _score = 0;
  int _lives = 3;
  int _multiplier = 1;
  int _combo = 0;
  int? _selectedAnswer;
  bool _showResult = false;
  bool _isGameOver = false;
  int _questionsAnswered = 0;
  
  List<Map<String, dynamic>> _puzzles = [];
  final Random _random = Random();
  
  // Comprehensive puzzle collection (50+ puzzles)
  final List<Map<String, dynamic>> _puzzleCollection = [
    // Easy Puzzles (10)
    {'clue': 'I have keys but no locks. I have space but no room. What am I?', 'answer': 'keyboard', 'hint': 'You use me to type', 'difficulty': 'Easy', 'points': 15},
    {'clue': 'What has to be broken before you can use it?', 'answer': 'egg', 'hint': 'Breakfast food', 'difficulty': 'Easy', 'points': 15},
    {'clue': 'I\'m tall when I\'m young, and I\'m short when I\'m old. What am I?', 'answer': 'candle', 'hint': 'Used for light', 'difficulty': 'Easy', 'points': 15},
    {'clue': 'What has a head, a tail, is brown, and has no legs?', 'answer': 'penny', 'hint': 'A coin', 'difficulty': 'Easy', 'points': 15},
    {'clue': 'What gets wet as it dries?', 'answer': 'towel', 'hint': 'Used after a shower', 'difficulty': 'Easy', 'points': 15},
    {'clue': 'What has a face and two hands but no arms or legs?', 'answer': 'clock', 'hint': 'Tells time', 'difficulty': 'Easy', 'points': 15},
    {'clue': 'What has words but never speaks?', 'answer': 'book', 'hint': 'You read it', 'difficulty': 'Easy', 'points': 15},
    {'clue': 'What can you catch but not throw?', 'answer': 'cold', 'hint': 'You might get sick', 'difficulty': 'Easy', 'points': 15},
    {'clue': 'What has a thumb and four fingers but is not alive?', 'answer': 'glove', 'hint': 'Worn on hands', 'difficulty': 'Easy', 'points': 15},
    {'clue': 'What has a ring but no finger?', 'answer': 'telephone', 'hint': 'It rings when someone calls', 'difficulty': 'Easy', 'points': 15},
    
    // Medium Puzzles (15)
    {'clue': 'What month of the year has 28 days?', 'answer': 'all months', 'hint': 'Think about every month', 'difficulty': 'Medium', 'points': 20},
    {'clue': 'What is full of holes but still holds water?', 'answer': 'sponge', 'hint': 'Used for cleaning', 'difficulty': 'Medium', 'points': 20},
    {'clue': 'What has an eye but cannot see?', 'answer': 'needle', 'hint': 'Used for sewing', 'difficulty': 'Medium', 'points': 20},
    {'clue': 'What building has the most stories?', 'answer': 'library', 'hint': 'Books have stories', 'difficulty': 'Medium', 'points': 20},
    {'clue': 'What is always in front of you but can\'t be seen?', 'answer': 'future', 'hint': 'Time-related', 'difficulty': 'Medium', 'points': 20},
    {'clue': 'What has a bottom at the top?', 'answer': 'legs', 'hint': 'Body parts', 'difficulty': 'Medium', 'points': 20},
    {'clue': 'What has a neck but no head?', 'answer': 'bottle', 'hint': 'You drink from it', 'difficulty': 'Medium', 'points': 20},
    {'clue': 'What can travel around the world while staying in a corner?', 'answer': 'stamp', 'hint': 'Postage', 'difficulty': 'Medium', 'points': 20},
    {'clue': 'What has cities, but no houses; forests, but no trees; and water, but no fish?', 'answer': 'map', 'hint': 'Shows places', 'difficulty': 'Medium', 'points': 20},
    {'clue': 'What has a thousand words but cannot speak?', 'answer': 'picture', 'hint': 'Worth a thousand words', 'difficulty': 'Medium', 'points': 20},
    {'clue': 'What is so fragile that saying its name breaks it?', 'answer': 'silence', 'hint': 'The opposite of noise', 'difficulty': 'Medium', 'points': 20},
    {'clue': 'What gets bigger the more you take away from it?', 'answer': 'hole', 'hint': 'Digging creates it', 'difficulty': 'Medium', 'points': 20},
    {'clue': 'What has a heart that doesn\'t beat?', 'answer': 'artichoke', 'hint': 'A vegetable', 'difficulty': 'Medium', 'points': 20},
    {'clue': 'What has one eye but cannot see?', 'answer': 'needle', 'hint': 'Used for sewing', 'difficulty': 'Medium', 'points': 20},
    {'clue': 'What has many keys but can\'t open a single lock?', 'answer': 'piano', 'hint': 'Musical instrument', 'difficulty': 'Medium', 'points': 20},
    
    // Hard Puzzles (15)
    {'clue': 'What question can you never answer yes to?', 'answer': 'are you asleep', 'hint': 'Think about sleeping', 'difficulty': 'Hard', 'points': 25},
    {'clue': 'I speak without a mouth and hear without ears. I have no body, but I come alive with wind. What am I?', 'answer': 'echo', 'hint': 'Sound reflection', 'difficulty': 'Hard', 'points': 25},
    {'clue': 'The more you take, the more you leave behind. What am I?', 'answer': 'footsteps', 'hint': 'Walking leaves traces', 'difficulty': 'Hard', 'points': 25},
    {'clue': 'I have branches, but no fruit, trunk or leaves. What am I?', 'answer': 'bank', 'hint': 'Financial institution', 'difficulty': 'Hard', 'points': 25},
    {'clue': 'What is seen in the middle of March and April that can\'t be seen at the beginning or end of either month?', 'answer': 'letter r', 'hint': 'Think about letters', 'difficulty': 'Hard', 'points': 25},
    {'clue': 'What has a head, a tail, but no body?', 'answer': 'coin', 'hint': 'Money', 'difficulty': 'Hard', 'points': 25},
    {'clue': 'What can fill a room but takes up no space?', 'answer': 'light', 'hint': 'Illumination', 'difficulty': 'Hard', 'points': 25},
    {'clue': 'What has a face and two hands but no arms?', 'answer': 'clock', 'hint': 'Tells time', 'difficulty': 'Hard', 'points': 25},
    {'clue': 'What has a spine but no bones?', 'answer': 'book', 'hint': 'Reading material', 'difficulty': 'Hard', 'points': 25},
    {'clue': 'What has a bottom at the top?', 'answer': 'leg', 'hint': 'Body part', 'difficulty': 'Hard', 'points': 25},
    {'clue': 'What is black when you buy it, red when you use it, and gray when you throw it away?', 'answer': 'charcoal', 'hint': 'Used for grilling', 'difficulty': 'Hard', 'points': 25},
    {'clue': 'What has a golden head and a golden tail but no body?', 'answer': 'goldfish', 'hint': 'Pet fish', 'difficulty': 'Hard', 'points': 25},
    {'clue': 'What has 13 hearts but no other organs?', 'answer': 'deck of cards', 'hint': 'Playing cards', 'difficulty': 'Hard', 'points': 25},
    {'clue': 'What is always coming but never arrives?', 'answer': 'tomorrow', 'hint': 'The next day', 'difficulty': 'Hard', 'points': 25},
    {'clue': 'What has a neck but no head?', 'answer': 'bottle', 'hint': 'Container', 'difficulty': 'Hard', 'points': 25},
    
    // Very Hard Puzzles (10)
    {'clue': 'I have cities, but no houses. I have mountains, but no trees. I have water, but no fish. What am I?', 'answer': 'map', 'hint': 'Shows geography', 'difficulty': 'Very Hard', 'points': 30},
    {'clue': 'What can you hold without ever touching?', 'answer': 'breath', 'hint': 'You can hold it', 'difficulty': 'Very Hard', 'points': 30},
    {'clue': 'The person who makes it has no need for it. The person who buys it has no use for it. The person who uses it can neither see nor feel it. What is it?', 'answer': 'coffin', 'hint': 'Funeral item', 'difficulty': 'Very Hard', 'points': 30},
    {'clue': 'What has a thousand words but cannot speak?', 'answer': 'dictionary', 'hint': 'Book of words', 'difficulty': 'Very Hard', 'points': 30},
    {'clue': 'What has a head and a tail but no body?', 'answer': 'coin', 'hint': 'Money', 'difficulty': 'Very Hard', 'points': 30},
    {'clue': 'What has a ring but no finger?', 'answer': 'telephone', 'hint': 'Communication device', 'difficulty': 'Very Hard', 'points': 30},
    {'clue': 'What has a face and two hands but no arms?', 'answer': 'watch', 'hint': 'Timepiece', 'difficulty': 'Very Hard', 'points': 30},
    {'clue': 'What has a heart that doesn\'t beat?', 'answer': 'artichoke', 'hint': 'Vegetable', 'difficulty': 'Very Hard', 'points': 30},
    {'clue': 'What has a spine but no bones?', 'answer': 'book', 'hint': 'Reading material', 'difficulty': 'Very Hard', 'points': 30},
    {'clue': 'What has a bottom at the top?', 'answer': 'leg', 'hint': 'Body part', 'difficulty': 'Very Hard', 'points': 30},
  ];
  
  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.elasticOut),
    );
    _loadPuzzles();
  }
  
  void _loadPuzzles() {
    // Shuffle puzzles and take 10
    final shuffled = List<Map<String, dynamic>>.from(_puzzleCollection);
    shuffled.shuffle();
    _puzzles = shuffled.take(10).map((puzzle) {
      final options = _generateOptions(puzzle['answer'] as String);
      return {
        'clue': puzzle['clue'],
        'options': options,
        'answer': options.indexOf(puzzle['answer']),
        'points': puzzle['points'],
        'difficulty': puzzle['difficulty'],
        'hint': puzzle['hint'],
      };
    }).toList();
  }
  
  List<String> _generateOptions(String correctAnswer) {
    const List<String> commonWrongAnswers = [
      'keyboard', 'door', 'window', 'table', 'chair', 'book', 'pen', 'paper',
      'egg', 'candle', 'sponge', 'towel', 'penny', 'needle', 'clock', 'library',
      'telephone', 'cold', 'computer', 'phone', 'television', 'radio', 'future',
      'bottle', 'echo', 'footsteps', 'artichoke', 'stamp', 'map', 'picture',
      'bank', 'coin', 'mirror', 'shadow', 'time', 'love', 'knowledge', 'silence',
      'hole', 'piano', 'light', 'charcoal', 'goldfish', 'deck of cards', 'tomorrow',
      'breath', 'coffin', 'dictionary', 'watch', 'glove'
    ];
    
    final List<String> options = [correctAnswer];
    
    while (options.length < 4) {
      final String wrong = commonWrongAnswers[_random.nextInt(commonWrongAnswers.length)];
      if (!options.contains(wrong) && wrong != correctAnswer) {
        options.add(wrong);
      }
    }
    options.shuffle();
    return options;
  }
  
  void _checkAnswer(int index) {
    if (_showResult || _isGameOver) return;
    
    final bool isCorrect = index == (_puzzles[_currentIndex]['answer'] as int);
    
    setState(() {
      _showResult = true;
      _selectedAnswer = index;
      _questionsAnswered++;
      
      if (isCorrect) {
        int points = (_puzzles[_currentIndex]['points'] as int) * _multiplier;
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
      if (mounted) {
        if (_lives <= 0) {
          _endGame(false);
        } else if (_currentIndex + 1 >= _puzzles.length) {
          _endGame(true);
        } else {
          setState(() {
            _currentIndex++;
            _showResult = false;
            _selectedAnswer = null;
          });
        }
      }
    });
  }
  
  void _showHint() {
    final String hint = _puzzles[_currentIndex]['hint'] as String;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.lightbulb, color: AppColors.gold),
            const SizedBox(width: 10),
            Expanded(child: Text('💡 Hint: $hint')),
          ],
        ),
        backgroundColor: AppColors.neonBlue,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  void _endGame(bool victory) async {
    _isGameOver = true;
    
    if (victory) {
      await Provider.of<GameProvider>(context, listen: false).addScore(_score, 'Puzzle');
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => GameResultScreen(
              score: _score,
              isVictory: true,
              subject: 'Puzzle',
              questionsAnswered: _questionsAnswered,
              totalQuestions: _puzzles.length,
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
              subject: 'Puzzle',
              questionsAnswered: _questionsAnswered,
              totalQuestions: _puzzles.length,
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
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_puzzles.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    final Map<String, dynamic> q = _puzzles[_currentIndex];
    final String difficulty = q['difficulty'] as String;
    
    Color getDifficultyColor() {
      switch (difficulty) {
        case 'Easy': return AppColors.mintGreen;
        case 'Medium': return AppColors.warningOrange;
        case 'Hard': return AppColors.mathOrange;
        case 'Very Hard': return AppColors.errorRed;
        default: return AppColors.lavenderPurple;
      }
    }
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.lavenderPurple.withValues(alpha: 0.15), AppColors.backgroundLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(q, difficulty, getDifficultyColor()),
              const SizedBox(height: 20),
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: QuestionCard(
                        question: q['clue'],
                        currentQuestion: _currentIndex + 1,
                        totalQuestions: _puzzles.length,
                        points: (q['points'] as int) * _multiplier,
                      ),
                    ),
                  );
                },
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
                      final List<Color> colors = [
                        AppColors.lavenderPurple,
                        AppColors.mintGreen,
                        AppColors.warningOrange,
                        AppColors.bubblegumPink,
                      ];
                      return AnswerButton(
                        text: (q['options'][i] as String).toUpperCase(),
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
                    AppColors.lavenderPurple,
                    AppColors.mintGreen,
                    AppColors.warningOrange,
                    AppColors.bubblegumPink,
                  ],
                  numberOfParticles: 50,
                  gravity: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> q, String difficulty, Color difficultyColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.lavenderPurple, Color(0xFFB388FF)],
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
                '🧩 Puzzle Challenge',
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
                      '$_score',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.lavenderPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: difficultyColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      difficulty == 'Easy' ? Icons.sentiment_satisfied :
                      difficulty == 'Medium' ? Icons.sentiment_neutral :
                      difficulty == 'Hard' ? Icons.sentiment_very_dissatisfied :
                      Icons.psychology,
                      size: 14,
                      color: difficultyColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      difficulty,
                      style: TextStyle(color: difficultyColor, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _showHint,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lightbulb, color: AppColors.gold, size: 14),
                      SizedBox(width: 4),
                      Text('Hint', style: TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
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
                size: 22,
              )),
              const Spacer(),
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
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
              value: (_currentIndex + 1) / _puzzles.length,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Puzzle ${_currentIndex + 1} of ${_puzzles.length}',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}