import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../../providers/auth_provider.dart';
import '../grade/grade_selection_screen.dart';
import '../games/math_game_screen.dart';
import '../games/english_game_screen.dart';
import '../games/science_game_screen.dart';

class SubjectDetailScreen extends StatefulWidget {
  final String subject;
  
  const SubjectDetailScreen({
    super.key,
    required this.subject,
  });

  @override
  State<SubjectDetailScreen> createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends State<SubjectDetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int _selectedTab = 0; // 0 = Overview, 1 = Topics, 2 = Achievements, 3 = Leaderboard
  
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
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              _buildHeader(game, auth),
              _buildTabBar(),
              Expanded(
                child: IndexedStack(
                  index: _selectedTab,
                  children: [
                    _buildOverviewTab(),
                    _buildTopicsTab(),
                    _buildAchievementsTab(game),
                    _buildLeaderboardTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(GameProvider game, AuthProvider auth) {
    final subjectColor = _getSubjectColor();
    final subjectIcon = _getSubjectIcon();
    final subjectScore = _getSubjectScore(game);
    final subjectProgress = subjectScore / 2000;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [subjectColor, subjectColor.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
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
                  "Subject Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(subjectIcon, color: Colors.white, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      _getSubjectEmoji(),
                      style: const TextStyle(fontSize: 45),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.subject,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getSubjectDescription(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: AppColors.gold),
                          const SizedBox(width: 4),
                          Text(
                            '${subjectScore} / 2000 XP',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: subjectProgress,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation(AppColors.gold),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildHeaderStat(
                  'Levels',
                  '${_getCompletedLevels(game)}/${_getTotalLevels()}',
                  Icons.map,
                ),
                _buildHeaderStat(
                  'Badges',
                  '${_getEarnedBadges(game)}/${_getTotalBadges()}',
                  Icons.emoji_events,
                ),
                _buildHeaderStat(
                  'Streak',
                  '${game.dailyStreak}',
                  Icons.local_fire_department,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    final tabs = ['Overview', 'Topics', 'Achievements', 'Leaderboard'];
    
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
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          final isSelected = _selectedTab == index;
          
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? _getSubjectColor() : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
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

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildInfoCard(),
          const SizedBox(height: 16),
          _buildSkillsCard(),
          const SizedBox(height: 16),
          _buildQuickPlayCard(),
          const SizedBox(height: 16),
          _buildRecommendedResourcesCard(),
          const SizedBox(height: 16),
          _buildStartLearningButton(),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
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
              Icon(Icons.info, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'About This Subject',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _getLongDescription(),
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildInfoChip('Age Range', _getAgeRange(), Icons.cake),
              _buildInfoChip('Difficulty', _getDifficulty(), Icons.speed),
              _buildInfoChip('Total XP', '2000', Icons.star),
              _buildInfoChip('Questions', _getTotalQuestions(), Icons.quiz),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getSubjectColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: _getSubjectColor()),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: _getSubjectColor(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsCard() {
    final skills = _getSkills();
    
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
              Icon(Icons.psychology, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Skills You\'ll Learn',
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
            children: skills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_getSubjectColor().withValues(alpha: 0.1), Colors.transparent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: _getSubjectColor().withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 16, color: _getSubjectColor()),
                    const SizedBox(width: 8),
                    Text(
                      skill,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _getSubjectColor(),
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

  Widget _buildQuickPlayCard() {
    return GestureDetector(
      onTap: () {
        Widget gameScreen;
        switch (widget.subject) {
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
            gameScreen = const MathGameScreen();
        }
        Navigator.push(context, MaterialPageRoute(builder: (_) => gameScreen));
      },
      child: Container(
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.flash_on, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Quick Play',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Jump straight into a 10-question game',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow, color: AppColors.mathOrange),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedResourcesCard() {
    final resources = _getRecommendedResources();
    
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
              Icon(Icons.book, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Recommended Resources',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...resources.map((resource) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: _getSubjectColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(resource['icon'] as IconData, color: _getSubjectColor()),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resource['title'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        resource['description'] as String,
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _getSubjectColor().withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_forward, size: 16, color: _getSubjectColor()),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildStartLearningButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GradeSelectionScreen(
                selectedSubject: widget.subject,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _getSubjectColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Start Learning',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTopicsTab() {
    final topics = _getTopicsList();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: topics.length,
      itemBuilder: (context, index) {
        final topic = topics[index];
        final isCompleted = index < 3; // Demo: first 3 topics completed
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isCompleted ? AppColors.mintGreen : Colors.grey.shade200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getSubjectColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    topic['emoji'] as String,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic['name'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      topic['description'] as String,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: topic['progress'] as double,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(_getSubjectColor()),
                      minHeight: 4,
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                const Icon(Icons.check_circle, color: AppColors.mintGreen, size: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAchievementsTab(GameProvider game) {
    final achievements = _getAchievements();
    final userScore = _getSubjectScore(game);
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        final isEarned = userScore >= (achievement['requirement'] as int);
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: isEarned
                ? LinearGradient(
                    colors: [AppColors.gold.withValues(alpha: 0.1), Colors.transparent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isEarned ? AppColors.gold : Colors.grey.shade200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: isEarned ? AppColors.gold.withValues(alpha: 0.2) : Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    achievement['icon'] as IconData,
                    size: 28,
                    color: isEarned ? AppColors.gold : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      achievement['name'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isEarned ? Colors.black87 : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      achievement['description'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        color: isEarned ? Colors.grey.shade600 : Colors.grey.shade400,
                      ),
                    ),
                    if (!isEarned)
                      const SizedBox(height: 6),
                    if (!isEarned)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: userScore / (achievement['requirement'] as int),
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation(_getSubjectColor()),
                          minHeight: 4,
                        ),
                      ),
                  ],
                ),
              ),
              if (isEarned)
                const Icon(Icons.emoji_events, color: AppColors.gold, size: 28),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLeaderboardTab() {
    final leaders = _getLeaderboardData();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: leaders.length,
      itemBuilder: (context, index) {
        final leader = leaders[index];
        final isTop3 = index < 3;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: isTop3
                ? Border.all(color: AppColors.gold, width: 1)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: isTop3
                      ? LinearGradient(
                          colors: index == 0
                              ? [AppColors.gold, AppColors.warningOrange]
                              : index == 1
                                  ? [AppColors.silver, Colors.grey]
                                  : [AppColors.bronze, Color(0xFFB87333)],
                        )
                      : null,
                  color: !isTop3 ? Colors.grey.shade200 : null,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    isTop3 ? _getMedalEmoji(index + 1) : '${index + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: _getSubjectColor().withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    leader['initial'] as String,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _getSubjectColor(),
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
                      leader['name'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Level ${leader['level']}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _getSubjectColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '${leader['score']} pts',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: _getSubjectColor(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getMedalEmoji(int rank) {
    switch (rank) {
      case 1: return '🥇';
      case 2: return '🥈';
      case 3: return '🥉';
      default: return '';
    }
  }

  Color _getSubjectColor() {
    switch (widget.subject) {
      case 'Math': return AppColors.mathOrange;
      case 'English': return AppColors.englishGreen;
      case 'Science': return AppColors.sciencePurple;
      default: return AppColors.neonBlue;
    }
  }

  IconData _getSubjectIcon() {
    switch (widget.subject) {
      case 'Math': return Icons.calculate;
      case 'English': return Icons.menu_book;
      case 'Science': return Icons.science;
      default: return Icons.school;
    }
  }

  String _getSubjectEmoji() {
    switch (widget.subject) {
      case 'Math': return '🧮';
      case 'English': return '📚';
      case 'Science': return '🔬';
      default: return '📖';
    }
  }

  String _getSubjectDescription() {
    switch (widget.subject) {
      case 'Math': return 'Master numbers, operations, and problem-solving';
      case 'English': return 'Build vocabulary and grammar skills';
      case 'Science': return 'Explore biology, chemistry, and physics';
      default: return 'Learn and grow';
    }
  }

  String _getLongDescription() {
    switch (widget.subject) {
      case 'Math':
        return 'Mathematics is the language of science and the foundation of logical thinking. In this subject, you\'ll learn everything from basic arithmetic to advanced algebra, helping you solve real-world problems and develop critical thinking skills.';
      case 'English':
        return 'English is the key to communication and expression. You\'ll master vocabulary, grammar, reading comprehension, and writing skills. These abilities will help you succeed in school and express yourself creatively.';
      case 'Science':
        return 'Science helps us understand the world around us. From the smallest cells to the vastness of space, you\'ll explore biology, chemistry, physics, and earth science through engaging questions and experiments.';
      default:
        return 'Learn and master this subject through engaging games and challenges.';
    }
  }

  String _getAgeRange() {
    switch (widget.subject) {
      case 'Math': return '6-16 years';
      case 'English': return '6-16 years';
      case 'Science': return '8-16 years';
      default: return '6-16 years';
    }
  }

  String _getDifficulty() {
    switch (widget.subject) {
      case 'Math': return 'Beginner to Advanced';
      case 'English': return 'Beginner to Advanced';
      case 'Science': return 'Intermediate to Advanced';
      default: return 'All Levels';
    }
  }

  String _getTotalQuestions() {
    switch (widget.subject) {
      case 'Math': return '200+';
      case 'English': return '250+';
      case 'Science': return '200+';
      default: return '200+';
    }
  }

  List<String> _getSkills() {
    switch (widget.subject) {
      case 'Math':
        return ['Arithmetic', 'Algebra', 'Geometry', 'Problem Solving', 'Logical Thinking', 'Data Analysis'];
      case 'English':
        return ['Vocabulary', 'Grammar', 'Reading', 'Writing', 'Spelling', 'Comprehension'];
      case 'Science':
        return ['Biology', 'Chemistry', 'Physics', 'Earth Science', 'Scientific Method', 'Observation'];
      default:
        return ['Critical Thinking', 'Problem Solving', 'Knowledge Retention'];
    }
  }

  List<Map<String, dynamic>> _getRecommendedResources() {
    switch (widget.subject) {
      case 'Math':
        return [
          {'icon': Icons.video_library, 'title': 'Video: Multiplication Tricks', 'description': 'Learn quick multiplication methods'},
          {'icon': Icons.article, 'title': 'Article: Algebra Basics', 'description': 'Understanding variables and equations'},
          {'icon': Icons.quiz, 'title': 'Practice: Daily Math Challenge', 'description': '10 new problems every day'},
        ];
      case 'English':
        return [
          {'icon': Icons.video_library, 'title': 'Video: Grammar Rules', 'description': 'Master parts of speech'},
          {'icon': Icons.article, 'title': 'Article: Building Vocabulary', 'description': 'Tips to learn new words'},
          {'icon': Icons.quiz, 'title': 'Practice: Reading Comprehension', 'description': 'Improve reading skills'},
        ];
      case 'Science':
        return [
          {'icon': Icons.video_library, 'title': 'Video: Photosynthesis Explained', 'description': 'How plants make food'},
          {'icon': Icons.article, 'title': 'Article: Solar System Tour', 'description': 'Explore our cosmic neighborhood'},
          {'icon': Icons.quiz, 'title': 'Practice: Science Quiz', 'description': 'Test your knowledge'},
        ];
      default:
        return [];
    }
  }

  List<Map<String, dynamic>> _getTopicsList() {
    switch (widget.subject) {
      case 'Math':
        return [
          {'name': 'Basic Arithmetic', 'description': 'Addition, subtraction, multiplication, division', 'emoji': '➕', 'progress': 0.9},
          {'name': 'Fractions & Decimals', 'description': 'Understanding parts and decimal values', 'emoji': '🔢', 'progress': 0.7},
          {'name': 'Algebra', 'description': 'Variables, equations, and expressions', 'emoji': '🔤', 'progress': 0.4},
          {'name': 'Geometry', 'description': 'Shapes, angles, and measurements', 'emoji': '📐', 'progress': 0.3},
          {'name': 'Statistics', 'description': 'Data analysis and probability', 'emoji': '📊', 'progress': 0.1},
        ];
      case 'English':
        return [
          {'name': 'Vocabulary', 'description': 'Building word knowledge', 'emoji': '📖', 'progress': 0.8},
          {'name': 'Grammar', 'description': 'Parts of speech and sentence structure', 'emoji': '✍️', 'progress': 0.6},
          {'name': 'Reading', 'description': 'Comprehension and analysis', 'emoji': '📚', 'progress': 0.5},
          {'name': 'Writing', 'description': 'Essays and creative writing', 'emoji': '🖊️', 'progress': 0.3},
          {'name': 'Spelling', 'description': 'Word formation and patterns', 'emoji': '🔤', 'progress': 0.7},
        ];
      case 'Science':
        return [
          {'name': 'Biology', 'description': 'Living organisms and life processes', 'emoji': '🧬', 'progress': 0.7},
          {'name': 'Chemistry', 'description': 'Elements, compounds, and reactions', 'emoji': '🧪', 'progress': 0.5},
          {'name': 'Physics', 'description': 'Forces, energy, and motion', 'emoji': '⚡', 'progress': 0.4},
          {'name': 'Earth Science', 'description': 'Planets, rocks, and atmosphere', 'emoji': '🌍', 'progress': 0.6},
          {'name': 'Space Science', 'description': 'Stars, galaxies, and universe', 'emoji': '🚀', 'progress': 0.3},
        ];
      default:
        return [];
    }
  }

  List<Map<String, dynamic>> _getAchievements() {
    switch (widget.subject) {
      case 'Math':
        return [
          {'name': 'Math Novice', 'description': 'Score 100 points in Math', 'icon': Icons.calculate, 'requirement': 100},
          {'name': 'Math Master', 'description': 'Score 500 points in Math', 'icon': Icons.star, 'requirement': 500},
          {'name': 'Math Genius', 'description': 'Score 1000 points in Math', 'icon': Icons.emoji_events, 'requirement': 1000},
          {'name': 'Algebra Ace', 'description': 'Solve 20 algebra problems', 'icon': Icons.functions, 'requirement': 800},
        ];
      case 'English':
        return [
          {'name': 'English Novice', 'description': 'Score 100 points in English', 'icon': Icons.menu_book, 'requirement': 100},
          {'name': 'English Master', 'description': 'Score 500 points in English', 'icon': Icons.star, 'requirement': 500},
          {'name': 'English Genius', 'description': 'Score 1000 points in English', 'icon': Icons.emoji_events, 'requirement': 1000},
          {'name': 'Grammar Guru', 'description': 'Get 90% accuracy in grammar', 'icon': Icons.rule, 'requirement': 800},
        ];
      case 'Science':
        return [
          {'name': 'Science Novice', 'description': 'Score 100 points in Science', 'icon': Icons.science, 'requirement': 100},
          {'name': 'Science Master', 'description': 'Score 500 points in Science', 'icon': Icons.star, 'requirement': 500},
          {'name': 'Science Genius', 'description': 'Score 1000 points in Science', 'icon': Icons.emoji_events, 'requirement': 1000},
          {'name': 'Lab Expert', 'description': 'Complete 50 science questions', 'icon': Icons.biotech, 'requirement': 750},
        ];
      default:
        return [];
    }
  }

  List<Map<String, dynamic>> _getLeaderboardData() {
    return [
      {'name': 'Emma Watson', 'score': 1850, 'level': 15, 'initial': 'E'},
      {'name': 'Liam Smith', 'score': 1720, 'level': 14, 'initial': 'L'},
      {'name': 'Sophia Lee', 'score': 1680, 'level': 13, 'initial': 'S'},
      {'name': 'Noah Chen', 'score': 1550, 'level': 12, 'initial': 'N'},
      {'name': 'Olivia Kim', 'score': 1480, 'level': 12, 'initial': 'O'},
    ];
  }

  int _getSubjectScore(GameProvider game) {
    switch (widget.subject) {
      case 'Math': return game.subjectScores['Math'] ?? 0;
      case 'English': return game.subjectScores['English'] ?? 0;
      case 'Science': return game.subjectScores['Science'] ?? 0;
      default: return 0;
    }
  }

  int _getCompletedLevels(GameProvider game) {
    // Demo calculation - in real app, track per subject levels
    return game.completedLevels.length;
  }

  int _getTotalLevels() {
    return 8;
  }

  int _getEarnedBadges(GameProvider game) {
    final score = _getSubjectScore(game);
    int count = 0;
    if (score >= 100) count++;
    if (score >= 500) count++;
    if (score >= 1000) count++;
    return count;
  }

  int _getTotalBadges() {
    return 4;
  }
}