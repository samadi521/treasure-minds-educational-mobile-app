import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../../widgets/answer_button.dart';
import '../../widgets/question_card.dart';

class DailyQuizScreen extends StatefulWidget {
  const DailyQuizScreen({super.key});

  @override
  State<DailyQuizScreen> createState() => _DailyQuizScreenState();
}

class _DailyQuizScreenState extends State<DailyQuizScreen> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _slideController;
  
  int _currentDay = 1;
  int _streak = 0;
  int _totalCoins = 0;
  bool _isQuizActive = false;
  int _currentQuestionIndex = 0;
  int _quizScore = 0;
  int? _selectedAnswer;
  bool _showResult = false;
  
  // Daily challenge data
  final List<Map<String, dynamic>> _dailyChallenges = [
    {
      'day': 1, 
      'title': 'Math Challenge', 
      'reward': 50, 
      'completed': false, 
      'icon': Icons.calculate, 
      'color': AppColors.mathOrange, 
      'description': 'Solve 5 math problems',
      'difficulty': 'Easy',
      'questions': [
        {'text': '5 + 3 = ?', 'options': ['6', '7', '8', '9'], 'answer': 2, 'points': 10},
        {'text': '10 - 4 = ?', 'options': ['5', '6', '7', '8'], 'answer': 1, 'points': 10},
        {'text': '3 × 4 = ?', 'options': ['10', '11', '12', '13'], 'answer': 2, 'points': 10},
        {'text': '15 ÷ 3 = ?', 'options': ['3', '4', '5', '6'], 'answer': 2, 'points': 10},
        {'text': 'What is 7 + 8?', 'options': ['14', '15', '16', '17'], 'answer': 1, 'points': 10},
      ]
    },
    {
      'day': 2, 
      'title': 'Word Puzzle', 
      'reward': 50, 
      'completed': false, 
      'icon': Icons.menu_book, 
      'color': AppColors.englishGreen, 
      'description': 'Complete 5 sentences',
      'difficulty': 'Easy',
      'questions': [
        {'text': 'What is the synonym of "big"?', 'options': ['Small', 'Tiny', 'Large', 'Little'], 'answer': 2, 'points': 10},
        {'text': 'She ___ to school every day.', 'options': ['go', 'goes', 'going', 'went'], 'answer': 1, 'points': 10},
        {'text': 'What is the opposite of "hot"?', 'options': ['Warm', 'Cold', 'Cool', 'Fire'], 'answer': 1, 'points': 10},
        {'text': 'The ___ is shining in the sky.', 'options': ['Moon', 'Stars', 'Sun', 'Clouds'], 'answer': 2, 'points': 10},
        {'text': 'I ___ a student.', 'options': ['is', 'am', 'are', 'be'], 'answer': 1, 'points': 10},
      ]
    },
    {
      'day': 3, 
      'title': 'Science Quiz', 
      'reward': 75, 
      'completed': false, 
      'icon': Icons.science, 
      'color': AppColors.sciencePurple, 
      'description': 'Answer 5 science questions',
      'difficulty': 'Medium',
      'questions': [
        {'text': 'What is the closest star to Earth?', 'options': ['Moon', 'Sun', 'Mars', 'Venus'], 'answer': 1, 'points': 15},
        {'text': 'What gas do humans breathe in?', 'options': ['CO2', 'O2', 'N2', 'H2'], 'answer': 1, 'points': 15},
        {'text': 'What is H2O?', 'options': ['Salt', 'Water', 'Oxygen', 'Hydrogen'], 'answer': 1, 'points': 15},
        {'text': 'What planet is known as the Red Planet?', 'options': ['Venus', 'Mars', 'Jupiter', 'Saturn'], 'answer': 1, 'points': 15},
        {'text': 'What is the hardest natural substance?', 'options': ['Iron', 'Gold', 'Diamond', 'Platinum'], 'answer': 2, 'points': 15},
      ]
    },
    {
      'day': 4, 
      'title': 'Memory Game', 
      'reward': 75, 
      'completed': false, 
      'icon': Icons.psychology, 
      'color': Colors.blue, 
      'description': 'Test your memory with patterns',
      'difficulty': 'Medium',
      'questions': [
        {'text': 'What comes after Monday?', 'options': ['Sunday', 'Tuesday', 'Wednesday', 'Friday'], 'answer': 1, 'points': 15},
        {'text': 'How many days are in a week?', 'options': ['5', '6', '7', '8'], 'answer': 2, 'points': 15},
        {'text': 'What is the 3rd month of the year?', 'options': ['January', 'February', 'March', 'April'], 'answer': 2, 'points': 15},
        {'text': 'How many sides does a triangle have?', 'options': ['2', '3', '4', '5'], 'answer': 1, 'points': 15},
        {'text': 'What color is the sky on a clear day?', 'options': ['Green', 'Red', 'Blue', 'Yellow'], 'answer': 2, 'points': 15},
      ]
    },
    {
      'day': 5, 
      'title': 'Logic Puzzle', 
      'reward': 100, 
      'completed': false, 
      'icon': Icons.extension, 
      'color': AppColors.errorRed, 
      'description': 'Solve 5 logical problems',
      'difficulty': 'Hard',
      'questions': [
        {'text': 'If a pen costs \$2 and a notebook costs \$5, how much for 2 pens and 1 notebook?', 'options': ['\$7', '\$8', '\$9', '\$10'], 'answer': 2, 'points': 20},
        {'text': 'Tom is taller than Jerry. Jerry is taller than Spike. Who is the tallest?', 'options': ['Tom', 'Jerry', 'Spike', 'Cannot tell'], 'answer': 0, 'points': 20},
        {'text': 'If 2 = 6, 3 = 12, 4 = 20, then 5 = ?', 'options': ['25', '30', '35', '40'], 'answer': 1, 'points': 20},
        {'text': 'A bird flies 10 meters north, then 10 meters south. Where is it?', 'options': ['North', 'South', 'Start', 'East'], 'answer': 2, 'points': 20},
        {'text': 'If all Bloops are Razzies and all Razzies are Lazzies, then all Bloops are definitely Lazzies?', 'options': ['Yes', 'No', 'Maybe', 'Never'], 'answer': 0, 'points': 20},
      ]
    },
    {
      'day': 6, 
      'title': 'Treasure Hunt', 
      'reward': 100, 
      'completed': false, 
      'icon': Icons.map, 
      'color': AppColors.adventureTeal, 
      'description': 'Find the hidden treasure by answering clues',
      'difficulty': 'Hard',
      'questions': [
        {'text': 'I have keys but no locks. I have space but no room. What am I?', 'options': ['Door', 'Keyboard', 'Box', 'Safe'], 'answer': 1, 'points': 20},
        {'text': 'What has to be broken before you can use it?', 'options': ['Egg', 'Glass', 'Toy', 'Phone'], 'answer': 0, 'points': 20},
        {'text': 'I\'m tall when I\'m young, short when I\'m old. What am I?', 'options': ['Tree', 'Candle', 'Person', 'Building'], 'answer': 1, 'points': 20},
        {'text': 'What has a face and two hands but no arms?', 'options': ['Clock', 'Watch', 'Calendar', 'Mirror'], 'answer': 0, 'points': 20},
        {'text': 'What has words but never speaks?', 'options': ['Book', 'Letter', 'Email', 'Sign'], 'answer': 0, 'points': 20},
      ]
    },
    {
      'day': 7, 
      'title': 'Boss Level', 
      'reward': 200, 
      'completed': false, 
      'icon': Icons.emoji_events, 
      'color': AppColors.gold, 
      'description': 'Ultimate challenge! Answer all correctly',
      'difficulty': 'Very Hard',
      'questions': [
        {'text': 'What is the square root of 144?', 'options': ['10', '11', '12', '13'], 'answer': 2, 'points': 30},
        {'text': 'What does "benevolent" mean?', 'options': ['Evil', 'Kind', 'Angry', 'Lazy'], 'answer': 1, 'points': 30},
        {'text': 'What is the chemical symbol for Gold?', 'options': ['Go', 'Gd', 'Au', 'Ag'], 'answer': 2, 'points': 30},
        {'text': 'What is Newton\'s first law also known as?', 'options': ['Law of Acceleration', 'Law of Inertia', 'Law of Action-Reaction', 'Law of Gravity'], 'answer': 1, 'points': 30},
        {'text': 'If x + 7 = 15, what is x?', 'options': ['6', '7', '8', '9'], 'answer': 2, 'points': 30},
      ]
    },
  ];

  List<Map<String, dynamic>> _currentQuestions = [];
  
  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _loadProgress();
  }
  
  void _loadProgress() {
    // Load saved progress (in real app, this would come from SharedPreferences)
    _streak = 3;
    _totalCoins = 250;
    // Mark some days as completed for demo
    _dailyChallenges[0]['completed'] = true;
    _dailyChallenges[1]['completed'] = true;
  }
  
  void _startDailyQuiz(int dayIndex) {
    setState(() {
      _currentDay = dayIndex + 1;
      _currentQuestions = List<Map<String, dynamic>>.from(_dailyChallenges[dayIndex]['questions']);
      _isQuizActive = true;
      _currentQuestionIndex = 0;
      _quizScore = 0;
      _selectedAnswer = null;
      _showResult = false;
    });
  }
  
  void _checkAnswer(int index) {
    if (_showResult) return;
    
    final bool isCorrect = index == (_currentQuestions[_currentQuestionIndex]['answer'] as int);
    
    setState(() {
      _showResult = true;
      _selectedAnswer = index;
      
      if (isCorrect) {
        int points = _currentQuestions[_currentQuestionIndex]['points'] as int;
        _quizScore += points;
        _confettiController.play();
        _slideController.forward().then((_) => _slideController.reverse());
      }
    });
    
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (_currentQuestionIndex + 1 >= _currentQuestions.length) {
        _completeDailyQuiz();
      } else {
        setState(() {
          _currentQuestionIndex++;
          _showResult = false;
          _selectedAnswer = null;
        });
      }
    });
  }
  
  void _completeDailyQuiz() async {
    final challenge = _dailyChallenges[_currentDay - 1];
    final reward = challenge['reward'] as int;
    final totalScore = _quizScore + reward;
    
    // Add bonus for perfect score
    int perfectBonus = 0;
    if (_quizScore == _currentQuestions.length * 30) {
      perfectBonus = 100;
    }
    
    final finalScore = totalScore + perfectBonus;
    
    // Update game provider
    await Provider.of<GameProvider>(context, listen: false).addScore(finalScore, 'Daily Quiz');
    
    // Mark as completed
    challenge['completed'] = true;
    
    // Update streak
    if (mounted) {
      setState(() {
        _streak++;
        _totalCoins += reward + perfectBonus;
        _isQuizActive = false;
      });
    }
    
    // Show completion dialog
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          title: const Text('Daily Challenge Complete!', style: TextStyle(color: AppColors.gold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, size: 60, color: AppColors.gold),
              const SizedBox(height: 10),
              Text('Score: $_quizScore', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Reward: +$reward Coins', style: const TextStyle(color: AppColors.mintGreen)),
              if (perfectBonus > 0)
                Text('Perfect Bonus: +$perfectBonus!', style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('Total Earned: $finalScore', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text('Streak: $_streak days!', style: const TextStyle(color: AppColors.warningOrange)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: _isQuizActive ? _buildQuizScreen() : _buildChallengeScreen(),
    );
  }
  
  Widget _buildChallengeScreen() {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildStreakCalendar(),
                const SizedBox(height: 20),
                _buildTodaySpecialCard(),
                const SizedBox(height: 20),
                _buildWeeklyChallenges(),
                const SizedBox(height: 20),
                _buildSpecialRewardsBanner(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.warningOrange, AppColors.mathOrange],
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
                "Daily Challenge",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(
                      "$_streak",
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
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Coins Earned',
                  style: TextStyle(color: Colors.white70),
                ),
                Row(
                  children: [
                    const Icon(Icons.monetization_on, color: AppColors.gold),
                    const SizedBox(width: 5),
                    Text(
                      "$_totalCoins",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStreakCalendar() {
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
          const Text(
            '📅 Weekly Streak',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.neonPurple,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              final bool isActive = index < _streak;
              final bool isToday = index == _streak && _streak < 7;
              
              return Column(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isActive
                          ? const LinearGradient(
                              colors: [AppColors.gold, AppColors.warningOrange],
                            )
                          : (isToday
                              ? LinearGradient(
                                  colors: [AppColors.warningOrange.withValues(alpha: 0.5), AppColors.gold.withValues(alpha: 0.3)],
                                )
                              : const LinearGradient(
                                  colors: [Colors.grey, Colors.grey],
                                )),
                      border: isToday
                          ? Border.all(color: AppColors.gold, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isActive || isToday ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (isActive)
                    const Icon(Icons.check_circle, color: AppColors.mintGreen, size: 14),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTodaySpecialCard() {
    final todayChallenge = _dailyChallenges[_streak];
    final isCompleted = todayChallenge['completed'] as bool;
    
    return GestureDetector(
      onTap: isCompleted ? null : () => _startDailyQuiz(_streak),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [todayChallenge['color'] as Color, (todayChallenge['color'] as Color).withValues(alpha: 0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: (todayChallenge['color'] as Color).withValues(alpha: 0.3),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Challenge",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    todayChallenge['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    todayChallenge['description'],
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          "Reward: ${todayChallenge['reward']} Coins",
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!isCompleted)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(todayChallenge['icon'], color: Colors.white, size: 40),
              )
            else
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.mintGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 30),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildWeeklyChallenges() {
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
          const Text(
            '📋 Weekly Challenges',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.neonPurple,
            ),
          ),
          const SizedBox(height: 15),
          ..._dailyChallenges.asMap().entries.map((entry) {
            final index = entry.key;
            final challenge = entry.value;
            final isCompleted = challenge['completed'] as bool;
            final isLocked = index > _streak;
            final isCurrent = index == _streak;
            
            return _buildChallengeCard(
              day: index + 1,
              title: challenge['title'],
              reward: challenge['reward'],
              icon: challenge['icon'],
              color: challenge['color'],
              isCompleted: isCompleted,
              isLocked: isLocked,
              isCurrent: isCurrent,
              onTap: !isLocked && !isCompleted ? () => _startDailyQuiz(index) : null,
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildChallengeCard({
    required int day,
    required String title,
    required int reward,
    required IconData icon,
    required Color color,
    required bool isCompleted,
    required bool isLocked,
    required bool isCurrent,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrent ? color.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: isCurrent ? Border.all(color: color, width: 2) : null,
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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Day $day",
                      style: TextStyle(
                        fontSize: 12,
                        color: isCompleted ? AppColors.mintGreen : (isCurrent ? color : Colors.grey.shade600),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "ACTIVE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    if (isLocked) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.lock, size: 12, color: Colors.grey),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.gold, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      "$reward Coins",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isCompleted)
            const Icon(Icons.check_circle, color: AppColors.mintGreen, size: 32)
          else if (!isLocked && onTap != null)
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: const Size(70, 35),
              ),
              child: const Text("Start", style: TextStyle(fontSize: 12)),
            )
          else if (isLocked)
            const Icon(Icons.lock, color: Colors.grey, size: 28),
        ],
      ),
    );
  }
  
  Widget _buildSpecialRewardsBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gold, AppColors.warningOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            "Complete All 7 Days To Unlock!",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSpecialRewardItem(Icons.card_giftcard, "500 Coins", Colors.white),
              _buildSpecialRewardItem(Icons.emoji_events, "Gold Badge", Colors.white),
              _buildSpecialRewardItem(Icons.key, "3 Keys", Colors.white),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildSpecialRewardItem(IconData icon, String text, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
  
  Widget _buildQuizScreen() {
    final q = _currentQuestions[_currentQuestionIndex];
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [(_dailyChallenges[_currentDay - 1]['color'] as Color).withValues(alpha: 0.15), AppColors.backgroundLight],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildQuizHeader(),
              const SizedBox(height: 20),
              AnimatedBuilder(
                animation: _slideController,
                builder: (context, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.3, 0),
                      end: Offset.zero,
                    ).animate(_slideController),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: QuestionCard(
                        question: q['text'],
                        currentQuestion: _currentQuestionIndex + 1,
                        totalQuestions: _currentQuestions.length,
                        points: q['points'] as int,
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
                      final colors = [
                        _dailyChallenges[_currentDay - 1]['color'] as Color,
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
                    AppColors.mintGreen,
                    AppColors.warningOrange,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildQuizHeader() {
    final challenge = _dailyChallenges[_currentDay - 1];
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [challenge['color'] as Color, (challenge['color'] as Color).withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
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
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      _isQuizActive = false;
                    });
                  }
                },
              ),
              Text(
                challenge['title'],
                style: const TextStyle(
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
                      "$_quizScore",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.flag, size: 14, color: Colors.white),
                const SizedBox(width: 5),
                Text(
                  "Day ${_dailyChallenges[_currentDay - 1]['day']} Challenge",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _currentQuestions.length,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "Question ${_currentQuestionIndex + 1} of ${_currentQuestions.length}",
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}