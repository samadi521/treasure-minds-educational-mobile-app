import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../../providers/auth_provider.dart';
import 'challenge_detail_screen.dart';

class WeeklyChallengeScreen extends StatefulWidget {
  const WeeklyChallengeScreen({super.key});

  @override
  State<WeeklyChallengeScreen> createState() => _WeeklyChallengeScreenState();
}

class _WeeklyChallengeScreenState extends State<WeeklyChallengeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  int _selectedWeek = 0;
  bool _showRewards = false;
  
  // Weekly challenge data
  final List<WeeklyChallenge> _weeklyChallenges = [
    WeeklyChallenge(
      week: 1,
      title: 'Math Masters Week',
      description: 'Test your arithmetic and algebra skills',
      theme: 'Mathematics',
      icon: Icons.calculate,
      color: AppColors.mathOrange,
      startDate: DateTime(2026, 3, 1),
      endDate: DateTime(2026, 3, 7),
      challenges: [
        DailyChallenge(day: 1, title: 'Basic Arithmetic', type: 'Math', difficulty: 'Easy', xpReward: 50, coinReward: 20, completed: false),
        DailyChallenge(day: 2, title: 'Multiplication Tables', type: 'Math', difficulty: 'Easy', xpReward: 50, coinReward: 20, completed: false),
        DailyChallenge(day: 3, title: 'Division Master', type: 'Math', difficulty: 'Medium', xpReward: 75, coinReward: 30, completed: false),
        DailyChallenge(day: 4, title: 'Fraction Fun', type: 'Math', difficulty: 'Medium', xpReward: 75, coinReward: 30, completed: false),
        DailyChallenge(day: 5, title: 'Decimal Dash', type: 'Math', difficulty: 'Hard', xpReward: 100, coinReward: 40, completed: false),
        DailyChallenge(day: 6, title: 'Algebra Adventure', type: 'Math', difficulty: 'Hard', xpReward: 100, coinReward: 40, completed: false),
        DailyChallenge(day: 7, title: 'Math Champion', type: 'Math', difficulty: 'Expert', xpReward: 200, coinReward: 100, completed: false),
      ],
      totalXpReward: 650,
      totalCoinReward: 280,
      specialBadge: 'Math Champion',
      isActive: true,
    ),
    WeeklyChallenge(
      week: 2,
      title: 'English Explorer Week',
      description: 'Enhance your vocabulary and grammar',
      theme: 'English',
      icon: Icons.menu_book,
      color: AppColors.englishGreen,
      startDate: DateTime(2026, 3, 8),
      endDate: DateTime(2026, 3, 14),
      challenges: [
        DailyChallenge(day: 1, title: 'Vocabulary Builder', type: 'English', difficulty: 'Easy', xpReward: 50, coinReward: 20, completed: false),
        DailyChallenge(day: 2, title: 'Grammar Basics', type: 'English', difficulty: 'Easy', xpReward: 50, coinReward: 20, completed: false),
        DailyChallenge(day: 3, title: 'Reading Comprehension', type: 'English', difficulty: 'Medium', xpReward: 75, coinReward: 30, completed: false),
        DailyChallenge(day: 4, title: 'Spelling Bee', type: 'English', difficulty: 'Medium', xpReward: 75, coinReward: 30, completed: false),
        DailyChallenge(day: 5, title: 'Idioms & Phrases', type: 'English', difficulty: 'Hard', xpReward: 100, coinReward: 40, completed: false),
        DailyChallenge(day: 6, title: 'Creative Writing', type: 'English', difficulty: 'Hard', xpReward: 100, coinReward: 40, completed: false),
        DailyChallenge(day: 7, title: 'English Master', type: 'English', difficulty: 'Expert', xpReward: 200, coinReward: 100, completed: false),
      ],
      totalXpReward: 650,
      totalCoinReward: 280,
      specialBadge: 'English Master',
      isActive: false,
    ),
    WeeklyChallenge(
      week: 3,
      title: 'Science Discovery Week',
      description: 'Explore biology, chemistry, and physics',
      theme: 'Science',
      icon: Icons.science,
      color: AppColors.sciencePurple,
      startDate: DateTime(2026, 3, 15),
      endDate: DateTime(2026, 3, 21),
      challenges: [
        DailyChallenge(day: 1, title: 'Living Things', type: 'Science', difficulty: 'Easy', xpReward: 50, coinReward: 20, completed: false),
        DailyChallenge(day: 2, title: 'Matter Matters', type: 'Science', difficulty: 'Easy', xpReward: 50, coinReward: 20, completed: false),
        DailyChallenge(day: 3, title: 'Forces & Motion', type: 'Science', difficulty: 'Medium', xpReward: 75, coinReward: 30, completed: false),
        DailyChallenge(day: 4, title: 'Solar System', type: 'Science', difficulty: 'Medium', xpReward: 75, coinReward: 30, completed: false),
        DailyChallenge(day: 5, title: 'Human Body', type: 'Science', difficulty: 'Hard', xpReward: 100, coinReward: 40, completed: false),
        DailyChallenge(day: 6, title: 'Chemical Reactions', type: 'Science', difficulty: 'Hard', xpReward: 100, coinReward: 40, completed: false),
        DailyChallenge(day: 7, title: 'Science Genius', type: 'Science', difficulty: 'Expert', xpReward: 200, coinReward: 100, completed: false),
      ],
      totalXpReward: 650,
      totalCoinReward: 280,
      specialBadge: 'Science Genius',
      isActive: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Weekly Challenges'),
        backgroundColor: AppColors.neonPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "📅 Current", icon: Icon(Icons.today)),
            Tab(text: "🏆 Past", icon: Icon(Icons.history)),
            Tab(text: "🎁 Rewards", icon: Icon(Icons.card_giftcard)),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildCurrentWeekChallenges(game),
            _buildPastWeeksChallenges(),
            _buildRewardsGallery(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentWeekChallenges(GameProvider game) {
    final currentWeek = _weeklyChallenges.firstWhere((w) => w.isActive, orElse: () => _weeklyChallenges[0]);
    final completedCount = currentWeek.challenges.where((c) => c.completed).length;
    final progress = completedCount / currentWeek.challenges.length;
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildWeekHeader(currentWeek, completedCount, progress),
          const SizedBox(height: 20),
          _buildDailyChallengesList(currentWeek),
          const SizedBox(height: 20),
          _buildWeekProgressCard(completedCount, currentWeek.challenges.length, progress),
          const SizedBox(height: 20),
          _buildCompletionBonusCard(currentWeek, completedCount),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildWeekHeader(WeeklyChallenge week, int completedCount, double progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [week.color, week.color.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: week.color.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(week.icon, size: 30, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Week ${week.week} Challenge',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      week.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: week.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            week.description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(Icons.calendar_today, '${week.startDate.day}/${week.startDate.month} - ${week.endDate.day}/${week.endDate.month}'),
              const SizedBox(width: 8),
              _buildInfoChip(Icons.emoji_events, '${week.totalXpReward} XP'),
              const SizedBox(width: 8),
              _buildInfoChip(Icons.monetization_on, '${week.totalCoinReward} coins'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyChallengesList(WeeklyChallenge week) {
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
              Icon(Icons.list_alt, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Daily Challenges',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...week.challenges.map((challenge) => _buildChallengeTile(challenge, week.color)),
        ],
      ),
    );
  }

  Widget _buildChallengeTile(DailyChallenge challenge, Color weekColor) {
    final isToday = challenge.day == DateTime.now().day % 7 + 1;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: challenge.completed 
            ? AppColors.mintGreen.withValues(alpha: 0.1)
            : (isToday ? weekColor.withValues(alpha: 0.1) : Colors.grey.shade50),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: challenge.completed 
              ? AppColors.mintGreen 
              : (isToday ? weekColor : Colors.grey.shade200),
          width: challenge.completed ? 1 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: challenge.completed 
                  ? AppColors.mintGreen 
                  : (isToday ? weekColor : Colors.grey.shade300),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${challenge.day}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: challenge.completed || isToday ? Colors.white : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: challenge.completed ? AppColors.mintGreen : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${challenge.type} • ${challenge.difficulty}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, size: 12, color: AppColors.gold),
                  const SizedBox(width: 2),
                  Text(
                    '+${challenge.xpReward}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.monetization_on, size: 12, color: AppColors.gold),
                  const SizedBox(width: 2),
                  Text(
                    '+${challenge.coinReward}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              if (challenge.completed)
                const Text(
                  'Completed ✓',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.mintGreen,
                    fontWeight: FontWeight.bold,
                  ),
                )
              else if (isToday)
                ElevatedButton(
                  onPressed: () {
                    _startChallenge(challenge);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: weekColor,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Play',
                    style: TextStyle(fontSize: 12),
                  ),
                )
              else
                const Text(
                  'Locked',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekProgressCard(int completedCount, int totalCount, double progress) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Icon(Icons.trending_up, color: AppColors.gold),
              SizedBox(width: 8),
              Text(
                'Weekly Progress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$completedCount of $totalCount challenges completed',
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation(AppColors.gold),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionBonusCard(WeeklyChallenge week, int completedCount) {
    final isFullyComplete = completedCount == week.challenges.length;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isFullyComplete
            ? LinearGradient(
                colors: [AppColors.mintGreen, AppColors.neonGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isFullyComplete ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isFullyComplete ? Colors.transparent : AppColors.gold.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: isFullyComplete ? AppColors.mintGreen.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isFullyComplete ? Colors.white.withValues(alpha: 0.2) : AppColors.gold.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events,
              size: 30,
              color: isFullyComplete ? Colors.white : AppColors.gold,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isFullyComplete ? 'Week Complete!' : 'Complete All 7 Days',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isFullyComplete ? Colors.white : AppColors.neonPurple,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isFullyComplete 
                      ? 'You earned the ${week.specialBadge} badge!'
                      : 'Earn the ${week.specialBadge} badge + ${week.totalXpReward} bonus XP',
                  style: TextStyle(
                    fontSize: 11,
                    color: isFullyComplete ? Colors.white70 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (isFullyComplete)
            const Icon(Icons.check_circle, color: Colors.white, size: 30),
        ],
      ),
    );
  }

  Widget _buildPastWeeksChallenges() {
    final pastWeeks = _weeklyChallenges.where((w) => !w.isActive).toList();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: pastWeeks.length,
      itemBuilder: (context, index) {
        final week = pastWeeks[index];
        return _buildPastWeekCard(week);
      },
    );
  }

  Widget _buildPastWeekCard(WeeklyChallenge week) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [week.color, week.color.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(week.icon, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Week ${week.week}: ${week.title}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${week.startDate.day}/${week.startDate.month} - ${week.endDate.day}/${week.endDate.month}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.emoji_events, size: 12, color: AppColors.gold),
                    const SizedBox(width: 2),
                    Text(
                      week.specialBadge,
                      style: const TextStyle(fontSize: 11, color: AppColors.gold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.mintGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle, color: AppColors.mintGreen),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsGallery() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: _weeklyChallenges.length,
      itemBuilder: (context, index) {
        final week = _weeklyChallenges[index];
        return _buildRewardCard(week);
      },
    );
  }

  Widget _buildRewardCard(WeeklyChallenge week) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [week.color.withValues(alpha: 0.1), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: week.color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: week.color,
              shape: BoxShape.circle,
            ),
            child: Icon(week.icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 12),
          Text(
            week.specialBadge,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: week.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Week ${week.week}',
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, size: 12, color: AppColors.gold),
              const SizedBox(width: 2),
              Text(
                '+${week.totalXpReward}',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.monetization_on, size: 12, color: AppColors.gold),
              const SizedBox(width: 2),
              Text(
                '+${week.totalCoinReward}',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _startChallenge(DailyChallenge challenge) {
    final challengeData = {
      'title': challenge.title,
      'type': challenge.type,
      'difficulty': challenge.difficulty,
      'xpReward': challenge.xpReward,
      'coinReward': challenge.coinReward,
      'questionCount': 10,
      'color': _getSubjectColor(challenge.type),
      'icon': _getSubjectIcon(challenge.type),
    };
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChallengeDetailScreen(
          challenge: challengeData,
          challengeIndex: challenge.day,
        ),
      ),
    ).then((_) {
      setState(() {
        challenge.completed = true;
      });
    });
  }

  Color _getSubjectColor(String type) {
    switch (type) {
      case 'Math': return AppColors.mathOrange;
      case 'English': return AppColors.englishGreen;
      case 'Science': return AppColors.sciencePurple;
      default: return AppColors.neonBlue;
    }
  }

  IconData _getSubjectIcon(String type) {
    switch (type) {
      case 'Math': return Icons.calculate;
      case 'English': return Icons.menu_book;
      case 'Science': return Icons.science;
      default: return Icons.quiz;
    }
  }
}

class WeeklyChallenge {
  final int week;
  final String title;
  final String description;
  final String theme;
  final IconData icon;
  final Color color;
  final DateTime startDate;
  final DateTime endDate;
  final List<DailyChallenge> challenges;
  final int totalXpReward;
  final int totalCoinReward;
  final String specialBadge;
  final bool isActive;

  WeeklyChallenge({
    required this.week,
    required this.title,
    required this.description,
    required this.theme,
    required this.icon,
    required this.color,
    required this.startDate,
    required this.endDate,
    required this.challenges,
    required this.totalXpReward,
    required this.totalCoinReward,
    required this.specialBadge,
    required this.isActive,
  });
}

class DailyChallenge {
  final int day;
  final String title;
  final String type;
  final String difficulty;
  final int xpReward;
  final int coinReward;
  bool completed;

  DailyChallenge({
    required this.day,
    required this.title,
    required this.type,
    required this.difficulty,
    required this.xpReward,
    required this.coinReward,
    required this.completed,
  });
}