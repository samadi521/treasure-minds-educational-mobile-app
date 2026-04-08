import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../games/math_game_screen.dart';
import '../games/english_game_screen.dart';
import '../games/science_game_screen.dart';

class LevelSelectionScreen extends StatefulWidget {
  final String grade;
  final int gradeNumber;
  final String subject;
  
  const LevelSelectionScreen({
    super.key,
    required this.grade,
    required this.gradeNumber,
    required this.subject,
  });

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int _selectedDifficulty = 0; // 0 = All, 1 = Easy, 2 = Medium, 3 = Hard
  
  // Level data with detailed information
  final List<Level> _levels = [
    Level(
      id: 1,
      name: 'Novice Explorer',
      shortName: 'Level 1',
      description: 'Begin your journey with basic concepts',
      difficulty: 'Easy',
      xpReward: 50,
      coinReward: 10,
      estimatedTime: '5 min',
      topics: ['Basic Operations', 'Simple Vocabulary', 'Introduction to Science'],
      icon: Icons.forest,
      isLocked: false,
      isCompleted: false,
      color: AppColors.mintGreen,
    ),
    Level(
      id: 2,
      name: 'Apprentice Adventurer',
      shortName: 'Level 2',
      description: 'Build on your foundation with more challenges',
      difficulty: 'Easy',
      xpReward: 75,
      coinReward: 15,
      estimatedTime: '7 min',
      topics: ['Addition & Subtraction', 'Common Words', 'Animal Kingdom'],
      icon: Icons.terrain,
      isLocked: false,
      isCompleted: false,
      color: AppColors.mintGreen,
    ),
    Level(
      id: 3,
      name: 'Skillful Seeker',
      shortName: 'Level 3',
      description: 'Test your skills with intermediate questions',
      difficulty: 'Medium',
      xpReward: 100,
      coinReward: 20,
      estimatedTime: '10 min',
      topics: ['Multiplication', 'Sentence Structure', 'Plant Life'],
      icon: Icons.water,
      isLocked: false,
      isCompleted: false,
      color: AppColors.warningOrange,
    ),
    Level(
      id: 4,
      name: 'Expert Navigator',
      shortName: 'Level 4',
      description: 'Navigate through challenging problems',
      difficulty: 'Medium',
      xpReward: 125,
      coinReward: 25,
      estimatedTime: '12 min',
      topics: ['Division', 'Grammar Rules', 'Human Body'],
      icon: Icons.navigation,
      isLocked: true,
      isCompleted: false,
      color: AppColors.warningOrange,
    ),
    Level(
      id: 5,
      name: 'Master Treasure Hunter',
      shortName: 'Level 5',
      description: 'Hunt for treasure with advanced knowledge',
      difficulty: 'Hard',
      xpReward: 150,
      coinReward: 30,
      estimatedTime: '15 min',
      topics: ['Fractions', 'Reading Comprehension', 'Solar System'],
      icon: Icons.map,
      isLocked: true,
      isCompleted: false,
      color: AppColors.mathOrange,
    ),
    Level(
      id: 6,
      name: 'Grand Discovery',
      shortName: 'Level 6',
      description: 'Discover new concepts and master them',
      difficulty: 'Hard',
      xpReward: 175,
      coinReward: 35,
      estimatedTime: '15 min',
      topics: ['Decimals', 'Writing Skills', 'Chemical Reactions'],
      icon: Icons.explore,
      isLocked: true,
      isCompleted: false,
      color: AppColors.mathOrange,
    ),
    Level(
      id: 7,
      name: 'Legendary Pioneer',
      shortName: 'Level 7',
      description: 'Pioneer your way through expert challenges',
      difficulty: 'Expert',
      xpReward: 200,
      coinReward: 40,
      estimatedTime: '18 min',
      topics: ['Algebra', 'Advanced Grammar', 'Physics Basics'],
      icon: Icons.rocket,
      isLocked: true,
      isCompleted: false,
      color: AppColors.neonPurple,
    ),
    Level(
      id: 8,
      name: 'Ultimate Champion',
      shortName: 'Level 8',
      description: 'The final challenge - become the champion!',
      difficulty: 'Expert',
      xpReward: 250,
      coinReward: 50,
      estimatedTime: '20 min',
      topics: ['Advanced Algebra', 'Literature', 'Complex Sciences'],
      icon: Icons.emoji_events,
      isLocked: true,
      isCompleted: false,
      color: AppColors.gold,
    ),
  ];

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
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
    
