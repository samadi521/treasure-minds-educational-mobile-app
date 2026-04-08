import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../../providers/auth_provider.dart';
import '../games/math_game_screen.dart';
import '../games/english_game_screen.dart';
import '../games/science_game_screen.dart';

class LevelDetailScreen extends StatefulWidget {
  final int levelId;
  final String levelName;
  final String subject;
  final int gradeNumber;
  final String gradeName;
  
  const LevelDetailScreen({
    super.key,
    required this.levelId,
    required this.levelName,
    required this.subject,
    required this.gradeNumber,
    required this.gradeName,
  });

  @override
  State<LevelDetailScreen> createState() => _LevelDetailScreenState();
}

class _LevelDetailScreenState extends State<LevelDetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  // Level details based on ID
  late Map<String, dynamic> _levelData;
  
  @override
  void initState() {
    super.initState();
    _levelData = _getLevelData();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
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
    final auth = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: CustomScrollView(
            slivers: [
              _buildSliverHeader(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildLevelStatsCard(),
                      const SizedBox(height: 16),
                      _buildTopicsCard(),
                      const SizedBox(height: 16),
                      _buildRewardsCard(),
                      const SizedBox(height: 16),
                      _buildRequirementsCard(),
                      const SizedBox(height: 16),
                      _buildLeaderboardPreview(),
                      const SizedBox(height: 16),
                      _buildStartButton(game, auth),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverHeader() {
    final difficultyColor = _getDifficultyColor(_levelData['difficulty']);
    
    return SliverAppBar(
      expandedHeight: 280,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [difficultyColor, difficultyColor.withValues(alpha: 0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(height: 60),
                  // Level Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _levelData['emoji'],
                        style: const TextStyle(fontSize: 50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Level Name
                  Text(
                    widget.levelName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black26)],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Level ID and Difficulty
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Level ${widget.levelId}',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: difficultyColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _levelData['difficulty'],
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Subject Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_getSubjectIcon(), size: 16, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          '${widget.subject} • ${widget.gradeName}',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildLevelStatsCard() {
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
              Icon(Icons.insights, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Level Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(Icons.timer, _levelData['estimatedTime'], 'Est. Time', Colors.orange),
              _buildStatItem(Icons.quiz, _levelData['questionCount'], 'Questions', AppColors.mathOrange),
              _buildStatItem(Icons.star, _levelData['passingScore'], 'Pass Score', AppColors.gold),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              _levelData['description'],
              style: const TextStyle(fontSize: 14, height: 1.4),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTopicsCard() {
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
              Icon(Icons.topic, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Topics Covered',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: (_levelData['topics'] as List<String>).map((topic) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_getDifficultyColor(_levelData['difficulty']).withValues(alpha: 0.1), Colors.transparent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: _getDifficultyColor(_levelData['difficulty']).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 14, color: _getDifficultyColor(_levelData['difficulty'])),
                    const SizedBox(width: 6),
                    Text(
                      topic,
                      style: TextStyle(
                        fontSize: 12,
                        color: _getDifficultyColor(_levelData['difficulty']),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
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
              _buildRewardItem(Icons.star, '${_levelData['xpReward']} XP', 'Experience Points', AppColors.gold),
              _buildRewardItem(Icons.monetization_on, '${_levelData['coinReward']}', 'Coins', AppColors.gold),
              _buildRewardItem(Icons.key, '${_levelData['keyReward']}', 'Keys', AppColors.gold),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt, color: AppColors.gold, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Bonus: ${_levelData['bonusReward']}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
          textAlign: TextAlign.center,
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
          const SizedBox(height: 16),
          _buildRequirementItem(
            'Complete previous level',
            widget.levelId > 1,
            Icons.check_circle,
            Icons.lock,
          ),
          const SizedBox(height: 12),
          _buildRequirementItem(
            'Minimum ${_levelData['minScore']} points in previous level',
            true,
            Icons.check_circle,
            Icons.star,
          ),
          const SizedBox(height: 12),
          _buildRequirementItem(
            'Age requirement: ${_levelData['ageRequirement']}+',
            true,
            Icons.check_circle,
            Icons.cake,
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text, bool isMet, IconData metIcon, IconData unmetIcon) {
    return Row(
      children: [
        Icon(
          isMet ? metIcon : unmetIcon,
          color: isMet ? AppColors.mintGreen : Colors.grey,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: isMet ? Colors.black87 : Colors.grey,
              decoration: isMet ? TextDecoration.none : TextDecoration.lineThrough,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardPreview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.neonBlue.withValues(alpha: 0.1), AppColors.neonPurple.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neonBlue.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.neonBlue.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_events, color: AppColors.neonBlue, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Level Leaderboard',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Compete with others who have completed this level',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.neonBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'View',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(GameProvider game, AuthProvider auth) {
    final isUnlocked = widget.levelId <= 3; // For demo, first 3 levels unlocked
    
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: isUnlocked
            ? () {
                Widget gameScreen;
                switch (widget.subject) {
                  case 'Math':
                    gameScreen = MathGameScreen(
                      gradeLevel: widget.gradeNumber,
                      level: widget.levelId,
                    );
                    break;
                  case 'English':
                    gameScreen = EnglishGameScreen(
                      gradeLevel: widget.gradeNumber,
                      level: widget.levelId,
                    );
                    break;
                  case 'Science':
                    gameScreen = ScienceGameScreen(
                      gradeLevel: widget.gradeNumber,
                      level: widget.levelId,
                    );
                    break;
                  default:
                    gameScreen = MathGameScreen(
                      gradeLevel: widget.gradeNumber,
                      level: widget.levelId,
                    );
                }
                Navigator.push(context, MaterialPageRoute(builder: (_) => gameScreen));
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isUnlocked ? _getDifficultyColor(_levelData['difficulty']) : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: isUnlocked ? 5 : 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isUnlocked ? Icons.play_arrow : Icons.lock, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Text(
              isUnlocked ? 'Start Level ${widget.levelId}' : 'Locked - Complete Previous Level',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getLevelData() {
    final Map<int, Map<String, dynamic>> levelsData = {
      1: {
        'emoji': '🌱',
        'difficulty': 'Easy',
        'estimatedTime': '5-7 min',
        'questionCount': '10',
        'passingScore': '70%',
        'description': 'Start your learning journey with basic concepts and fun challenges. Perfect for beginners!',
        'topics': ['Basic Operations', 'Simple Vocabulary', 'Introduction to Science'],
        'xpReward': 50,
        'coinReward': 10,
        'keyReward': 1,
        'bonusReward': 'First completion: +20 XP',
        'minScore': 0,
        'ageRequirement': 6,
      },
      2: {
        'emoji': '🌿',
        'difficulty': 'Easy',
        'estimatedTime': '7-9 min',
        'questionCount': '12',
        'passingScore': '70%',
        'description': 'Build on your foundation with more challenging questions and new concepts.',
        'topics': ['Addition & Subtraction', 'Common Words', 'Animal Kingdom'],
        'xpReward': 75,
        'coinReward': 15,
        'keyReward': 1,
        'bonusReward': 'Perfect score: +30 XP',
        'minScore': 50,
        'ageRequirement': 6,
      },
      3: {
        'emoji': '🌳',
        'difficulty': 'Medium',
        'estimatedTime': '10-12 min',
        'questionCount': '15',
        'passingScore': '75%',
        'description': 'Test your skills with intermediate questions across all subjects.',
        'topics': ['Multiplication', 'Sentence Structure', 'Plant Life'],
        'xpReward': 100,
        'coinReward': 20,
        'keyReward': 1,
        'bonusReward': 'Speed bonus: +40 XP',
        'minScore': 100,
        'ageRequirement': 8,
      },
      4: {
        'emoji': '🏔️',
        'difficulty': 'Medium',
        'estimatedTime': '12-15 min',
        'questionCount': '15',
        'passingScore': '75%',
        'description': 'Navigate through challenging problems and expand your knowledge.',
        'topics': ['Division', 'Grammar Rules', 'Human Body'],
        'xpReward': 125,
        'coinReward': 25,
        'keyReward': 1,
        'bonusReward': 'No mistakes: +50 XP',
        'minScore': 150,
        'ageRequirement': 9,
      },
      5: {
        'emoji': '🗺️',
        'difficulty': 'Hard',
        'estimatedTime': '15-18 min',
        'questionCount': '18',
        'passingScore': '80%',
        'description': 'Hunt for treasure with advanced knowledge and critical thinking.',
        'topics': ['Fractions', 'Reading Comprehension', 'Solar System'],
        'xpReward': 150,
        'coinReward': 30,
        'keyReward': 2,
        'bonusReward': 'Treure find: +60 XP',
        'minScore': 200,
        'ageRequirement': 10,
      },
      6: {
        'emoji': '💎',
        'difficulty': 'Hard',
        'estimatedTime': '15-18 min',
        'questionCount': '18',
        'passingScore': '80%',
        'description': 'Discover new concepts and master advanced topics.',
        'topics': ['Decimals', 'Writing Skills', 'Chemical Reactions'],
        'xpReward': 175,
        'coinReward': 35,
        'keyReward': 2,
        'bonusReward': 'Discovery bonus: +70 XP',
        'minScore': 250,
        'ageRequirement': 11,
      },
      7: {
        'emoji': '🚀',
        'difficulty': 'Expert',
        'estimatedTime': '18-20 min',
        'questionCount': '20',
        'passingScore': '85%',
        'description': 'Pioneer your way through expert challenges and complex problems.',
        'topics': ['Algebra', 'Advanced Grammar', 'Physics Basics'],
        'xpReward': 200,
        'coinReward': 40,
        'keyReward': 2,
        'bonusReward': 'Expert mastery: +80 XP',
        'minScore': 300,
        'ageRequirement': 12,
      },
      8: {
        'emoji': '🏆',
        'difficulty': 'Expert',
        'estimatedTime': '20-25 min',
        'questionCount': '20',
        'passingScore': '90%',
        'description': 'The final challenge! Prove you are the ultimate champion!',
        'topics': ['Advanced Algebra', 'Literature', 'Complex Sciences'],
        'xpReward': 250,
        'coinReward': 50,
        'keyReward': 3,
        'bonusReward': 'Champion bonus: +100 XP',
        'minScore': 350,
        'ageRequirement': 13,
      },
    };
    
    return levelsData[widget.levelId] ?? levelsData[1]!;
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy': return AppColors.mintGreen;
      case 'Medium': return AppColors.warningOrange;
      case 'Hard': return AppColors.mathOrange;
      case 'Expert': return AppColors.neonPurple;
      default: return AppColors.neonBlue;
    }
  }

  IconData _getSubjectIcon() {
    switch (widget.subject) {
      case 'Math':
        return Icons.calculate;
      case 'English':
        return Icons.menu_book;
      case 'Science':
        return Icons.science;
      default:
        return Icons.school;
    }
  }
}