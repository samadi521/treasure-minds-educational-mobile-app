import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../../providers/auth_provider.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  String _selectedPeriod = 'Weekly';
  
  // Sample leaderboard data
  final List<Map<String, dynamic>> _globalLeaders = [
    {'rank': 1, 'name': 'Emma Watson', 'score': 9850, 'level': 25, 'avatar': 'E', 'color': AppColors.gold, 'badge': '🥇', 'country': 'USA', 'streak': 45},
    {'rank': 2, 'name': 'Liam Smith', 'score': 9200, 'level': 23, 'avatar': 'L', 'color': AppColors.silver, 'badge': '🥈', 'country': 'UK', 'streak': 38},
    {'rank': 3, 'name': 'Sophia Lee', 'score': 8900, 'level': 22, 'avatar': 'S', 'color': AppColors.bronze, 'badge': '🥉', 'country': 'Canada', 'streak': 32},
    {'rank': 4, 'name': 'Noah Chen', 'score': 8500, 'level': 21, 'avatar': 'N', 'color': Colors.blue, 'badge': '', 'country': 'China', 'streak': 28},
    {'rank': 5, 'name': 'Olivia Kim', 'score': 8200, 'level': 20, 'avatar': 'O', 'color': AppColors.englishGreen, 'badge': '', 'country': 'Korea', 'streak': 25},
    {'rank': 6, 'name': 'Mason Brown', 'score': 7800, 'level': 19, 'avatar': 'M', 'color': AppColors.mathOrange, 'badge': '', 'country': 'Australia', 'streak': 22},
    {'rank': 7, 'name': 'Isabella Garcia', 'score': 7500, 'level': 18, 'avatar': 'I', 'color': AppColors.sciencePurple, 'badge': '', 'country': 'Spain', 'streak': 20},
    {'rank': 8, 'name': 'Ethan Wilson', 'score': 7200, 'level': 18, 'avatar': 'E', 'color': AppColors.adventureTeal, 'badge': '', 'country': 'USA', 'streak': 18},
    {'rank': 9, 'name': 'Mia Johnson', 'score': 6800, 'level': 17, 'avatar': 'M', 'color': AppColors.bubblegumPink, 'badge': '', 'country': 'UK', 'streak': 15},
    {'rank': 10, 'name': 'James Davis', 'score': 6500, 'level': 16, 'avatar': 'J', 'color': AppColors.lavenderPurple, 'badge': '', 'country': 'Canada', 'streak': 12},
    {'rank': 11, 'name': 'Amelia Rodriguez', 'score': 6200, 'level': 16, 'avatar': 'A', 'color': AppColors.neonOrange, 'badge': '', 'country': 'Mexico', 'streak': 10},
    {'rank': 12, 'name': 'Benjamin Taylor', 'score': 5900, 'level': 15, 'avatar': 'B', 'color': AppColors.neonCyan, 'badge': '', 'country': 'USA', 'streak': 8},
    {'rank': 13, 'name': 'Charlotte Anderson', 'score': 5600, 'level': 14, 'avatar': 'C', 'color': AppColors.neonPink, 'badge': '', 'country': 'UK', 'streak': 7},
    {'rank': 14, 'name': 'Daniel Thomas', 'score': 5300, 'level': 14, 'avatar': 'D', 'color': AppColors.neonGreen, 'badge': '', 'country': 'Australia', 'streak': 5},
    {'rank': 15, 'name': 'Evelyn Martinez', 'score': 5000, 'level': 13, 'avatar': 'E', 'color': AppColors.neonPurple, 'badge': '', 'country': 'Spain', 'streak': 4},
  ];

  // Subject-specific leaderboards
  final Map<String, List<Map<String, dynamic>>> _subjectLeaders = {
    'Math': [
      {'rank': 1, 'name': 'Emma Watson', 'score': 3200, 'level': 25, 'avatar': 'E', 'color': AppColors.mathOrange},
      {'rank': 2, 'name': 'Liam Smith', 'score': 3050, 'level': 23, 'avatar': 'L', 'color': AppColors.mathOrange},
      {'rank': 3, 'name': 'Noah Chen', 'score': 2900, 'level': 22, 'avatar': 'N', 'color': AppColors.mathOrange},
    ],
    'English': [
      {'rank': 1, 'name': 'Sophia Lee', 'score': 3100, 'level': 22, 'avatar': 'S', 'color': AppColors.englishGreen},
      {'rank': 2, 'name': 'Olivia Kim', 'score': 2950, 'level': 20, 'avatar': 'O', 'color': AppColors.englishGreen},
      {'rank': 3, 'name': 'Isabella Garcia', 'score': 2800, 'level': 18, 'avatar': 'I', 'color': AppColors.englishGreen},
    ],
    'Science': [
      {'rank': 1, 'name': 'Mason Brown', 'score': 3000, 'level': 19, 'avatar': 'M', 'color': AppColors.sciencePurple},
      {'rank': 2, 'name': 'Ethan Wilson', 'score': 2850, 'level': 18, 'avatar': 'E', 'color': AppColors.sciencePurple},
      {'rank': 3, 'name': 'Mia Johnson', 'score': 2700, 'level': 17, 'avatar': 'M', 'color': AppColors.sciencePurple},
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
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
    
    // Calculate user rank
    int userRank = _globalLeaders.indexWhere((l) => (l['score'] as int) < game.totalScore) + 1;
    if (userRank == 0) userRank = _globalLeaders.length + 1;
    
    return Scaffold(
      body: FadeTransition(
        opacity: _animationController,
        child: Column(
          children: [
            _buildHeader(context, game, auth, userRank),
            _buildFilterTabs(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildGlobalLeaderboard(game, auth, userRank),
                  _buildSubjectLeaderboard(),
                  _buildFriendsLeaderboard(game, auth),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, GameProvider game, AuthProvider auth, int userRank) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.neonBlue, AppColors.neonPurple],
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
                "Leaderboard",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black26)],
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
          const SizedBox(height: 15),
          
          // Period selector
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                _buildPeriodButton('Daily'),
                _buildPeriodButton('Weekly'),
                _buildPeriodButton('Monthly'),
                _buildPeriodButton('All Time'),
              ],
            ),
          ),
          
          const SizedBox(height: 15),
          
          // User's rank card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.gold, AppColors.warningOrange],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      auth.userName?[0].toUpperCase() ?? 'U',
                      style: const TextStyle(
                        fontSize: 20,
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
                        "Your Rank",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        auth.userName ?? 'Player',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.gold, AppColors.warningOrange],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      Text(
                        userRank <= 3 ? _getMedalEmoji(userRank) : "#$userRank",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${game.totalScore} pts",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    bool isSelected = _selectedPeriod == period;
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
            color: isSelected ? AppColors.gold : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            period,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
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
        labelColor: AppColors.neonBlue,
        unselectedLabelColor: Colors.grey,
        indicator: BoxDecoration(
          color: AppColors.gold.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(30),
        ),
        tabs: [
          const Tab(text: "🌍 Global"),
          const Tab(text: "📚 By Subject"),
          const Tab(text: "👥 Friends"),
        ],
      ),
    );
  }

  Widget _buildGlobalLeaderboard(GameProvider game, AuthProvider auth, int userRank) {
    List<Map<String, dynamic>> displayedLeaders = List.from(_globalLeaders);
    
    // Filter by period (simulated)
    if (_selectedPeriod == 'Daily') {
      displayedLeaders = displayedLeaders.map((l) {
        return {...l, 'score': (l['score'] as int) ~/ 7};
      }).toList();
    } else if (_selectedPeriod == 'Monthly') {
      displayedLeaders = displayedLeaders.map((l) {
        return {...l, 'score': ((l['score'] as int) * 4) ~/ 7};
      }).toList();
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: displayedLeaders.length,
      itemBuilder: (context, index) {
        final leader = displayedLeaders[index];
        final isCurrentUser = (leader['name'] as String) == auth.userName;
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 12),
          child: _buildLeaderCard(
            rank: leader['rank'] as int,
            name: leader['name'] as String,
            score: leader['score'] as int,
            level: leader['level'] as int,
            avatar: leader['avatar'] as String,
            color: leader['color'] as Color,
            badge: (leader['badge'] as String?) ?? '',
            country: leader['country'] as String,
            streak: leader['streak'] as int,
            isCurrentUser: isCurrentUser,
          ),
        );
      },
    );
  }

  Widget _buildSubjectLeaderboard() {
    String selectedSubject = 'Math';
    
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            // Subject selector
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSubjectChip('Math', AppColors.mathOrange, selectedSubject, setState),
                  _buildSubjectChip('English', AppColors.englishGreen, selectedSubject, setState),
                  _buildSubjectChip('Science', AppColors.sciencePurple, selectedSubject, setState),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _subjectLeaders[selectedSubject]?.length ?? 0,
                itemBuilder: (context, index) {
                  final leader = _subjectLeaders[selectedSubject]![index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: _buildSubjectLeaderCard(
                      rank: leader['rank'] as int,
                      name: leader['name'] as String,
                      score: leader['score'] as int,
                      level: leader['level'] as int,
                      avatar: leader['avatar'] as String,
                      color: leader['color'] as Color,
                      subject: selectedSubject,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubjectChip(String subject, Color color, String selectedSubject, StateSetter setState) {
    final isSelected = selectedSubject == subject;
    return GestureDetector(
      onTap: () => setState(() => selectedSubject = subject),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [color, color.withValues(alpha: 0.7)])
              : null,
          color: isSelected ? null : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Text(
          subject,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFriendsLeaderboard(GameProvider game, AuthProvider auth) {
    // Sample friends data
    final friends = [
      {'name': 'Alex Turner', 'score': 4500, 'level': 12, 'avatar': 'A', 'online': true},
      {'name': 'Jordan Lee', 'score': 3800, 'level': 10, 'avatar': 'J', 'online': false},
      {'name': 'Casey Morgan', 'score': 3200, 'level': 9, 'avatar': 'C', 'online': true},
    ];
    
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
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
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.neonBlue, AppColors.neonPurple],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          friend['avatar'] as String,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                friend['name'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: (friend['online'] as bool) ? AppColors.mintGreen : Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Level ${friend['level']} Explorer",
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${friend['score']} pts",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        _buildInviteFriendsCard(),
      ],
    );
  }

  Widget _buildInviteFriendsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.neonGreen, AppColors.mintGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_add, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Invite Friends',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Compete with friends and climb the leaderboard together!',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Invite friends feature coming soon!"),
                  backgroundColor: AppColors.mathOrange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.neonGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text("Invite"),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderCard({
    required int rank,
    required String name,
    required int score,
    required int level,
    required String avatar,
    required Color color,
    required String badge,
    required String country,
    required int streak,
    bool isCurrentUser = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser ? AppColors.gold.withValues(alpha: 0.15) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isCurrentUser ? Border.all(color: AppColors.gold, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (isCurrentUser)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "YOU",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                gradient: rank <= 3
                    ? LinearGradient(
                        colors: rank == 1 ? [AppColors.gold, AppColors.warningOrange] :
                        rank == 2 ? [AppColors.silver, Colors.grey] :
                        [AppColors.bronze, const Color(0xFFB87333)],
                      )
                    : LinearGradient(
                        colors: [color, color.withValues(alpha: 0.7)],
                      ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: badge.isNotEmpty
                    ? Text(badge, style: const TextStyle(fontSize: 28))
                    : Text(
                        avatar,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            title: Row(
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isCurrentUser ? AppColors.gold : Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  country,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  "Level $level Explorer",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, size: 12, color: AppColors.warningOrange),
                    const SizedBox(width: 2),
                    Text(
                      "$streak day streak",
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    "$score",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: color,
                    ),
                  ),
                  const Text(
                    "points",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectLeaderCard({
    required int rank,
    required String name,
    required int score,
    required int level,
    required String avatar,
    required Color color,
    required String subject,
  }) {
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
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.7)],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                rank == 1 ? "🥇" : (rank == 2 ? "🥈" : (rank == 3 ? "🥉" : "$rank")),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                avatar,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
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
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Level $level • $subject Master",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "$score",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMedalEmoji(int rank) {
    switch (rank) {
      case 1: return "🥇";
      case 2: return "🥈";
      case 3: return "🥉";
      default: return "#$rank";
    }
  }
}