    // For demo purposes, mark first 3 levels as unlocked
    _levels[0].isLocked = false;
    _levels[1].isLocked = false;
    _levels[2].isLocked = false;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter levels based on selected difficulty
    List<Level> displayedLevels = _levels;
    if (_selectedDifficulty == 1) {
      displayedLevels = _levels.where((l) => l.difficulty == 'Easy').toList();
    } else if (_selectedDifficulty == 2) {
      displayedLevels = _levels.where((l) => l.difficulty == 'Medium').toList();
    } else if (_selectedDifficulty == 3) {
      displayedLevels = _levels.where((l) => l.difficulty == 'Hard' || l.difficulty == 'Expert').toList();
    }
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text("${widget.grade} - Select Level"),
        backgroundColor: _getSubjectColor(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              _buildGradeInfoBanner(),
              _buildDifficultyFilter(),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: displayedLevels.length,
                  itemBuilder: (context, index) {
                    return _buildLevelCard(displayedLevels[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradeInfoBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_getSubjectColor(), _getSubjectColor().withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getSubjectColor().withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getSubjectIcon(),
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.subject,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  widget.grade,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(Icons.school, size: 14, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  '${_getRecommendedLevel()} Levels',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyFilter() {
    final filters = [
      {'label': 'All', 'icon': Icons.apps},
      {'label': 'Easy', 'icon': Icons.sentiment_satisfied},
      {'label': 'Medium', 'icon': Icons.sentiment_neutral},
      {'label': 'Hard', 'icon': Icons.sentiment_very_dissatisfied},
    ];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: filters.asMap().entries.map((entry) {
          final index = entry.key;
          final filter = entry.value;
          final isSelected = _selectedDifficulty == index;
          Color getColor() {
            if (index == 0) return AppColors.neonBlue;
            if (index == 1) return AppColors.mintGreen;
            if (index == 2) return AppColors.warningOrange;
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
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? getColor() : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      filter['icon'] as IconData,
                      size: 16,
                      color: isSelected ? Colors.white : getColor(),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      filter['label'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white : getColor(),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLevelCard(Level level) {
    final isUnlocked = !level.isLocked;
    final isCompleted = level.isCompleted;
    final difficultyColor = _getDifficultyColor(level.difficulty);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      transform: Matrix4.identity()..scale(isUnlocked ? 1.0 : 0.98),
      child: GestureDetector(
        onTap: isUnlocked ? () => _startGame(level) : null,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isUnlocked
                  ? [level.color.withValues(alpha: 0.1), level.color.withValues(alpha: 0.05)]
                  : [Colors.grey.shade100, Colors.grey.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isUnlocked ? level.color.withValues(alpha: 0.3) : Colors.grey.shade200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isUnlocked ? level.color.withValues(alpha: 0.1) : Colors.transparent,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Level Icon
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isUnlocked
                              ? [level.color, level.color.withValues(alpha: 0.7)]
                              : [Colors.grey.shade400, Colors.grey.shade500],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: isUnlocked
                            ? [
                                BoxShadow(
                                  color: level.color.withValues(alpha: 0.3),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(Icons.check, color: Colors.white, size: 35)
                            : Icon(
                                level.icon,
                                color: Colors.white,
                                size: 35,
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Level Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                level.shortName,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isUnlocked ? level.color : Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: difficultyColor.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  level.difficulty,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: difficultyColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            level.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isUnlocked ? Colors.black87 : Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            level.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: isUnlocked ? Colors.grey.shade600 : Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Rewards Row
                          Wrap(
                            spacing: 12,
                            children: [
                              _buildRewardChip(Icons.star, '${level.xpReward} XP', AppColors.gold),
                              _buildRewardChip(Icons.monetization_on, '${level.coinReward}', AppColors.gold),
                              _buildRewardChip(Icons.timer, level.estimatedTime, Colors.grey),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Topics Preview
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: level.topics.map((topic) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isUnlocked ? level.color.withValues(alpha: 0.1) : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  topic,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: isUnlocked ? level.color : Colors.grey.shade600,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    
                    // Action Button
                    if (isUnlocked)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isCompleted ? AppColors.mintGreen : level.color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (isCompleted ? AppColors.mintGreen : level.color).withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          isCompleted ? Icons.replay : Icons.play_arrow,
                          color: Colors.white,
                          size: 28,
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                  ],
                ),
              ),
              // Completion overlay
              if (isCompleted)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.mintGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, size: 12, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'COMPLETED',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
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

  Widget _buildRewardChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 2),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _startGame(Level level) {
    Widget gameScreen;
    
    switch (widget.subject) {
      case 'Math':
        gameScreen = MathGameScreen(
          gradeLevel: widget.gradeNumber,
          level: level.id,
        );
        break;
      case 'English':
        gameScreen = EnglishGameScreen(
          gradeLevel: widget.gradeNumber,
          level: level.id,
        );
        break;
      case 'Science':
        gameScreen = ScienceGameScreen(
          gradeLevel: widget.gradeNumber,
          level: level.id,
        );
        break;
      default:
        gameScreen = MathGameScreen(
          gradeLevel: widget.gradeNumber,
          level: level.id,
        );
    }
    
    Navigator.push(context, MaterialPageRoute(builder: (_) => gameScreen)).then((_) {
      // Refresh the screen when coming back from game
      setState(() {
        // In a real app, you would update the level completion status here
        // For demo, let's mark the level as completed after playing
        if (!level.isCompleted) {
          level.isCompleted = true;
          // Unlock next level
          final nextLevelIndex = _levels.indexWhere((l) => l.id == level.id + 1);
          if (nextLevelIndex != -1) {
            _levels[nextLevelIndex].isLocked = false;
          }
        }
      });
    });
  }

  int _getRecommendedLevel() {
    if (widget.gradeNumber <= 2) return 2;
    if (widget.gradeNumber <= 4) return 4;
    if (widget.gradeNumber <= 6) return 5;
    if (widget.gradeNumber <= 8) return 6;
    return 8;
  }

  Color _getSubjectColor() {
    switch (widget.subject) {
      case 'Math':
        return AppColors.mathOrange;
      case 'English':
        return AppColors.englishGreen;
      case 'Science':
        return AppColors.sciencePurple;
      default:
        return AppColors.neonBlue;
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

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy': return AppColors.mintGreen;
      case 'Medium': return AppColors.warningOrange;
      case 'Hard': return AppColors.mathOrange;
      case 'Expert': return AppColors.neonPurple;
      default: return Colors.grey;
    }
  }
}

class Level {
  final int id;
  final String name;
  final String shortName;
  final String description;
  final String difficulty;
  final int xpReward;
  final int coinReward;
  final String estimatedTime;
  final List<String> topics;
  final IconData icon;
  bool isLocked;
  bool isCompleted;
  final Color color;

  Level({
    required this.id,
    required this.name,
    required this.shortName,
    required this.description,
    required this.difficulty,
    required this.xpReward,
    required this.coinReward,
    required this.estimatedTime,
    required this.topics,
    required this.icon,
    required this.isLocked,
    required this.isCompleted,
    required this.color,
  });
}