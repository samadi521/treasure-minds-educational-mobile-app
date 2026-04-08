import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../../providers/auth_provider.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late ConfettiController _confettiController;
  
  int _selectedCategory = 0;
  int _newlyUnlockedId = -1;
  
  // Complete achievements data
  final List<Achievement> _allAchievements = [
    // Learning Milestones
    Achievement(
      id: 1,
      title: 'First Steps',
      description: 'Complete your first quiz',
      icon: Icons.auto_awesome,
      category: 'Learning',
      points: 50,
      requirement: 1,
      currentProgress: 1,
      color: AppColors.mintGreen,
      rarity: 'Common',
      dateEarned: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Achievement(
      id: 2,
      title: 'Quick Learner',
      description: 'Score 90% or higher on any quiz',
      icon: Icons.rocket,
      category: 'Learning',
      points: 100,
      requirement: 90,
      currentProgress: 85,
      color: AppColors.neonBlue,
      rarity: 'Rare',
    ),
    Achievement(
      id: 3,
      title: 'Perfect Score',
      description: 'Get 100% on a quiz',
      icon: Icons.star,
      category: 'Learning',
      points: 200,
      requirement: 100,
      currentProgress: 100,
      color: AppColors.gold,
      rarity: 'Epic',
      dateEarned: DateTime.now().subtract(const Duration(days: 15)),
    ),
    
    // Subject Mastery
    Achievement(
      id: 4,
      title: 'Math Novice',
      description: 'Score 500 points in Mathematics',
      icon: Icons.calculate,
      category: 'Subjects',
      points: 150,
      requirement: 500,
      currentProgress: 350,
      color: AppColors.mathOrange,
      rarity: 'Common',
    ),
    Achievement(
      id: 5,
      title: 'Math Master',
      description: 'Score 2000 points in Mathematics',
      icon: Icons.emoji_events,
      category: 'Subjects',
      points: 500,
      requirement: 2000,
      currentProgress: 1200,
      color: AppColors.mathOrange,
      rarity: 'Epic',
    ),
    Achievement(
      id: 6,
      title: 'English Novice',
      description: 'Score 500 points in English',
      icon: Icons.menu_book,
      category: 'Subjects',
      points: 150,
      requirement: 500,
      currentProgress: 500,
      color: AppColors.englishGreen,
      rarity: 'Common',
      dateEarned: DateTime.now().subtract(const Duration(days: 20)),
    ),
    Achievement(
      id: 7,
      title: 'English Master',
      description: 'Score 2000 points in English',
      icon: Icons.emoji_events,
      category: 'Subjects',
      points: 500,
      requirement: 2000,
      currentProgress: 800,
      color: AppColors.englishGreen,
      rarity: 'Epic',
    ),
    Achievement(
      id: 8,
      title: 'Science Novice',
      description: 'Score 500 points in Science',
      icon: Icons.science,
      category: 'Subjects',
      points: 150,
      requirement: 500,
      currentProgress: 200,
      color: AppColors.sciencePurple,
      rarity: 'Common',
    ),
    
    // Streak & Consistency
    Achievement(
      id: 9,
      title: 'Consistency King',
      description: 'Maintain a 7-day streak',
      icon: Icons.local_fire_department,
      category: 'Streak',
      points: 300,
      requirement: 7,
      currentProgress: 7,
      color: AppColors.warningOrange,
      rarity: 'Rare',
      dateEarned: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Achievement(
      id: 10,
      title: 'Dedicated Learner',
      description: 'Maintain a 30-day streak',
      icon: Icons.bolt,
      category: 'Streak',
      points: 1000,
      requirement: 30,
      currentProgress: 12,
      color: AppColors.gold,
      rarity: 'Legendary',
    ),
    
    // Speed & Accuracy
    Achievement(
      id: 11,
      title: 'Speed Demon',
      description: 'Answer 10 questions in under 60 seconds',
      icon: Icons.timer,
      category: 'Speed',
      points: 200,
      requirement: 10,
      currentProgress: 8,
      color: AppColors.neonOrange,
      rarity: 'Rare',
    ),
    Achievement(
      id: 12,
      title: 'Sharpshooter',
      description: 'Get 10 correct answers in a row',
      icon: Icons.psychology,
      category: 'Speed',
      points: 250,
      requirement: 10,
      currentProgress: 7,
      color: AppColors.neonPurple,
      rarity: 'Epic',
    ),
    
    // Special Events
    Achievement(
      id: 13,
      title: 'Treasure Hunter',
      description: 'Collect 5 keys in Adventure Mode',
      icon: Icons.key,
      category: 'Special',
      points: 300,
      requirement: 5,
      currentProgress: 3,
      color: AppColors.gold,
      rarity: 'Rare',
    ),
    Achievement(
      id: 14,
      title: 'Puzzle Master',
      description: 'Solve 20 puzzles',
      icon: Icons.psychology,
      category: 'Special',
      points: 400,
      requirement: 20,
      currentProgress: 8,
      color: AppColors.lavenderPurple,
      rarity: 'Epic',
    ),
    Achievement(
      id: 15,
      title: 'Tournament Winner',
      description: 'Win a weekly tournament',
      icon: Icons.emoji_events,
      category: 'Special',
      points: 1000,
      requirement: 1,
      currentProgress: 0,
      color: AppColors.gold,
      rarity: 'Legendary',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _animationController.forward();
    
    // Check for newly unlocked achievements
    _checkNewAchievements();
  }

  void _checkNewAchievements() {
    // In real app, check against previous state
    // For demo, show confetti for recently earned
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_allAchievements.any((a) => a.isEarned && a.dateEarned != null && 
          a.dateEarned!.difference(DateTime.now()).inDays == 0)) {
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context);
    final earnedCount = _allAchievements.where((a) => a.isEarned).length;
    final totalPoints = _allAchievements.where((a) => a.isEarned).fold(0, (sum, a) => sum + a.points);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Achievements'),
        backgroundColor: AppColors.neonPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: _buildHeader(earnedCount, totalPoints),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildCategoryTabs(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAchievementList('All'),
                    _buildAchievementList('Learning'),
                    _buildAchievementList('Subjects'),
                    _buildAchievementList('Streak'),
                    _buildAchievementList('Special'),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                AppColors.gold,
                AppColors.neonPurple,
                AppColors.mintGreen,
                AppColors.neonOrange,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(int earnedCount, int totalPoints) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHeaderStat(Icons.emoji_events, '$earnedCount', 'Earned', AppColors.gold),
              _buildHeaderStat(Icons.auto_awesome, '${_allAchievements.length}', 'Total', AppColors.neonBlue),
              _buildHeaderStat(Icons.star, '$totalPoints', 'Points', AppColors.mintGreen),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: earnedCount / _allAchievements.length,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(AppColors.gold),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(earnedCount / _allAchievements.length * 100).toInt()}% Complete',
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildCategoryTabs() {
    final categories = ['All', 'Learning', 'Subjects', 'Streak', 'Special'];
    
    return Container(
      margin: const EdgeInsets.all(16),
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = index;
                _tabController.animateTo(index);
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.neonPurple : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.shade300,
                ),
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAchievementList(String category) {
    List<Achievement> achievements;
    
    if (category == 'All') {
      achievements = _allAchievements;
    } else {
      achievements = _allAchievements.where((a) => a.category == category).toList();
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return _buildAchievementCard(achievement);
      },
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    final isEarned = achievement.isEarned;
    final progress = achievement.currentProgress / achievement.requirement;
    final rarityColor = _getRarityColor(achievement.rarity);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      transform: Matrix4.identity()..scale(isEarned && _newlyUnlockedId == achievement.id ? 1.05 : 1.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: isEarned
              ? LinearGradient(
                  colors: [achievement.color.withValues(alpha: 0.15), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isEarned ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isEarned ? achievement.color : Colors.grey.shade200,
            width: isEarned ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isEarned ? achievement.color.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.05),
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
                  // Icon
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isEarned
                            ? [achievement.color, achievement.color.withValues(alpha: 0.7)]
                            : [Colors.grey.shade300, Colors.grey.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      achievement.icon,
                      size: 32,
                      color: isEarned ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              achievement.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isEarned ? achievement.color : Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: rarityColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                achievement.rarity,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: rarityColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          achievement.description,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        if (!isEarned) ...[
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: progress.clamp(0.0, 1.0),
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor: AlwaysStoppedAnimation(achievement.color),
                                    minHeight: 6,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${achievement.currentProgress}/${achievement.requirement}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: achievement.color,
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          Row(
                            children: [
                              const Icon(Icons.check_circle, size: 14, color: AppColors.mintGreen),
                              const SizedBox(width: 4),
                              Text(
                                'Earned ${_formatDate(achievement.dateEarned!)}',
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Points
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, size: 12, color: AppColors.gold),
                            const SizedBox(width: 2),
                            Text(
                              '+${achievement.points}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.gold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isEarned)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Icon(Icons.emoji_events, size: 24, color: AppColors.gold),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (isEarned && _newlyUnlockedId == achievement.id)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'NEW!',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getRarityColor(String rarity) {
    switch (rarity) {
      case 'Common': return Colors.grey;
      case 'Rare': return AppColors.neonBlue;
      case 'Epic': return AppColors.neonPurple;
      case 'Legendary': return AppColors.gold;
      default: return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class Achievement {
  final int id;
  final String title;
  final String description;
  final IconData icon;
  final String category;
  final int points;
  final int requirement;
  int currentProgress;
  final Color color;
  final String rarity;
  DateTime? dateEarned;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.points,
    required this.requirement,
    required this.currentProgress,
    required this.color,
    required this.rarity,
    this.dateEarned,
  });

  bool get isEarned => currentProgress >= requirement;
}
