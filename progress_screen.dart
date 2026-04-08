import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/theme.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  String _selectedTimeRange = 'Weekly';
  int _selectedChartIndex = 0; // 0 = Score, 1 = Accuracy, 2 = Time

  // Sample weekly data
  final List<Map<String, dynamic>> _weeklyData = [
    {'day': 'Mon', 'score': 450, 'accuracy': 85, 'time': 15},
    {'day': 'Tue', 'score': 520, 'accuracy': 88, 'time': 18},
    {'day': 'Wed', 'score': 380, 'accuracy': 82, 'time': 12},
    {'day': 'Thu', 'score': 610, 'accuracy': 92, 'time': 22},
    {'day': 'Fri', 'score': 490, 'accuracy': 86, 'time': 16},
    {'day': 'Sat', 'score': 720, 'accuracy': 94, 'time': 28},
    {'day': 'Sun', 'score': 580, 'accuracy': 89, 'time': 20},
  ];

  // Sample monthly data
  final List<Map<String, dynamic>> _monthlyData = [
    {'week': 'Week 1', 'score': 1850, 'accuracy': 84, 'time': 65},
    {'week': 'Week 2', 'score': 2100, 'accuracy': 87, 'time': 78},
    {'week': 'Week 3', 'score': 1950, 'accuracy': 86, 'time': 72},
    {'week': 'Week 4', 'score': 2450, 'accuracy': 91, 'time': 85},
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
    
    int totalGamesPlayed = game.completedLevels.length * 3 + (game.totalScore ~/ 100);
    int badgesEarned = _calculateBadgesEarned(game.totalScore);
    double overallProgress = game.completedLevels.length / 8;
    int averageAccuracy = ((game.subjectScores.values.reduce((a, b) => a + b) / 3000) * 100).toInt().clamp(0, 100);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: CustomScrollView(
            slivers: [
              _buildSliverHeader(game, auth, totalGamesPlayed, badgesEarned, averageAccuracy),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildTimeRangeSelector(),
                      const SizedBox(height: 20),
                      _buildChartCard(),
                      const SizedBox(height: 20),
                      _buildStatisticsGrid(game, totalGamesPlayed, badgesEarned, overallProgress, averageAccuracy),
                      const SizedBox(height: 20),
                      _buildSubjectPerformanceCard(game),
                      const SizedBox(height: 20),
                      _buildLevelCompletionCard(game),
                      const SizedBox(height: 20),
                      _buildRankAndTitleCard(game.totalScore),
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

  Widget _buildSliverHeader(GameProvider game, AuthProvider auth, int totalGamesPlayed, int badgesEarned, int averageAccuracy) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.neonGreen, AppColors.mintGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Progress',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black26)],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Keep up the great work, ${auth.userName}!',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildHeaderStat('Total Score', '${game.totalScore}', AppColors.gold),
                      _buildHeaderStat('Games Played', '$totalGamesPlayed', AppColors.brightCyan),
                      _buildHeaderStat('Badges', '$badgesEarned', AppColors.neonOrange),
                      _buildHeaderStat('Accuracy', '$averageAccuracy%', AppColors.neonPink),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
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

  Widget _buildTimeRangeSelector() {
    final ranges = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
    
    return Container(
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
        children: ranges.map((range) {
          final isSelected = _selectedTimeRange == range;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTimeRange = range;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.neonBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  range,
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

  Widget _buildChartCard() {
    final data = _selectedTimeRange == 'Weekly' ? _weeklyData : _monthlyData;
    final maxScore = data.map((d) => d['score'] as int).reduce((a, b) => a > b ? a : b);
    
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.show_chart, color: AppColors.neonBlue),
                  SizedBox(width: 8),
                  Text(
                    'Performance Chart',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonPurple,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildChartTypeButton('Score', 0),
                  const SizedBox(width: 8),
                  _buildChartTypeButton('Accuracy', 1),
                  const SizedBox(width: 8),
                  _buildChartTypeButton('Time', 2),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: Row(
              children: [
                _buildYAxis(data),
                const SizedBox(width: 10),
                Expanded(
                  child: _selectedChartIndex == 0
                      ? _buildScoreChart(data, maxScore)
                      : _selectedChartIndex == 1
                          ? _buildAccuracyChart(data)
                          : _buildTimeChart(data),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildXAxis(data),
        ],
      ),
    );
  }

  Widget _buildChartTypeButton(String label, int index) {
    final isSelected = _selectedChartIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedChartIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.neonBlue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildYAxis(List<Map<String, dynamic>> data) {
    final values = _selectedChartIndex == 0
        ? data.map((d) => d['score'] as int).toList()
        : _selectedChartIndex == 1
            ? data.map((d) => d['accuracy'] as int).toList()
            : data.map((d) => d['time'] as int).toList();
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final minVal = values.reduce((a, b) => a < b ? a : b);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$maxVal',
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
        Text(
          '${(maxVal + minVal) ~/ 2}',
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
        Text(
          '$minVal',
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildScoreChart(List<Map<String, dynamic>> data, int maxScore) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: data.map((item) {
        final height = (item['score'] as int) / maxScore * 180;
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 30,
              height: height,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.neonBlue, AppColors.neonPurple],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '${item['score']}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildAccuracyChart(List<Map<String, dynamic>> data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: data.map((item) {
        final height = (item['accuracy'] as int) / 100 * 180;
        Color barColor;
        if (item['accuracy'] >= 90) {
          barColor = AppColors.mintGreen;
        } else if (item['accuracy'] >= 75) {
          barColor = AppColors.gold;
        } else {
          barColor = AppColors.warningOrange;
        }
        
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 30,
              height: height,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '${item['accuracy']}%',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTimeChart(List<Map<String, dynamic>> data) {
    final maxTime = data.map((d) => d['time'] as int).reduce((a, b) => a > b ? a : b);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: data.map((item) {
        final height = (item['time'] as int) / maxTime * 180;
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 30,
              height: height,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.warningOrange, AppColors.gold],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '${item['time']}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildXAxis(List<Map<String, dynamic>> data) {
    final labels = _selectedTimeRange == 'Weekly' 
        ? data.map((d) => d['day'] as String).toList()
        : data.map((d) => d['week'] as String).toList();
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: labels.map((label) {
        return SizedBox(
          width: 30,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatisticsGrid(GameProvider game, int totalGamesPlayed, int badgesEarned, double overallProgress, int averageAccuracy) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          icon: Icons.star,
          value: '${game.totalScore}',
          label: 'Total Points',
          color: AppColors.gold,
          gradientColors: [AppColors.gold, AppColors.warningOrange],
        ),
        _buildStatCard(
          icon: Icons.videogame_asset,
          value: '$totalGamesPlayed',
          label: 'Games Completed',
          color: AppColors.neonBlue,
          gradientColors: [AppColors.neonBlue, AppColors.neonPurple],
        ),
        _buildStatCard(
          icon: Icons.emoji_events,
          value: '$badgesEarned',
          label: 'Badges Earned',
          color: AppColors.neonOrange,
          gradientColors: [AppColors.neonOrange, AppColors.brightRed],
        ),
        _buildStatCard(
          icon: Icons.percent,
          value: '$averageAccuracy%',
          label: 'Avg Accuracy',
          color: AppColors.mintGreen,
          gradientColors: [AppColors.mintGreen, AppColors.neonGreen],
        ),
        _buildStatCard(
          icon: Icons.key,
          value: '${game.collectedKeys}',
          label: 'Keys Collected',
          color: AppColors.gold,
          gradientColors: [AppColors.gold, AppColors.warningOrange],
        ),
        _buildStatCard(
          icon: Icons.local_fire_department,
          value: '${game.dailyStreak}',
          label: 'Day Streak',
          color: AppColors.errorRed,
          gradientColors: [AppColors.errorRed, AppColors.brightRed],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required List<Color> gradientColors,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
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
            style: const TextStyle(fontSize: 11, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectPerformanceCard(GameProvider game) {
    final subjects = [
      {'name': 'Mathematics', 'score': game.subjectScores['Math'] ?? 0, 'color': AppColors.mathOrange, 'icon': Icons.calculate, 'maxScore': 2000},
      {'name': 'English', 'score': game.subjectScores['English'] ?? 0, 'color': AppColors.englishGreen, 'icon': Icons.menu_book, 'maxScore': 2000},
      {'name': 'Science', 'score': game.subjectScores['Science'] ?? 0, 'color': AppColors.sciencePurple, 'icon': Icons.science, 'maxScore': 2000},
    ];
    
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
              Icon(Icons.school, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Subject Performance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...subjects.map((subject) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildSubjectProgress(
              name: subject['name'] as String,
              score: subject['score'] as int,
              maxScore: subject['maxScore'] as int,
              color: subject['color'] as Color,
              icon: subject['icon'] as IconData,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSubjectProgress({
    required String name,
    required int score,
    required int maxScore,
    required Color color,
    required IconData icon,
  }) {
    double progress = (score / maxScore).clamp(0.0, 1.0);
    String rank;
    if (progress >= 0.9) {
      rank = 'Master';
    } else if (progress >= 0.7) {
      rank = 'Advanced';
    } else if (progress >= 0.5) {
      rank = 'Intermediate';
    } else if (progress >= 0.3) {
      rank = 'Beginner';
    } else {
      rank = 'Novice';
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      rank,
                      style: TextStyle(
                        fontSize: 10,
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              '$score / $maxScore',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(progress * 100).toInt()}% Complete',
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
            ),
            Text(
              '${maxScore - score} XP to next rank',
              style: TextStyle(fontSize: 10, color: color.withValues(alpha: 0.7)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLevelCompletionCard(GameProvider game) {
    final levels = List.generate(8, (i) => i + 1);
    final completedLevels = game.completedLevels;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.adventureTeal, AppColors.neonCyan],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.adventureTeal.withValues(alpha: 0.3),
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
              Icon(Icons.map, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Adventure Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: levels.map((level) {
              final isCompleted = completedLevels.contains(level);
              final isCurrent = level == game.currentLevel;
              
              return Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.mintGreen
                          : (isCurrent ? AppColors.gold : Colors.white.withValues(alpha: 0.3)),
                      shape: BoxShape.circle,
                      border: isCurrent
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check, color: Colors.white, size: 20)
                          : Text(
                              '$level',
                              style: TextStyle(
                                color: isCurrent ? Colors.white : Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isCompleted)
                    const Icon(Icons.star, color: AppColors.gold, size: 12),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: completedLevels.length / 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(AppColors.gold),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${completedLevels.length} of 8 Levels Completed',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              Text(
                '${((completedLevels.length / 8) * 100).toInt()}%',
                style: const TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankAndTitleCard(int totalScore) {
    String rankTitle;
    String rankEmoji;
    Color rankColor;
    
    if (totalScore >= 10000) {
      rankTitle = 'Legendary Master';
      rankEmoji = '👑';
      rankColor = AppColors.gold;
    } else if (totalScore >= 5000) {
      rankTitle = 'Diamond Explorer';
      rankEmoji = '💎';
      rankColor = AppColors.neonCyan;
    } else if (totalScore >= 3500) {
      rankTitle = 'Platinum Adventurer';
      rankEmoji = '⭐';
      rankColor = AppColors.neonBlue;
    } else if (totalScore >= 2000) {
      rankTitle = 'Gold Learner';
      rankEmoji = '🥇';
      rankColor = AppColors.gold;
    } else if (totalScore >= 1000) {
      rankTitle = 'Silver Student';
      rankEmoji = '🥈';
      rankColor = AppColors.silver;
    } else if (totalScore >= 500) {
      rankTitle = 'Bronze Beginner';
      rankEmoji = '🥉';
      rankColor = AppColors.bronze;
    } else {
      rankTitle = 'Novice Player';
      rankEmoji = '🌟';
      rankColor = AppColors.neonGreen;
    }
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [rankColor.withValues(alpha: 0.2), rankColor.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: rankColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [rankColor, rankColor.withValues(alpha: 0.7)],
              ),
              shape: BoxShape.circle,
            ),
            child: Text(
              rankEmoji,
              style: const TextStyle(fontSize: 32),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Rank',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  rankTitle,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: rankColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_calculateNextRankProgress(totalScore)% to next rank',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: rankColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$totalScore pts',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: rankColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateBadgesEarned(int totalScore) {
    int count = 0;
    if (totalScore >= 50) count++;
    if (totalScore >= 500) count++;
    if (totalScore >= 1000) count++;
    if (totalScore >= 2000) count++;
    if (totalScore >= 3500) count++;
    if (totalScore >= 5000) count++;
    if (totalScore >= 7500) count++;
    if (totalScore >= 10000) count++;
    return count.clamp(0, 10);
  }

  int _calculateNextRankProgress(int totalScore) {
    if (totalScore >= 10000) return 100;
    if (totalScore >= 5000) return ((totalScore - 5000) / 5000 * 100).toInt();
    if (totalScore >= 3500) return ((totalScore - 3500) / 1500 * 100).toInt();
    if (totalScore >= 2000) return ((totalScore - 2000) / 1500 * 100).toInt();
    if (totalScore >= 1000) return ((totalScore - 1000) / 1000 * 100).toInt();
    if (totalScore >= 500) return ((totalScore - 500) / 500 * 100).toInt();
    return (totalScore / 500 * 100).toInt();
  }
}