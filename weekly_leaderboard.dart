import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../../providers/auth_provider.dart';

class WeeklyLeaderboardScreen extends StatefulWidget {
  const WeeklyLeaderboardScreen({super.key});

  @override
  State<WeeklyLeaderboardScreen> createState() => _WeeklyLeaderboardScreenState();
}

class _WeeklyLeaderboardScreenState extends State<WeeklyLeaderboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  int _selectedWeek = 0;
  String _selectedCategory = 'Overall';
  
  final List<String> _categories = ['Overall', 'Math', 'English', 'Science'];
  
  // Weekly leaderboard data
  final List<Map<String, dynamic>> _weeklyLeaders = [
    {'rank': 1, 'name': 'Emma Watson', 'score': 1850, 'level': 25, 'avatar': 'E', 'color': AppColors.gold, 'badge': '🥇', 'streak': 7, 'improvement': '+250'},
    {'rank': 2, 'name': 'Liam Smith', 'score': 1720, 'level': 23, 'avatar': 'L', 'color': AppColors.silver, 'badge': '🥈', 'streak': 7, 'improvement': '+180'},
    {'rank': 3, 'name': 'Sophia Lee', 'score': 1680, 'level': 22, 'avatar': 'S', 'color': AppColors.bronze, 'badge': '🥉', 'streak': 6, 'improvement': '+220'},
    {'rank': 4, 'name': 'Noah Chen', 'score': 1550, 'level': 21, 'avatar': 'N', 'color': Colors.blue, 'badge': '', 'streak': 5, 'improvement': '+150'},
    {'rank': 5, 'name': 'Olivia Kim', 'score': 1480, 'level': 20, 'avatar': 'O', 'color': AppColors.englishGreen, 'badge': '', 'streak': 5, 'improvement': '+120'},
    {'rank': 6, 'name': 'Mason Brown', 'score': 1420, 'level': 19, 'avatar': 'M', 'color': AppColors.mathOrange, 'badge': '', 'streak': 4, 'improvement': '+90'},
    {'rank': 7, 'name': 'Isabella Garcia', 'score': 1380, 'level': 18, 'avatar': 'I', 'color': AppColors.sciencePurple, 'badge': '', 'streak': 4, 'improvement': '+110'},
    {'rank': 8, 'name': 'Ethan Wilson', 'score': 1320, 'level': 18, 'avatar': 'E', 'color': AppColors.adventureTeal, 'badge': '', 'streak': 3, 'improvement': '+80'},
    {'rank': 9, 'name': 'Mia Johnson', 'score': 1280, 'level': 17, 'avatar': 'M', 'color': AppColors.bubblegumPink, 'badge': '', 'streak': 3, 'improvement': '+95'},
    {'rank': 10, 'name': 'James Davis', 'score': 1250, 'level': 16, 'avatar': 'J', 'color': AppColors.lavenderPurple, 'badge': '', 'streak': 2, 'improvement': '+60'},
  ];
  
  // Math weekly leaders
  final List<Map<String, dynamic>> _mathLeaders = [
    {'rank': 1, 'name': 'Emma Watson', 'score': 620, 'level': 25, 'avatar': 'E', 'improvement': '+80'},
    {'rank': 2, 'name': 'Noah Chen', 'score': 580, 'level': 21, 'avatar': 'N', 'improvement': '+75'},
    {'rank': 3, 'name': 'Liam Smith', 'score': 550, 'level': 23, 'avatar': 'L', 'improvement': '+70'},
    {'rank': 4, 'name': 'Mason Brown', 'score': 510, 'level': 19, 'avatar': 'M', 'improvement': '+65'},
    {'rank': 5, 'name': 'Olivia Kim', 'score': 480, 'level': 20, 'avatar': 'O', 'improvement': '+60'},
  ];
  
  // English weekly leaders
  final List<Map<String, dynamic>> _englishLeaders = [
    {'rank': 1, 'name': 'Sophia Lee', 'score': 590, 'level': 22, 'avatar': 'S', 'improvement': '+85'},
    {'rank': 2, 'name': 'Olivia Kim', 'score': 560, 'level': 20, 'avatar': 'O', 'improvement': '+80'},
    {'rank': 3, 'name': 'Isabella Garcia', 'score': 530, 'level': 18, 'avatar': 'I', 'improvement': '+75'},
    {'rank': 4, 'name': 'Emma Watson', 'score': 500, 'level': 25, 'avatar': 'E', 'improvement': '+70'},
    {'rank': 5, 'name': 'Mia Johnson', 'score': 470, 'level': 17, 'avatar': 'M', 'improvement': '+65'},
  ];
  
  // Science weekly leaders
  final List<Map<String, dynamic>> _scienceLeaders = [
    {'rank': 1, 'name': 'Mason Brown', 'score': 570, 'level': 19, 'avatar': 'M', 'improvement': '+90'},
    {'rank': 2, 'name': 'Ethan Wilson', 'score': 540, 'level': 18, 'avatar': 'E', 'improvement': '+85'},
    {'rank': 3, 'name': 'Sophia Lee', 'score': 510, 'level': 22, 'avatar': 'S', 'improvement': '+80'},
    {'rank': 4, 'name': 'Liam Smith', 'score': 480, 'level': 23, 'avatar': 'L', 'improvement': '+75'},
    {'rank': 5, 'name': 'Isabella Garcia', 'score': 450, 'level': 18, 'avatar': 'I', 'improvement': '+70'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
    final auth = Provider.of<AuthProvider>(context);
    
    // Calculate user's weekly rank and score
    int userRank = _weeklyLeaders.indexWhere((l) => (l['score'] as int) < game.totalScore) + 1;
    if (userRank == 0) userRank = _weeklyLeaders.length + 1;
    int userWeeklyScore = game.totalScore ~/ 4; // Simulated weekly score
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Weekly Leaderboard'),
        backgroundColor: AppColors.neonOrange,
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
            Tab(text: "🏆 Rankings", icon: Icon(Icons.emoji_events)),
            Tab(text: "📊 Stats", icon: Icon(Icons.bar_chart)),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildRankingsTab(game, auth, userRank, userWeeklyScore),
            _buildStatsTab(game, auth),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingsTab(GameProvider game, AuthProvider auth, int userRank, int userWeeklyScore) {
    List<Map<String, dynamic>> displayedLeaders = [];
    
    switch (_selectedCategory) {
      case 'Math':
        displayedLeaders = _mathLeaders;
        break;
      case 'English':
        displayedLeaders = _englishLeaders;
        break;
      case 'Science':
        displayedLeaders = _scienceLeaders;
        break;
      default:
        displayedLeaders = _weeklyLeaders;
    }
    
    return Column(
      children: [
        _buildWeekSelector(),
        _buildCategoryFilter(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            itemCount: displayedLeaders.length,
            itemBuilder: (context, index) {
              final leader = displayedLeaders[index];
              final isCurrentUser = (leader['name'] as String) == auth.userName;
              return _buildLeaderCard(leader, index + 1, isCurrentUser);
            },
          ),
        ),
        _buildUserRankCard(userRank, userWeeklyScore, auth),
      ],
    );
  }

  Widget _buildWeekSelector() {
    final weeks = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
    
    return Container(
      margin: const EdgeInsets.all(16),
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
        children: weeks.asMap().entries.map((entry) {
          final index = entry.key;
          final week = entry.value;
          final isSelected = _selectedWeek == index;
          
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedWeek = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.neonOrange : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  week,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryFilter() {
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
        children: _categories.asMap().entries.map((entry) {
          final index = entry.key;
          final category = entry.value;
          final isSelected = _selectedCategory == category;
          
          Color getCategoryColor() {
            switch (category) {
              case 'Math': return AppColors.mathOrange;
              case 'English': return AppColors.englishGreen;
              case 'Science': return AppColors.sciencePurple;
              default: return AppColors.neonOrange;
            }
          }
          
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? getCategoryColor() : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  category,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLeaderCard(Map<String, dynamic> leader, int rank, bool isCurrentUser) {
    final isTop3 = rank <= 3;
    final improvement = leader['improvement'] as String;
    final isPositive = improvement.startsWith('+');
    final leaderColor = leader['color'] as Color;
    final leaderBadge = (leader['badge'] as String?) ?? '';
    final leaderName = leader['name'] as String;
    final leaderAvatar = leader['avatar'] as String;
    final leaderLevel = leader['level'] as int;
    final leaderStreak = leader['streak'] as int;
    final leaderScore = leader['score'] as int;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isCurrentUser
            ? LinearGradient(
                colors: [AppColors.gold.withValues(alpha: 0.15), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isCurrentUser ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isCurrentUser
            ? Border.all(color: AppColors.gold, width: 2)
            : (isTop3 ? Border.all(color: leaderColor, width: 1) : null),
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
          // Rank
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              gradient: isTop3
                  ? LinearGradient(
                      colors: rank == 1 ? [AppColors.gold, AppColors.warningOrange] :
                      rank == 2 ? [AppColors.silver, Colors.grey] :
                      [AppColors.bronze, const Color(0xFFB87333)],
                    )
                  : null,
              color: !isTop3 ? Colors.grey.shade200 : null,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isTop3
                  ? Text(
                      rank == 1 ? '🥇' : (rank == 2 ? '🥈' : '🥉'),
                      style: const TextStyle(fontSize: 22),
                    )
                  : Text(
                      '$rank',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [leaderColor, leaderColor.withValues(alpha: 0.7)],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                leaderAvatar,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Name and details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      leaderName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isCurrentUser ? AppColors.gold : Colors.black87,
                      ),
                    ),
                    if (leaderBadge.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Text(leaderBadge, style: const TextStyle(fontSize: 14)),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Level $leaderLevel • $leaderStreak day streak',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          // Score and improvement
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${leaderScore} pts',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isTop3 ? leaderColor : Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isPositive ? AppColors.mintGreen.withValues(alpha: 0.1) : AppColors.errorRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  improvement,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isPositive ? AppColors.mintGreen : AppColors.errorRed,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserRankCard(int userRank, int userWeeklyScore, AuthProvider auth) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.neonOrange, AppColors.warningOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonOrange.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                auth.userName?[0].toUpperCase() ?? 'U',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Weekly Rank',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  '#$userRank',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  '$userWeeklyScore',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.neonOrange,
                  ),
                ),
                const Text(
                  'points',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsTab(GameProvider game, AuthProvider auth) {
    // Calculate weekly stats
    final weeklyGain = 450;
    final weeklyGames = 12;
    final weeklyAccuracy = 85;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildStatsHeader(weeklyGain, weeklyGames, weeklyAccuracy),
          const SizedBox(height: 20),
          _buildDailyPerformanceChart(),
          const SizedBox(height: 20),
          _buildSubjectBreakdown(),
          const SizedBox(height: 20),
          _buildMilestonesCard(),
          const SizedBox(height: 20),
          _buildWeeklyTipsCard(),
        ],
      ),
    );
  }

  Widget _buildStatsHeader(int weeklyGain, int weeklyGames, int weeklyAccuracy) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.trending_up,
            value: '+$weeklyGain',
            label: 'Points Gained',
            color: AppColors.mintGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.videogame_asset,
            value: '$weeklyGames',
            label: 'Games Played',
            color: AppColors.neonBlue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.percent,
            value: '$weeklyAccuracy%',
            label: 'Accuracy',
            color: AppColors.gold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({required IconData icon, required String value, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
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
          Icon(icon, color: color, size: 28),
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
          ),
        ],
      ),
    );
  }

  Widget _buildDailyPerformanceChart() {
    final dailyData = [
      {'day': 'Mon', 'score': 120, 'color': AppColors.mathOrange},
      {'day': 'Tue', 'score': 180, 'color': AppColors.mathOrange},
      {'day': 'Wed', 'score': 150, 'color': AppColors.mathOrange},
      {'day': 'Thu', 'score': 200, 'color': AppColors.mathOrange},
      {'day': 'Fri', 'score': 170, 'color': AppColors.mathOrange},
      {'day': 'Sat', 'score': 320, 'color': AppColors.gold},
      {'day': 'Sun', 'score': 280, 'color': AppColors.mathOrange},
    ];
    
    final maxScore = 350;
    
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
              Icon(Icons.bar_chart, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Daily Performance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: Row(
              children: dailyData.map((day) {
                final score = day['score'] as int;
                final height = score / maxScore * 120;
                final dayColor = day['color'] as Color;
                final dayName = day['day'] as String;
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: height,
                        width: 30,
                        decoration: BoxDecoration(
                          color: dayColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '$score',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dayName,
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectBreakdown() {
    final subjects = [
      {'name': 'Mathematics', 'score': 620, 'color': AppColors.mathOrange, 'icon': Icons.calculate},
      {'name': 'English', 'score': 560, 'color': AppColors.englishGreen, 'icon': Icons.menu_book},
      {'name': 'Science', 'score': 510, 'color': AppColors.sciencePurple, 'icon': Icons.science},
    ];
    
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
              Icon(Icons.pie_chart, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Subject Breakdown',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...subjects.map((subject) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(subject['icon'] as IconData, size: 16, color: subject['color'] as Color),
                        const SizedBox(width: 6),
                        Text(
                          subject['name'] as String,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    Text(
                      '${subject['score']} pts',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: subject['color'] as Color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (subject['score'] as int) / 700,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(subject['color'] as Color),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildMilestonesCard() {
    final milestones = [
      {'achieved': true, 'title': 'Play 10 games this week', 'progress': 1.0, 'reward': '50 XP'},
      {'achieved': true, 'title': 'Score 500 points', 'progress': 1.0, 'reward': '100 XP'},
      {'achieved': false, 'title': 'Maintain 7-day streak', 'progress': 0.85, 'reward': '200 XP'},
      {'achieved': false, 'title': 'Complete all subjects', 'progress': 0.6, 'reward': '150 XP'},
    ];
    
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
              Icon(Icons.flag, color: AppColors.gold),
              SizedBox(width: 8),
              Text(
                'Weekly Milestones',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...milestones.map((milestone) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Icon(
                  milestone['achieved'] as bool ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: milestone['achieved'] as bool ? AppColors.mintGreen : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        milestone['title'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          decoration: milestone['achieved'] as bool ? TextDecoration.lineThrough : null,
                          color: milestone['achieved'] as bool ? Colors.grey : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: milestone['progress'] as double,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation(AppColors.gold),
                          minHeight: 3,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  milestone['reward'] as String,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gold,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildWeeklyTipsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neonBlue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neonBlue.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.neonBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lightbulb, color: AppColors.neonBlue, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weekly Tip',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.neonBlue,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Play daily to maintain your streak and earn bonus points!',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}