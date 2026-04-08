import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';
import '../adventure/adventure_level_map.dart';
import '../challenges/timer_challenge_screen.dart';
import '../challenges/daily_quiz_screen.dart';
import '../subject/subject_selection_screen.dart';
import '../puzzle/puzzle_screen.dart';
import '../games/math_game_screen.dart';
import '../games/english_game_screen.dart';
import '../games/science_game_screen.dart';

class GameModeSelectionScreen extends StatefulWidget {
  const GameModeSelectionScreen({super.key});

  @override
  State<GameModeSelectionScreen> createState() => _GameModeSelectionScreenState();
}

class _GameModeSelectionScreenState extends State<GameModeSelectionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Choose Game Mode",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(blurRadius: 4, color: Colors.black26)],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.rainbowGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.rainbowGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildModeGrid(),
                  const SizedBox(height: 24),
                  _buildQuickPlaySection(),
                  const SizedBox(height: 24),
                  _buildComingSoonSection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
              gradient: const LinearGradient(
                colors: [AppColors.gold, AppColors.warningOrange],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.gamepad, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Multiple Ways to Learn!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neonPurple,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Choose your favorite way to play and learn',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().slideX(begin: -0.2, end: 0).fadeIn();
  }

  Widget _buildModeGrid() {
    final gameModes = [
      GameMode(
        id: 'adventure',
        title: 'Adventure Mode',
        description: 'Explore levels, collect keys, and unlock treasures!',
        longDescription: 'Journey through 8 exciting levels. Each level features a different subject. Collect keys to unlock the final treasure!',
        icon: Icons.map,
        gradientColors: const [Color(0xFF009688), Color(0xFF4ECDC4)],
        color: AppColors.adventureTeal,
        emoji: '🗺️',
        xpReward: 100,
        timeEstimate: '15-20 min',
      ),
      GameMode(
        id: 'timer',
        title: 'Timer Challenge',
        description: 'Answer as many questions as you can in 60 seconds!',
        longDescription: 'Race against the clock! Answer questions quickly for bonus points. Test your speed and knowledge!',
        icon: Icons.timer,
        gradientColors: const [Color(0xFFFF9F1C), Color(0xFFFF6B6B)],
        color: AppColors.warningOrange,
        emoji: '⚡',
        xpReward: 75,
        timeEstimate: '1-2 min',
      ),
      GameMode(
        id: 'daily',
        title: 'Daily Quiz',
        description: 'Complete daily challenges and earn bonus rewards!',
        longDescription: 'New challenges every day! Complete all 7 days to earn special rewards and keep your streak alive!',
        icon: Icons.calendar_today,
        gradientColors: const [Color(0xFFFF9800), Color(0xFFFFD700)],
        color: AppColors.gold,
        emoji: '📅',
        xpReward: 50,
        timeEstimate: '5-10 min',
      ),
      GameMode(
        id: 'subject',
        title: 'Subject Practice',
        description: 'Practice Math, English, or Science individually',
        longDescription: 'Focus on one subject at a time. Choose your grade level and difficulty. Perfect for targeted learning!',
        icon: Icons.school,
        gradientColors: const [Color(0xFF9C27B0), Color(0xFFCE93D8)],
        color: AppColors.sciencePurple,
        emoji: '📚',
        xpReward: 60,
        timeEstimate: '10-15 min',
      ),
      GameMode(
        id: 'puzzle',
        title: 'Puzzle Challenge',
        description: 'Solve fun riddles and brain teasers!',
        longDescription: 'Test your wit with challenging puzzles! From easy riddles to mind-bending brain teasers. Can you solve them all?',
        icon: Icons.psychology,
        gradientColors: const [Color(0xFF9B5DE5), Color(0xFFB388FF)],
        color: AppColors.lavenderPurple,
        emoji: '🧩',
        xpReward: 80,
        timeEstimate: '5-15 min',
      ),
      GameMode(
        id: 'quick',
        title: 'Quick Play',
        description: 'Jump into random questions for quick practice!',
        longDescription: 'Short on time? Play a quick 5-question game from random subjects. Perfect for practice on the go!',
        icon: Icons.flash_on,
        gradientColors: const [Color(0xFF20BF6B), Color(0xFF78E08F)],
        color: AppColors.mintGreen,
        emoji: '⚡',
        xpReward: 30,
        timeEstimate: '2-3 min',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: gameModes.length,
      itemBuilder: (context, index) {
        return _buildModeCard(gameModes[index]).animate().fadeIn(delay: (50 * index).ms).slideY(begin: 0.1, end: 0);
      },
    );
  }

  Widget _buildModeCard(GameMode mode) {
    return GestureDetector(
      onTap: () => _navigateToMode(context, mode.id),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: mode.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: mode.color.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -15,
              left: -15,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Emoji and Title
                  Row(
                    children: [
                      Text(mode.emoji, style: const TextStyle(fontSize: 32)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, size: 10, color: Colors.white),
                            const SizedBox(width: 2),
                            Text(
                              mode.timeEstimate,
                              style: const TextStyle(fontSize: 9, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mode.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black26)],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    mode.description,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, size: 10, color: AppColors.gold),
                            const SizedBox(width: 2),
                            Text(
                              '+${mode.xpReward} XP',
                              style: const TextStyle(fontSize: 9, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: mode.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickPlaySection() {
    final quickSubjects = [
      {'name': 'Math', 'icon': Icons.calculate, 'color': AppColors.mathOrange, 'emoji': '🧮'},
      {'name': 'English', 'icon': Icons.menu_book, 'color': AppColors.englishGreen, 'emoji': '📚'},
      {'name': 'Science', 'icon': Icons.science, 'color': AppColors.sciencePurple, 'emoji': '🔬'},
      {'name': 'Mixed', 'icon': Icons.shuffle, 'color': AppColors.neonBlue, 'emoji': '🎲'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.flash_on, color: AppColors.gold),
              SizedBox(width: 8),
              Text(
                'Quick Play',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
              SizedBox(width: 8),
              Text(
                '5 questions · 2 min',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: quickSubjects.map((subject) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => _startQuickPlay(subject['name'] as String),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          (subject['color'] as Color).withValues(alpha: 0.2),
                          (subject['color'] as Color).withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: (subject['color'] as Color).withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        Text(subject['emoji'] as String, style: const TextStyle(fontSize: 24)),
                        const SizedBox(height: 4),
                        Text(
                          subject['name'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: subject['color'] as Color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.1, end: 0).fadeIn(delay: 300.ms);
  }

  Widget _buildComingSoonSection() {
    final comingSoonModes = [
      {'name': 'Multiplayer', 'icon': Icons.people, 'color': AppColors.neonGreen, 'description': 'Play with friends!', 'comingSoon': true},
      {'name': 'Weekly Tournament', 'icon': Icons.emoji_events, 'color': AppColors.gold, 'description': 'Compete globally!', 'comingSoon': true},
      {'name': 'Survival Mode', 'icon': Icons.shield, 'color': AppColors.errorRed, 'description': 'Endless challenges!', 'comingSoon': true},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.rocket, color: AppColors.neonPurple),
              SizedBox(width: 8),
              Text(
                'Coming Soon',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: comingSoonModes.map((mode) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (mode['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: (mode['color'] as Color).withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Icon(mode['icon'] as IconData, size: 28, color: mode['color'] as Color),
                          Positioned(
                            top: -5,
                            right: -5,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: AppColors.gold,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.lock, size: 10, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        mode['name'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: mode['color'] as Color,
                        ),
                      ),
                      Text(
                        mode['description'] as String,
                        style: const TextStyle(fontSize: 9, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.1, end: 0).fadeIn(delay: 400.ms);
  }

  void _navigateToMode(BuildContext context, String modeId) {
    switch (modeId) {
      case 'adventure':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AdventureLevelMap()),
        );
        break;
      case 'timer':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TimerChallengeScreen()),
        );
        break;
      case 'daily':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DailyQuizScreen()),
        );
        break;
      case 'subject':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SubjectSelectionScreen()),
        );
        break;
      case 'puzzle':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PuzzleScreen()),
        );
        break;
      case 'quick':
        _showQuickPlayDialog(context);
        break;
    }
  }

  void _startQuickPlay(String subject) {
    Widget gameScreen;
    switch (subject) {
      case 'Math':
        gameScreen = const MathGameScreen();
        break;
      case 'English':
        gameScreen = const EnglishGameScreen();
        break;
      case 'Science':
        gameScreen = const ScienceGameScreen();
        break;
      default:
        // Mixed subject - random selection
        final subjects = [const MathGameScreen(), const EnglishGameScreen(), const ScienceGameScreen()];
        gameScreen = subjects[DateTime.now().millisecondsSinceEpoch % 3];
    }
    
    Navigator.push(context, MaterialPageRoute(builder: (_) => gameScreen));
  }

  void _showQuickPlayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Text('Quick Play'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.flash_on, size: 50, color: AppColors.gold),
            SizedBox(height: 10),
            Text(
              'Choose a subject to start a quick 5-question game!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _startQuickPlay('Mixed');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonGreen,
            ),
            child: const Text('Start Random'),
          ),
        ],
      ),
    );
  }
}

class GameMode {
  final String id;
  final String title;
  final String description;
  final String longDescription;
  final IconData icon;
  final List<Color> gradientColors;
  final Color color;
  final String emoji;
  final int xpReward;
  final String timeEstimate;

  GameMode({
    required this.id,
    required this.title,
    required this.description,
    required this.longDescription,
    required this.icon,
    required this.gradientColors,
    required this.color,
    required this.emoji,
    required this.xpReward,
    required this.timeEstimate,
  });
}