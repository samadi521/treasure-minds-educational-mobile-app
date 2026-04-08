import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../../config/theme.dart';

class BadgesScreen extends StatefulWidget {
  const BadgesScreen({super.key});

  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  int _selectedCategory = 0; // 0 = All, 1 = Achievements, 2 = Subjects, 3 = Special

  // Complete badges collection
  final List<Map<String, dynamic>> _allBadges = [
    // Achievement Badges
    {'id': 1, 'name': 'First Victory', 'description': 'Complete your first game', 'icon': Icons.emoji_events, 'requirement': 50, 'color': AppColors.gold, 'category': 'Achievements', 'points': 50, 'rarity': 'Common'},
    {'id': 2, 'name': 'Rising Star', 'description': 'Reach 500 total points', 'icon': Icons.star, 'requirement': 500, 'color': AppColors.bronze, 'category': 'Achievements', 'points': 500, 'rarity': 'Common'},
    {'id': 3, 'name': 'Expert Player', 'description': 'Reach 1000 total points', 'icon': Icons.workspace_premium, 'requirement': 1000, 'color': AppColors.silver, 'category': 'Achievements', 'points': 1000, 'rarity': 'Rare'},
    {'id': 4, 'name': 'Master Champion', 'description': 'Reach 2000 total points', 'icon': Icons.emoji_events, 'requirement': 2000, 'color': AppColors.gold, 'category': 'Achievements', 'points': 2000, 'rarity': 'Epic'},
    {'id': 5, 'name': 'Legendary Hero', 'description': 'Reach 5000 total points', 'icon': Icons.auto_awesome, 'requirement': 5000, 'color': AppColors.neonPurple, 'category': 'Achievements', 'points': 5000, 'rarity': 'Legendary'},
    
    // Subject Mastery Badges
    {'id': 6, 'name': 'Math Novice', 'description': 'Score 100 points in Math', 'icon': Icons.calculate, 'requirement': 100, 'color': AppColors.mathOrange, 'category': 'Subjects', 'points': 100, 'rarity': 'Common'},
    {'id': 7, 'name': 'Math Master', 'description': 'Score 500 points in Math', 'icon': Icons.calculate, 'requirement': 500, 'color': AppColors.mathOrange, 'category': 'Subjects', 'points': 500, 'rarity': 'Rare'},
    {'id': 8, 'name': 'Math Genius', 'description': 'Score 1000 points in Math', 'icon': Icons.calculate, 'requirement': 1000, 'color': AppColors.mathOrange, 'category': 'Subjects', 'points': 1000, 'rarity': 'Epic'},
    {'id': 9, 'name': 'English Novice', 'description': 'Score 100 points in English', 'icon': Icons.menu_book, 'requirement': 100, 'color': AppColors.englishGreen, 'category': 'Subjects', 'points': 100, 'rarity': 'Common'},
    {'id': 10, 'name': 'English Master', 'description': 'Score 500 points in English', 'icon': Icons.menu_book, 'requirement': 500, 'color': AppColors.englishGreen, 'category': 'Subjects', 'points': 500, 'rarity': 'Rare'},
    {'id': 11, 'name': 'English Genius', 'description': 'Score 1000 points in English', 'icon': Icons.menu_book, 'requirement': 1000, 'color': AppColors.englishGreen, 'category': 'Subjects', 'points': 1000, 'rarity': 'Epic'},
    {'id': 12, 'name': 'Science Novice', 'description': 'Score 100 points in Science', 'icon': Icons.science, 'requirement': 100, 'color': AppColors.sciencePurple, 'category': 'Subjects', 'points': 100, 'rarity': 'Common'},
    {'id': 13, 'name': 'Science Master', 'description': 'Score 500 points in Science', 'icon': Icons.science, 'requirement': 500, 'color': AppColors.sciencePurple, 'category': 'Subjects', 'points': 500, 'rarity': 'Rare'},
    {'id': 14, 'name': 'Science Genius', 'description': 'Score 1000 points in Science', 'icon': Icons.science, 'requirement': 1000, 'color': AppColors.sciencePurple, 'category': 'Subjects', 'points': 1000, 'rarity': 'Epic'},
    
    // Special Badges
    {'id': 15, 'name': 'Streak Starter', 'description': 'Maintain a 3-day streak', 'icon': Icons.local_fire_department, 'requirement': 3, 'color': AppColors.warningOrange, 'category': 'Special', 'points': 3, 'rarity': 'Common'},
    {'id': 16, 'name': 'Streak Master', 'description': 'Maintain a 7-day streak', 'icon': Icons.local_fire_department, 'requirement': 7, 'color': AppColors.errorRed, 'category': 'Special', 'points': 7, 'rarity': 'Rare'},
    {'id': 17, 'name': 'Key Collector', 'description': 'Collect 3 keys', 'icon': Icons.key, 'requirement': 3, 'color': AppColors.gold, 'category': 'Special', 'points': 3, 'rarity': 'Common'},
    {'id': 18, 'name': 'Master Key', 'description': 'Collect 5 keys', 'icon': Icons.key, 'requirement': 5, 'color': AppColors.gold, 'category': 'Special', 'points': 5, 'rarity': 'Rare'},
    {'id': 19, 'name': 'Speed Demon', 'description': 'Score 300 points in Timer Challenge', 'icon': Icons.timer, 'requirement': 300, 'color': AppColors.neonBlue, 'category': 'Special', 'points': 300, 'rarity': 'Rare'},
    {'id': 20, 'name': 'Puzzle Solver', 'description': 'Solve 5 puzzles', 'icon': Icons.psychology, 'requirement': 5, 'color': AppColors.lavenderPurple, 'category': 'Special', 'points': 5, 'rarity': 'Common'},
    {'id': 21, 'name': 'Puzzle Master', 'description': 'Solve 15 puzzles', 'icon': Icons.psychology, 'requirement': 15, 'color': AppColors.lavenderPurple, 'category': 'Special', 'points': 15, 'rarity': 'Epic'},
    {'id': 22, 'name': 'Adventure Starter', 'description': 'Complete Level 1', 'icon': Icons.map, 'requirement': 1, 'color': AppColors.adventureTeal, 'category': 'Special', 'points': 1, 'rarity': 'Common'},
    {'id': 23, 'name': 'World Explorer', 'description': 'Complete all 8 levels', 'icon': Icons.map, 'requirement': 8, 'color': AppColors.adventureTeal, 'category': 'Special', 'points': 8, 'rarity': 'Legendary'},
    {'id': 24, 'name': 'Daily Champion', 'description': 'Complete 7 daily challenges', 'icon': Icons.calendar_today, 'requirement': 7, 'color': AppColors.gold, 'category': 'Special', 'points': 7, 'rarity': 'Epic'},
    {'id': 25, 'name': 'Perfectionist', 'description': 'Get 100% accuracy in a game', 'icon': Icons.percent, 'requirement': 100, 'color': AppColors.neonGreen, 'category': 'Special', 'points': 100, 'rarity': 'Epic'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context);
    
    int earnedCount = _allBadges.where((badge) => game.totalScore >= badge['requirement']).length;
    int lockedCount = _allBadges.length - earnedCount;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildHeader(game, earnedCount, lockedCount),
            _buildCategoryTabs(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBadgesGrid(game, 'All'),
                  _buildBadgesGrid(game, 'Achievements'),
                  _buildBadgesGrid(game, 'Subjects'),
                  _buildBadgesGrid(game, 'Special'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(GameProvider game, int earnedCount, int lockedCount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.neonPurple, AppColors.lavenderPurple],
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
                "🏆 Badges & Achievements",
                style: TextStyle(
                  fontSize: 22,
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
                child: const Icon(Icons.emoji_events, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHeaderStat('Earned', '$earnedCount', AppColors.gold),
              _buildHeaderStat('Locked', '$lockedCount', Colors.white54),
              _buildHeaderStat('Total', '${_allBadges.length}', Colors.white),
              _buildHeaderStat('Completion', '${((earnedCount / _allBadges.length) * 100).toInt()}%', AppColors.mintGreen),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: earnedCount / _allBadges.length,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(AppColors.gold),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${earnedCount} of ${_allBadges.length} badges collected',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
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
    return Container(
      margin: const EdgeInsets.all(16),
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
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.neonPurple,
        unselectedLabelColor: Colors.grey,
        indicator: BoxDecoration(
          color: AppColors.gold.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(30),
        ),
        tabs: const [
          Tab(text: "🏅 All"),
          Tab(text: "⭐ Achievements"),
          Tab(text: "📚 Subjects"),
          Tab(text: "✨ Special"),
        ],
      ),
    );
  }

  Widget _buildBadgesGrid(GameProvider game, String category) {
    List<Map<String, dynamic>> badges;
    
    if (category == 'All') {
      badges = _allBadges;
    } else {
      badges = _allBadges.where((b) => b['category'] == category).toList();
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: badges.length,
      itemBuilder: (ctx, index) {
        final badge = badges[index];
        final bool earned = game.totalScore >= badge['requirement'];
        final String rarity = badge['rarity'];
        Color rarityColor;
        
        switch (rarity) {
          case 'Common': rarityColor = Colors.grey.shade400; break;
          case 'Rare': rarityColor = Colors.blue; break;
          case 'Epic': rarityColor = AppColors.neonPurple; break;
          case 'Legendary': rarityColor = AppColors.gold; break;
          default: rarityColor = Colors.grey;
        }
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: Matrix4.identity()..scale(earned ? 1.0 : 0.95),
          child: GestureDetector(
            onTap: () {
              if (earned) {
                _showBadgeDetails(badge);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: earned
                    ? LinearGradient(
                        colors: [badge['color'] as Color, (badge['color'] as Color).withValues(alpha: 0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [Colors.grey.shade300, Colors.grey.shade200],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: earned
                    ? [
                        BoxShadow(
                          color: (badge['color'] as Color).withValues(alpha: 0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Badge Icon
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: earned
                                  ? Colors.white.withValues(alpha: 0.3)
                                  : Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              badge['icon'] as IconData,
                              size: 45,
                              color: earned ? Colors.white : Colors.grey.shade500,
                            ),
                          ),
                          // Rarity indicator
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: rarityColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Badge Name
                      Text(
                        badge['name'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: earned ? Colors.white : Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      // Badge Description
                      Text(
                        badge['description'],
                        style: TextStyle(
                          fontSize: 10,
                          color: earned ? Colors.white70 : Colors.grey.shade500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      // Requirement / Points
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: earned
                              ? Colors.white.withValues(alpha: 0.2)
                              : Colors.black.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          earned ? '${badge['points']} pts' : 'Need ${badge['requirement']} pts',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: earned ? Colors.white : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (earned)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.mintGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if (!earned)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock,
                          size: 14,
                          color: Colors.white,
                        ),
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

  void _showBadgeDetails(Map<String, dynamic> badge) {
    final game = Provider.of<GameProvider>(context, listen: false);
    final bool earned = game.totalScore >= badge['requirement'];
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Row(
          children: [
            Icon(badge['icon'] as IconData, color: badge['color'] as Color),
            const SizedBox(width: 10),
            Text(badge['name']),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [badge['color'] as Color, (badge['color'] as Color).withValues(alpha: 0.5)],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                badge['icon'] as IconData,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              badge['description'],
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (badge['color'] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Points Required:'),
                      Text(
                        '${badge['requirement']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Rarity:'),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: badge['rarity'] == 'Legendary'
                              ? AppColors.gold
                              : badge['rarity'] == 'Epic'
                                  ? AppColors.neonPurple
                                  : badge['rarity'] == 'Rare'
                                      ? Colors.blue
                                      : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          badge['rarity'],
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Status:'),
                      Text(
                        earned ? '✅ Earned' : '🔒 Locked',
                        style: TextStyle(
                          color: earned ? AppColors.mintGreen : AppColors.errorRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (!earned)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: LinearProgressIndicator(
                  value: game.totalScore / (badge['requirement'] as int),
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation(badge['color'] as Color),
                  minHeight: 6,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          if (!earned)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                // Navigate to game mode selection
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: badge['color'] as Color,
              ),
              child: const Text('Play to Earn'),
            ),
        ],
      ),
    );
  }
}