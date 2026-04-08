import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../../providers/auth_provider.dart';

class SubjectProgressScreen extends StatefulWidget {
  const SubjectProgressScreen({super.key});

  @override
  State<SubjectProgressScreen> createState() => _SubjectProgressScreenState();
}

class _SubjectProgressScreenState extends State<SubjectProgressScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String _selectedSubject = 'Math';
  String _selectedTimeRange = 'All Time';
  
  final List<String> _subjects = ['Math', 'English', 'Science'];
  final List<String> _timeRanges = ['This Week', 'This Month', 'All Time'];

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
        title: const Text('Subject Progress'),
        backgroundColor: _getSubjectColor(),
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
            Tab(text: "📊 Overview", icon: Icon(Icons.dashboard)),
            Tab(text: "📈 Analytics", icon: Icon(Icons.trending_up)),
            Tab(text: "🏆 Achievements", icon: Icon(Icons.emoji_events)),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(game),
            _buildAnalyticsTab(game),
            _buildAchievementsTab(game),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(GameProvider game) {
    final subjectScore = _getSubjectScore(game);
    final subjectProgress = subjectScore / 2000;
    final nextMilestone = _getNextMilestone(subjectScore);
    final topicsCompleted = _getTopicsCompleted(_selectedSubject);
    final totalTopics = _getTotalTopics(_selectedSubject);
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSubjectSelector(),
          const SizedBox(height: 20),
          _buildScoreCard(subjectScore, subjectProgress, nextMilestone),
          const SizedBox(height: 20),
          _buildTopicsProgressCard(topicsCompleted, totalTopics),
          const SizedBox(height: 20),
          _buildSkillBreakdownCard(),
          const SizedBox(height: 20),
          _buildRecentActivityCard(),
          const SizedBox(height: 20),
          _buildRecommendationsCard(),
        ],
      ),
    );
  }

  Widget _buildSubjectSelector() {
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
        children: _subjects.map((subject) {
          final isSelected = _selectedSubject == subject;
          Color getColor() {
            switch (subject) {
              case 'Math': return AppColors.mathOrange;
              case 'English': return AppColors.englishGreen;
              default: return AppColors.sciencePurple;
            }
          }
          
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedSubject = subject;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? getColor() : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getSubjectIcon(subject),
                      size: 18,
                      color: isSelected ? Colors.white : getColor(),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      subject,
                      style: TextStyle(
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

  Widget _buildScoreCard(int subjectScore, double progress, String nextMilestone) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Score',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            '$subjectScore',
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).toInt()}% to Mastery',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                nextMilestone,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopicsProgressCard(int completed, int total) {
    final topics = _getTopicsList(_selectedSubject);
    
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
                  Icon(Icons.topic, color: AppColors.neonBlue),
                  SizedBox(width: 8),
                  Text(
                    'Topics Progress',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonPurple,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getSubjectColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '$completed/$total Completed',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getSubjectColor(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...topics.map((topic) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildTopicItem(topic),
          )),
        ],
      ),
    );
  }

  Widget _buildTopicItem(Map<String, dynamic> topic) {
    final isCompleted = topic['progress'] >= 1.0;
    final progressPercent = (topic['progress'] * 100).toInt();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.mintGreen : _getSubjectColor().withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted ? Icons.check : topic['icon'],
                size: 18,
                color: isCompleted ? Colors.white : _getSubjectColor(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                topic['name'],
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                  color: isCompleted ? Colors.grey : Colors.black87,
                ),
              ),
            ),
            Text(
              '$progressPercent%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _getSubjectColor(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: topic['progress'],
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(_getSubjectColor()),
            minHeight: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillBreakdownCard() {
    final skills = _getSkillsBreakdown(_selectedSubject);
    
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
              Icon(Icons.analytics, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Skill Breakdown',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...skills.map((skill) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildSkillItem(skill),
          )),
        ],
      ),
    );
  }

  Widget _buildSkillItem(Map<String, dynamic> skill) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              skill['name'],
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            Text(
              '${skill['score']}%',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: _getScoreColor(skill['score']),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: skill['score'] / 100,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(_getScoreColor(skill['score'])),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivityCard() {
    final activities = _getRecentActivity(_selectedSubject);
    
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
              Icon(Icons.history, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...activities.map((activity) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (activity['color'] as Color).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(activity['icon'], color: activity['color'], size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        activity['date'],
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (activity['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+${activity['points']}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: activity['color'],
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildRecommendationsCard() {
    final recommendations = _getRecommendations(_selectedSubject);
    
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
              Icon(Icons.recommend, color: AppColors.gold),
              SizedBox(width: 8),
              Text(
                'Recommendations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...recommendations.map((rec) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.lightbulb, size: 18, color: AppColors.gold),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    rec,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab(GameProvider game) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTimeRangeSelector(),
          const SizedBox(height: 20),
          _buildPerformanceChart(),
          const SizedBox(height: 20),
          _buildWeeklyComparison(),
          const SizedBox(height: 20),
          _buildStreakAnalytics(),
          const SizedBox(height: 20),
          _buildAccuracyTrend(),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
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
        children: _timeRanges.map((range) {
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
                  color: isSelected ? _getSubjectColor() : Colors.transparent,
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

  Widget _buildPerformanceChart() {
    final data = _getChartData();
    final maxScore = 500;
    
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
              Icon(Icons.show_chart, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Performance Trend',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: Row(
              children: data.map((item) {
                final height = (item['score'] as int) / maxScore * 140;
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: height,
                        width: 35,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [_getSubjectColor(), _getSubjectColor().withValues(alpha: 0.5)],
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
                      const SizedBox(height: 8),
                      Text(
                        item['label'],
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

  Widget _buildWeeklyComparison() {
    final thisWeek = 450;
    final lastWeek = 380;
    final improvement = ((thisWeek - lastWeek) / lastWeek * 100).toInt();
    
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('This Week', style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text(
                  '$thisWeek',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Last Week', style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text(
                  '$lastWeek',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: improvement >= 0 ? AppColors.mintGreen.withValues(alpha: 0.1) : AppColors.errorRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Icon(
                  improvement >= 0 ? Icons.trending_up : Icons.trending_down,
                  size: 16,
                  color: improvement >= 0 ? AppColors.mintGreen : AppColors.errorRed,
                ),
                const SizedBox(width: 4),
                Text(
                  '${improvement >= 0 ? '+' : ''}$improvement%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: improvement >= 0 ? AppColors.mintGreen : AppColors.errorRed,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakAnalytics() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.warningOrange.withValues(alpha: 0.1), AppColors.gold.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.warningOrange.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warningOrange.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.local_fire_department, color: AppColors.warningOrange, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Streak',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  '5 days',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.warningOrange,
                  ),
                ),
                const Text(
                  'Best streak: 12 days',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.warningOrange.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_forward, color: AppColors.warningOrange),
          ),
        ],
      ),
    );
  }

  Widget _buildAccuracyTrend() {
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
              Icon(Icons.percent, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Accuracy Trend',
                style: TextStyle(
                  fontSize: 16,
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
              _buildAccuracyStat('Week 1', 72, AppColors.mathOrange),
              _buildAccuracyStat('Week 2', 78, AppColors.mathOrange),
              _buildAccuracyStat('Week 3', 85, AppColors.mintGreen),
              _buildAccuracyStat('Week 4', 88, AppColors.mintGreen),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccuracyStat(String week, int accuracy, Color color) {
    return Column(
      children: [
        Text(
          '$accuracy%',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          week,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementsTab(GameProvider game) {
    final achievements = _getSubjectAchievements(_selectedSubject);
    final earnedCount = achievements.where((a) => a['earned'] as bool).length;
    
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
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
          child: Row(
            children: [
              const Icon(Icons.emoji_events, size: 40, color: AppColors.gold),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subject Achievements',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.gold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$earnedCount of ${achievements.length} earned',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: earnedCount / achievements.length,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation(AppColors.gold),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              return _buildSubjectAchievementCard(achievement);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectAchievementCard(Map<String, dynamic> achievement) {
    final isEarned = achievement['earned'] as bool;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEarned ? _getSubjectColor().withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isEarned ? _getSubjectColor() : Colors.grey.shade200,
          width: isEarned ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isEarned ? _getSubjectColor() : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              achievement['icon'],
              size: 28,
              color: isEarned ? Colors.white : Colors.grey,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isEarned ? _getSubjectColor() : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  achievement['description'],
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                if (!isEarned) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: achievement['progress'],
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(_getSubjectColor()),
                      minHeight: 4,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isEarned)
            const Icon(Icons.check_circle, color: AppColors.mintGreen, size: 28),
        ],
      ),
    );
  }

  // Helper methods
  Color _getSubjectColor() {
    switch (_selectedSubject) {
      case 'Math': return AppColors.mathOrange;
      case 'English': return AppColors.englishGreen;
      default: return AppColors.sciencePurple;
    }
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject) {
      case 'Math': return Icons.calculate;
      case 'English': return Icons.menu_book;
      default: return Icons.science;
    }
  }

  int _getSubjectScore(GameProvider game) {
    switch (_selectedSubject) {
      case 'Math': return game.subjectScores['Math'] ?? 0;
      case 'English': return game.subjectScores['English'] ?? 0;
      default: return game.subjectScores['Science'] ?? 0;
    }
  }

  String _getNextMilestone(int score) {
    if (score < 500) return '500 XP to Novice';
    if (score < 1000) return '1000 XP to Master';
    if (score < 2000) return '2000 XP to Genius';
    return 'Mastery Achieved!';
  }

  int _getTopicsCompleted(String subject) {
    switch (subject) {
      case 'Math': return 4;
      case 'English': return 3;
      default: return 2;
    }
  }

  int _getTotalTopics(String subject) {
    return 6;
  }

  List<Map<String, dynamic>> _getTopicsList(String subject) {
    switch (subject) {
      case 'Math':
        return [
          {'name': 'Arithmetic', 'icon': Icons.add, 'progress': 0.9},
          {'name': 'Multiplication', 'icon': Icons.close, 'progress': 0.7},
          {'name': 'Division', 'icon': Icons.percent, 'progress': 0.5},
          {'name': 'Fractions', 'icon': Icons.pie_chart, 'progress': 0.3},
          {'name': 'Algebra', 'icon': Icons.functions, 'progress': 0.1},
          {'name': 'Geometry', 'icon': Icons.crop_rotate, 'progress': 0.0},
        ];
      case 'English':
        return [
          {'name': 'Vocabulary', 'icon': Icons.menu_book, 'progress': 0.8},
          {'name': 'Grammar', 'icon': Icons.rule, 'progress': 0.6},
          {'name': 'Reading', 'icon': Icons.description, 'progress': 0.4},
          {'name': 'Writing', 'icon': Icons.edit, 'progress': 0.2},
        ];
      default:
        return [
          {'name': 'Biology', 'icon': Icons.biotech, 'progress': 0.6},
          {'name': 'Chemistry', 'icon': Icons.science, 'progress': 0.4},
          {'name': 'Physics', 'icon': Icons.electric_bolt, 'progress': 0.3},
          {'name': 'Earth Science', 'icon': Icons.public, 'progress': 0.1},
        ];
    }
  }

  List<Map<String, dynamic>> _getSkillsBreakdown(String subject) {
    switch (subject) {
      case 'Math':
        return [
          {'name': 'Number Sense', 'score': 85},
          {'name': 'Operations', 'score': 78},
          {'name': 'Problem Solving', 'score': 72},
          {'name': 'Algebra', 'score': 45},
        ];
      case 'English':
        return [
          {'name': 'Vocabulary', 'score': 82},
          {'name': 'Grammar', 'score': 76},
          {'name': 'Reading', 'score': 70},
          {'name': 'Writing', 'score': 58},
        ];
      default:
        return [
          {'name': 'Biology', 'score': 75},
          {'name': 'Chemistry', 'score': 68},
          {'name': 'Physics', 'score': 62},
        ];
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return AppColors.mintGreen;
    if (score >= 60) return AppColors.warningOrange;
    return AppColors.errorRed;
  }

  List<Map<String, dynamic>> _getRecentActivity(String subject) {
    return [
      {'title': 'Completed ${subject} Quiz', 'date': 'Today', 'points': 50, 'icon': Icons.quiz, 'color': _getSubjectColor()},
      {'title': 'Practiced ${_getTopicsList(subject)[0]['name']}', 'date': 'Yesterday', 'points': 30, 'icon': Icons.school, 'color': _getSubjectColor()},
      {'title': 'Earned ${subject} Badge', 'date': '3 days ago', 'points': 100, 'icon': Icons.emoji_events, 'color': AppColors.gold},
    ];
  }

  List<String> _getRecommendations(String subject) {
    switch (subject) {
      case 'Math':
        return [
          'Practice multiplication tables to improve speed',
          'Try fraction challenges to master this topic',
          'Complete daily math puzzles for bonus points',
        ];
      case 'English':
        return [
          'Read one story per day to build vocabulary',
          'Practice grammar exercises regularly',
          'Write a short paragraph daily',
        ];
      default:
        return [
          'Review biology basics to strengthen foundation',
          'Watch science videos for better understanding',
          'Try hands-on experiments at home',
        ];
    }
  }

  List<Map<String, dynamic>> _getChartData() {
    if (_selectedTimeRange == 'This Week') {
      return [
        {'label': 'Mon', 'score': 45},
        {'label': 'Tue', 'score': 62},
        {'label': 'Wed', 'score': 38},
        {'label': 'Thu', 'score': 71},
        {'label': 'Fri', 'score': 55},
        {'label': 'Sat', 'score': 84},
        {'label': 'Sun', 'score': 68},
      ];
    } else if (_selectedTimeRange == 'This Month') {
      return [
        {'label': 'W1', 'score': 280},
        {'label': 'W2', 'score': 350},
        {'label': 'W3', 'score': 420},
        {'label': 'W4', 'score': 380},
      ];
    } else {
      return [
        {'label': 'Jan', 'score': 200},
        {'label': 'Feb', 'score': 280},
        {'label': 'Mar', 'score': 350},
        {'label': 'Apr', 'score': 420},
        {'label': 'May', 'score': 480},
        {'label': 'Jun', 'score': 550},
      ];
    }
  }

  List<Map<String, dynamic>> _getSubjectAchievements(String subject) {
    switch (subject) {
      case 'Math':
        return [
          {'title': 'Math Novice', 'description': 'Score 500 points in Math', 'icon': Icons.calculate, 'earned': true, 'progress': 1.0},
          {'title': 'Math Master', 'description': 'Score 1000 points in Math', 'icon': Icons.star, 'earned': false, 'progress': 0.7},
          {'title': 'Math Genius', 'description': 'Score 2000 points in Math', 'icon': Icons.emoji_events, 'earned': false, 'progress': 0.4},
          {'title': 'Algebra Ace', 'description': 'Complete algebra section', 'icon': Icons.functions, 'earned': false, 'progress': 0.2},
        ];
      case 'English':
        return [
          {'title': 'English Novice', 'description': 'Score 500 points in English', 'icon': Icons.menu_book, 'earned': true, 'progress': 1.0},
          {'title': 'English Master', 'description': 'Score 1000 points in English', 'icon': Icons.star, 'earned': false, 'progress': 0.6},
          {'title': 'English Genius', 'description': 'Score 2000 points in English', 'icon': Icons.emoji_events, 'earned': false, 'progress': 0.3},
          {'title': 'Grammar Guru', 'description': '90% accuracy in grammar', 'icon': Icons.rule, 'earned': false, 'progress': 0.5},
        ];
      default:
        return [
          {'title': 'Science Novice', 'description': 'Score 500 points in Science', 'icon': Icons.science, 'earned': false, 'progress': 0.8},
          {'title': 'Science Master', 'description': 'Score 1000 points in Science', 'icon': Icons.star, 'earned': false, 'progress': 0.4},
          {'title': 'Science Genius', 'description': 'Score 2000 points in Science', 'icon': Icons.emoji_events, 'earned': false, 'progress': 0.2},
          {'title': 'Lab Expert', 'description': 'Complete science experiments', 'icon': Icons.biotech, 'earned': false, 'progress': 0.3},
        ];
    }
  }
}