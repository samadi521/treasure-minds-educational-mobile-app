import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../../providers/auth_provider.dart';

class FriendsLeaderboardScreen extends StatefulWidget {
  const FriendsLeaderboardScreen({super.key});

  @override
  State<FriendsLeaderboardScreen> createState() => _FriendsLeaderboardScreenState();
}

class _FriendsLeaderboardScreenState extends State<FriendsLeaderboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _selectedFilter = 'All'; // All, Online, Requests
  
  // Sample friends data
  final List<Map<String, dynamic>> _friends = [
    {'id': 1, 'name': 'Alex Turner', 'score': 4500, 'level': 12, 'avatar': 'A', 'online': true, 'lastActive': 'Just now', 'badges': 5, 'streak': 7, 'rank': 42},
    {'id': 2, 'name': 'Jordan Lee', 'score': 3800, 'level': 10, 'avatar': 'J', 'online': false, 'lastActive': '2 hours ago', 'badges': 4, 'streak': 5, 'rank': 58},
    {'id': 3, 'name': 'Casey Morgan', 'score': 3200, 'level': 9, 'avatar': 'C', 'online': true, 'lastActive': 'Just now', 'badges': 3, 'streak': 4, 'rank': 67},
    {'id': 4, 'name': 'Riley Parker', 'score': 2800, 'level': 8, 'avatar': 'R', 'online': false, 'lastActive': 'Yesterday', 'badges': 3, 'streak': 2, 'rank': 75},
    {'id': 5, 'name': 'Taylor Brooks', 'score': 2100, 'level': 6, 'avatar': 'T', 'online': true, 'lastActive': '5 min ago', 'badges': 2, 'streak': 3, 'rank': 89},
    {'id': 6, 'name': 'Morgan Reed', 'score': 1800, 'level': 5, 'avatar': 'M', 'online': false, 'lastActive': '3 days ago', 'badges': 2, 'streak': 0, 'rank': 95},
    {'id': 7, 'name': 'Jamie Fox', 'score': 1500, 'level': 4, 'avatar': 'J', 'online': true, 'lastActive': '1 hour ago', 'badges': 1, 'streak': 1, 'rank': 102},
  ];
  
  // Friend requests received
  final List<Map<String, dynamic>> _receivedRequests = [
    {'name': 'Sam Wilson', 'score': 3200, 'level': 9, 'avatar': 'S', 'mutualFriends': 3},
    {'name': 'Chris Evans', 'score': 2800, 'level': 8, 'avatar': 'C', 'mutualFriends': 2},
    {'name': 'Pat Smith', 'score': 1900, 'level': 5, 'avatar': 'P', 'mutualFriends': 1},
  ];
  
  // Friend requests sent
  final List<Map<String, dynamic>> _sentRequests = [
    {'name': 'Dana White', 'score': 4100, 'level': 11, 'avatar': 'D', 'status': 'Pending'},
    {'name': 'Kim Possible', 'score': 3500, 'level': 9, 'avatar': 'K', 'status': 'Pending'},
  ];
  
  // Suggested friends
  final List<Map<String, dynamic>> _suggestedFriends = [
    {'name': 'Mike Johnson', 'score': 5200, 'level': 14, 'avatar': 'M', 'mutualFriends': 5, 'commonInterests': ['Math', 'Science']},
    {'name': 'Sarah Connor', 'score': 4800, 'level': 13, 'avatar': 'S', 'mutualFriends': 4, 'commonInterests': ['English', 'Puzzles']},
    {'name': 'David Kim', 'score': 3900, 'level': 10, 'avatar': 'D', 'mutualFriends': 3, 'commonInterests': ['Science', 'Logic']},
    {'name': 'Lisa Wong', 'score': 3600, 'level': 9, 'avatar': 'L', 'mutualFriends': 3, 'commonInterests': ['Math', 'Puzzles']},
    {'name': 'Tom Brady', 'score': 3100, 'level': 8, 'avatar': 'T', 'mutualFriends': 2, 'commonInterests': ['English']},
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
    final auth = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text("Friends Leaderboard"),
        backgroundColor: AppColors.neonGreen,
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
            Tab(text: "👥 Friends", icon: Icon(Icons.people)),
            Tab(text: "📨 Requests", icon: Icon(Icons.mail)),
            Tab(text: "✨ Suggest", icon: Icon(Icons.recommend)),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildFriendsList(game, auth),
            _buildRequestsList(),
            _buildSuggestionsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendsList(GameProvider game, AuthProvider auth) {
    // Filter friends
    List<Map<String, dynamic>> filteredFriends = List.from(_friends);
    if (_selectedFilter == 'Online') {
      filteredFriends = filteredFriends.where((f) => f['online'] == true).toList();
    }
    
    return Column(
      children: [
        _buildFilterChips(),
        Expanded(
          child: filteredFriends.isEmpty
              ? _buildEmptyState('No friends found', 'Try adding some friends!')
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredFriends.length,
                  itemBuilder: (context, index) {
                    final friend = filteredFriends[index];
                    return _buildFriendCard(friend, game);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Online'];
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.neonGreen : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFriendCard(Map<String, dynamic> friend, GameProvider game) {
    final isHigherScore = friend['score'] > game.totalScore;
    
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
          // Avatar
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.neonGreen, AppColors.mintGreen],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    friend['avatar'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: friend['online'] ? AppColors.mintGreen : Colors.grey,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Friend Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      friend['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "#${friend['rank']}",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Level ${friend['level']} Explorer",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 12, color: AppColors.gold),
                    const SizedBox(width: 2),
                    Text(
                      "${friend['badges']} badges",
                      style: const TextStyle(fontSize: 11),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.local_fire_department, size: 12, color: AppColors.warningOrange),
                    const SizedBox(width: 2),
                    Text(
                      "${friend['streak']} day streak",
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isHigherScore ? AppColors.errorRed.withValues(alpha: 0.1) : AppColors.mintGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "${friend['score']} pts",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isHigherScore ? AppColors.errorRed : AppColors.mintGreen,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                friend['online'] ? '● Online' : '● ${friend['lastActive']}',
                style: TextStyle(
                  fontSize: 10,
                  color: friend['online'] ? AppColors.mintGreen : Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          // Challenge button
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.mathOrange.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.sports_esports,
              color: AppColors.mathOrange,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestsList() {
    return _receivedRequests.isEmpty && _sentRequests.isEmpty
        ? _buildEmptyState('No friend requests', 'Invite friends to play together!')
        : ListView(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            children: [
              if (_receivedRequests.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Received Requests',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonPurple,
                    ),
                  ),
                ),
                ..._receivedRequests.map((request) => _buildRequestCard(request, true)),
              ],
              if (_sentRequests.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Sent Requests',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonPurple,
                    ),
                  ),
                ),
                ..._sentRequests.map((request) => _buildRequestCard(request, false)),
              ],
            ],
          );
  }

  Widget _buildRequestCard(Map<String, dynamic> request, bool isReceived) {
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
                request['avatar'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (request.containsKey('mutualFriends'))
                  Text(
                    "${request['mutualFriends']} mutual friends",
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                if (request.containsKey('score'))
                  Text(
                    "Score: ${request['score']} • Level ${request['level']}",
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                if (request.containsKey('status'))
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.warningOrange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      request['status'],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.warningOrange,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (isReceived)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.mintGreen.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppColors.mintGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.errorRed.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.errorRed,
                    size: 20,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            itemCount: _suggestedFriends.length,
            itemBuilder: (context, index) {
              final friend = _suggestedFriends[index];
              return _buildSuggestionCard(friend);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionCard(Map<String, dynamic> friend) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gold.withValues(alpha: 0.05), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.gold, AppColors.warningOrange],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                friend['avatar'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Score: ${friend['score']} • Level ${friend['level']}",
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.people, size: 12, color: Colors.grey),
                    const SizedBox(width: 2),
                    Text(
                      "${friend['mutualFriends']} mutual friends",
                      style: const TextStyle(fontSize: 10),
                    ),
                    const SizedBox(width: 12),
                    ...(friend['commonInterests'] as List).map((interest) {
                      return Container(
                        margin: const EdgeInsets.only(right: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.neonBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          interest,
                          style: TextStyle(
                            fontSize: 9,
                            color: AppColors.neonBlue,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Friend request sent!"),
                  backgroundColor: AppColors.mintGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.people_outline, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.share),
            label: const Text("Invite Friends"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}