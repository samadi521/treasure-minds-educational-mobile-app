import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../../providers/auth_provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String _selectedPeriod = 'Weekly';
  String _selectedMetric = 'Score';
  
  final List<String> _periods = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
  final List<String> _metrics = ['Score', 'Accuracy', 'Time Spent', 'Games Played'];

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
    final auth = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Learning Analytics'),
        backgroundColor: AppColors.neonCyan,
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
            Tab(text: "📈 Trends", icon: Icon(Icons.trending_up)),
            Tab(text: "🎯 Insights", icon: Icon(Icons.insights)),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(game, auth),
            _buildTrendsTab(),
            _buildInsightsTab(game),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(GameProvider game, AuthProvider auth) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildPeriodSelector(),
          const SizedBox(height: 20),
          _buildMetricSelector(),
          const SizedBox(height: 20),
          _buildMainChart(),
          const SizedBox(height: 20),
          _buildKeyMetricsGrid(game),
          const SizedBox(height: 20),
          _buildSubjectComparison(),
          const SizedBox(height: 20),
          _buildStreakCalendar(),
          const SizedBox(height: 20),
          _buildTopPerformances(),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
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
        children: _periods.map((period) {
          final isSelected = _selectedPeriod == period;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPeriod = period;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.neonCyan : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  period,
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

  Widget _buildMetricSelector() {
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
        children: _metrics.map((metric) {
          final isSelected = _selectedMetric == metric;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedMetric = metric;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.neonCyan : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  metric,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
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

  Widget _buildMainChart() {
    final data = _getChartData();
    final maxValue = _getMaxValue(data);
    
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
              const Text(
                'Performance Chart',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.neonCyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.neonCyan,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _selectedMetric,
                      style: const TextStyle(fontSize: 10, color: AppColors.neonCyan),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: Row(
              children: data.map((item) {
                final value = _getMetricValue(item);
                final height = maxValue > 0 ? value / maxValue * 160 : 0.0;
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: height,
                        width: 35,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.neonCyan, AppColors.neonCyan.withValues(alpha: 0.5)],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            value.toString(),
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
                        item['label'] as String,
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          _buildChartStats(data),
        ],
      ),
    );
  }

  Widget _buildChartStats(List<Map<String, dynamic>> data) {
    final values = data.map((d) => _getMetricValue(d)).toList();
    final average = values.reduce((a, b) => a + b) / values.length;
    final max = values.reduce((a, b) => a > b ? a : b);
    final min = values.reduce((a, b) => a < b ? a : b);
    final trend = values.last - values.first;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatChip('Avg', average.toInt().toString(), Icons.trending_flat, AppColors.neonBlue),
          _buildStatChip('Max', max.toString(), Icons.trending_up, AppColors.mintGreen),
          _buildStatChip('Min', min.toString(), Icons.trending_down, AppColors.errorRed),
          _buildStatChip('Change', '${trend >= 0 ? "+$trend" : trend}', 
              trend >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
              trend >= 0 ? AppColors.mintGreen : AppColors.errorRed),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildKeyMetricsGrid(GameProvider game) {
    final metrics = [
      {'label': 'Total Score', 'value': '${game.totalScore}', 'icon': Icons.star, 'color': AppColors.gold, 'trend': '+12%'},
      {'label': 'Games Played', 'value': '${(game.totalScore / 100).toInt()}', 'icon': Icons.videogame_asset, 'color': AppColors.neonBlue, 'trend': '+8%'},
      {'label': 'Avg Accuracy', 'value': '85%', 'icon': Icons.percent, 'color': AppColors.mintGreen, 'trend': '+5%'},
      {'label': 'Time Spent', 'value': '24h', 'icon': Icons.timer, 'color': AppColors.warningOrange, 'trend': '+15%'},
      {'label': 'Current Streak', 'value': '${game.dailyStreak}', 'icon': Icons.local_fire_department, 'color': AppColors.errorRed, 'trend': '+2d'},
      {'label': 'Badges Earned', 'value': '${(game.totalScore / 500).toInt().clamp(0, 10)}', 'icon': Icons.emoji_events, 'color': AppColors.neonPurple, 'trend': '+3'},
    ];
    
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: metrics.map((metric) {
        final trendText = metric['trend'] as String;
        final trendContainsPlus = trendText.contains('+');
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(metric['icon'] as IconData, color: metric['color'] as Color, size: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: trendContainsPlus 
                          ? AppColors.mintGreen.withValues(alpha: 0.2)
                          : AppColors.errorRed.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      trendText,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: trendContainsPlus 
                            ? AppColors.mintGreen 
                            : AppColors.errorRed,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                metric['value'] as String,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: metric['color'] as Color,
                ),
              ),
              Text(
                metric['label'] as String,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubjectComparison() {
    final subjects = [
      {'name': 'Math', 'score': 1250, 'color': AppColors.mathOrange, 'icon': Icons.calculate},
      {'name': 'English', 'score': 980, 'color': AppColors.englishGreen, 'icon': Icons.menu_book},
      {'name': 'Science', 'score': 750, 'color': AppColors.sciencePurple, 'icon': Icons.science},
    ];
    
    final maxScore = 2000;
    
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
              Icon(Icons.compare_arrows, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Subject Comparison',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(subject['icon'] as IconData, size: 18, color: subject['color'] as Color),
                        const SizedBox(width: 6),
                        Text(
                          subject['name'] as String,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Text(
                      '${subject['score']} pts',
                      style: TextStyle(
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
                    value: (subject['score'] as int) / maxScore,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(subject['color'] as Color),
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

  Widget _buildStreakCalendar() {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final activeDays = [true, true, false, true, true, false, true];
    
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calendar_today, color: AppColors.warningOrange),
              SizedBox(width: 8),
              Text(
                'Activity Heatmap',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.warningOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              return Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: activeDays[index] 
                          ? AppColors.warningOrange 
                          : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        days[index],
                        style: TextStyle(
                          color: activeDays[index] ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Week ${index + 1}',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 16),
          const Text(
            'Current Streak: 5 days',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTopPerformances() {
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
              Icon(Icons.emoji_events, color: AppColors.gold),
              SizedBox(width: 8),
              Text(
                'Top Performances',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPerformanceRow('Highest Score', '850 pts', 'Math Quiz', Icons.star, AppColors.gold),
          const SizedBox(height: 12),
          _buildPerformanceRow('Best Accuracy', '100%', 'English Test', Icons.percent, AppColors.mintGreen),
          const SizedBox(height: 12),
          _buildPerformanceRow('Fastest Time', '45s', 'Timer Challenge', Icons.timer, AppColors.neonBlue),
          const SizedBox(height: 12),
          _buildPerformanceRow('Longest Streak', '12 days', 'Daily Login', Icons.local_fire_department, AppColors.warningOrange),
        ],
      ),
    );
  }

  Widget _buildPerformanceRow(String label, String value, String detail, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
        Text(
          detail,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTrendsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTrendChart(),
          const SizedBox(height: 20),
          _buildMovingAverage(),
          const SizedBox(height: 20),
          _buildSeasonalTrends(),
          const SizedBox(height: 20),
          _buildPredictionCard(),
        ],
      ),
    );
  }

  Widget _buildTrendChart() {
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
              Icon(Icons.timeline, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Performance Trend',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: TrendLinePainter(
                values: [65, 72, 68, 75, 82, 78, 85, 88, 84, 90, 92, 88],
                color: AppColors.neonCyan,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Jan', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('Feb', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('Mar', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('Apr', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('May', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('Jun', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('Jul', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('Aug', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('Sep', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('Oct', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('Nov', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('Dec', style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMovingAverage() {
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
                'Moving Average (7-day)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAverageStat('Current', '85', 'points', AppColors.neonCyan),
              _buildAverageStat('7-day AVG', '78', 'points', AppColors.mintGreen),
              _buildAverageStat('30-day AVG', '72', 'points', AppColors.warningOrange),
              _buildAverageStat('Trend', '+13', 'points', AppColors.mintGreen),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAverageStat(String label, String value, String unit, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
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
          unit,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSeasonalTrends() {
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
              Icon(Icons.local_florist, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Seasonal Performance',
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
              _buildSeasonStat('Spring', '78', Icons.local_florist_outlined, AppColors.mintGreen),
              _buildSeasonStat('Summer', '85', Icons.wb_sunny, AppColors.warningOrange),
              _buildSeasonStat('Fall', '82', Icons.energy_savings_leaf_rounded, AppColors.mathOrange),
              _buildSeasonStat('Winter', '75', Icons.ac_unit, AppColors.neonBlue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonStat(String season, String score, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          season,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          score,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildPredictionCard() {
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
              Icon(Icons.auto_awesome, color: AppColors.gold),
              SizedBox(width: 8),
              Text(
                'AI Prediction',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Based on your current performance trend, you are projected to:',
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 12),
          _buildPredictionItem('Reach 5000 total points', '2 weeks', Icons.star),
          const SizedBox(height: 8),
          _buildPredictionItem('Earn Math Master badge', '3 weeks', Icons.calculate),
          const SizedBox(height: 8),
          _buildPredictionItem('Complete all levels', '1 month', Icons.map),
        ],
      ),
    );
  }

  Widget _buildPredictionItem(String goal, String timeframe, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.gold),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            goal,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            timeframe,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.gold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInsightsTab(GameProvider game) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        _buildInsightCard(
          title: '📈 Your Progress',
          insights: [
            'Your score has increased by 23% this month',
            'You\'re in the top 15% of learners',
            'Math is your strongest subject',
          ],
          color: AppColors.mintGreen,
        ),
        const SizedBox(height: 16),
        _buildInsightCard(
          title: '⚠️ Areas to Improve',
          insights: [
            'Science scores are 20% below average',
            'Try practicing fractions more often',
            'Complete daily challenges for bonus XP',
          ],
          color: AppColors.warningOrange,
        ),
        const SizedBox(height: 16),
        _buildInsightCard(
          title: '🎯 Recommended Actions',
          insights: [
            'Play 3 more games this week to maintain streak',
            'Complete the Science mastery track',
            'Invite a friend to earn bonus points',
          ],
          color: AppColors.neonBlue,
        ),
        const SizedBox(height: 16),
        _buildInsightCard(
          title: '🏆 Achievements Close',
          insights: [
            '2 more days to earn Streak Master badge',
            '250 points needed for Math Master',
            'Complete 5 puzzles for Puzzle Solver',
          ],
          color: AppColors.gold,
        ),
      ],
    );
  }

  Widget _buildInsightCard({required String title, required List<String> insights, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
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
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          ...insights.map((insight) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    insight,
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

  // Helper methods
  List<Map<String, dynamic>> _getChartData() {
    switch (_selectedPeriod) {
      case 'Daily':
        return [
          {'label': 'Mon', 'score': 45, 'accuracy': 82, 'time': 25, 'games': 3},
          {'label': 'Tue', 'score': 62, 'accuracy': 85, 'time': 32, 'games': 4},
          {'label': 'Wed', 'score': 38, 'accuracy': 78, 'time': 20, 'games': 2},
          {'label': 'Thu', 'score': 71, 'accuracy': 88, 'time': 38, 'games': 5},
          {'label': 'Fri', 'score': 55, 'accuracy': 84, 'time': 28, 'games': 3},
          {'label': 'Sat', 'score': 84, 'accuracy': 92, 'time': 45, 'games': 6},
          {'label': 'Sun', 'score': 68, 'accuracy': 86, 'time': 35, 'games': 4},
        ];
      case 'Weekly':
        return [
          {'label': 'W1', 'score': 280, 'accuracy': 82, 'time': 150, 'games': 18},
          {'label': 'W2', 'score': 350, 'accuracy': 85, 'time': 180, 'games': 22},
          {'label': 'W3', 'score': 420, 'accuracy': 88, 'time': 210, 'games': 25},
          {'label': 'W4', 'score': 380, 'accuracy': 86, 'time': 195, 'games': 23},
        ];
      case 'Monthly':
        return [
          {'label': 'Jan', 'score': 850, 'accuracy': 80, 'time': 480, 'games': 55},
          {'label': 'Feb', 'score': 920, 'accuracy': 82, 'time': 520, 'games': 60},
          {'label': 'Mar', 'score': 1050, 'accuracy': 85, 'time': 580, 'games': 68},
          {'label': 'Apr', 'score': 980, 'accuracy': 84, 'time': 550, 'games': 62},
        ];
      default:
        return [
          {'label': '2023', 'score': 3200, 'accuracy': 78, 'time': 1800, 'games': 210},
          {'label': '2024', 'score': 4200, 'accuracy': 85, 'time': 2400, 'games': 280},
        ];
    }
  }

  int _getMetricValue(Map<String, dynamic> item) {
    switch (_selectedMetric) {
      case 'Score': return item['score'] as int;
      case 'Accuracy': return item['accuracy'] as int;
      case 'Time Spent': return item['time'] as int;
      case 'Games Played': return item['games'] as int;
      default: return item['score'] as int;
    }
  }

  int _getMaxValue(List<Map<String, dynamic>> data) {
    final values = data.map((d) => _getMetricValue(d)).toList();
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a > b ? a : b).toInt();
  }
}

// Custom painter for trend line
class TrendLinePainter extends CustomPainter {
  final List<double> values;
  final Color color;

  TrendLinePainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();
    
    final stepX = size.width / (values.length - 1);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;
    
    for (int i = 0; i < values.length; i++) {
      final x = i * stepX;
      final y = range > 0 ? size.height - ((values[i] - minValue) / range * size.height) : size.height / 2;
      
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    
    fillPath.lineTo(size.width, size.height);
    fillPath.close();
    
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
    
    // Draw points
    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < values.length; i++) {
      final x = i * stepX;
      final y = range > 0 ? size.height - ((values[i] - minValue) / range * size.height) : size.height / 2;
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}