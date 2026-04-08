import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../../providers/auth_provider.dart';

class MultiplayerScreen extends StatefulWidget {
  const MultiplayerScreen({super.key});

  @override
  State<MultiplayerScreen> createState() => _MultiplayerScreenState();
}

class _MultiplayerScreenState extends State<MultiplayerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String _selectedGameMode = '1v1';
  bool _isSearching = false;
  int _searchTimer = 0;
  
  // Sample online players
  final List<Map<String, dynamic>> _onlinePlayers = [
    {'name': 'Emma Watson', 'level': 25, 'score': 9850, 'avatar': 'E', 'status': 'online', 'country': 'USA'},
    {'name': 'Liam Smith', 'level': 23, 'score': 9200, 'avatar': 'L', 'status': 'online', 'country': 'UK'},
    {'name': 'Sophia Lee', 'level': 22, 'score': 8900, 'avatar': 'S', 'status': 'online', 'country': 'Canada'},
    {'name': 'Noah Chen', 'level': 21, 'score': 8500, 'avatar': 'N', 'status': 'online', 'country': 'China'},
    {'name': 'Olivia Kim', 'level': 20, 'score': 8200, 'avatar': 'O', 'status': 'online', 'country': 'Korea'},
    {'name': 'Mason Brown', 'level': 19, 'score': 7800, 'avatar': 'M', 'status': 'away', 'country': 'Australia'},
  ];
  
  // Sample match history
  final List<Map<String, dynamic>> _matchHistory = [
    {'opponent': 'Alex Turner', 'result': 'win', 'score': 850, 'opponentScore': 720, 'date': 'Today', 'xpGained': 50},
    {'opponent': 'Jordan Lee', 'result': 'loss', 'score': 680, 'opponentScore': 790, 'date': 'Yesterday', 'xpGained': 20},
    {'opponent': 'Casey Morgan', 'result': 'win', 'score': 920, 'opponentScore': 810, 'date': '2 days ago', 'xpGained': 50},
    {'opponent': 'Riley Parker', 'result': 'win', 'score': 780, 'opponentScore': 650, 'date': '3 days ago', 'xpGained': 50},
    {'opponent': 'Taylor Brooks', 'result': 'loss', 'score': 590, 'opponentScore': 880, 'date': '5 days ago', 'xpGained': 20},
  ];
  
  // Leaderboard data
  final List<Map<String, dynamic>> _multiplayerLeaderboard = [
    {'rank': 1, 'name': 'Emma Watson', 'wins': 245, 'losses': 32, 'winRate': 88, 'points': 9850, 'avatar': 'E'},
    {'rank': 2, 'name': 'Liam Smith', 'wins': 228, 'losses': 41, 'winRate': 85, 'points': 9200, 'avatar': 'L'},
    {'rank': 3, 'name': 'Sophia Lee', 'wins': 215, 'losses': 38, 'winRate': 85, 'points': 8900, 'avatar': 'S'},
    {'rank': 4, 'name': 'Noah Chen', 'wins': 198, 'losses': 52, 'winRate': 79, 'points': 8500, 'avatar': 'N'},
    {'rank': 5, 'name': 'Olivia Kim', 'wins': 185, 'losses': 48, 'winRate': 79, 'points': 8200, 'avatar': 'O'},
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
        title: const Text('Multiplayer Arena'),
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
            Tab(text: "🎮 Play", icon: Icon(Icons.sports_esports)),
            Tab(text: "📊 Leaderboard", icon: Icon(Icons.emoji_events)),
            Tab(text: "📜 History", icon: Icon(Icons.history)),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildPlayTab(game, auth),
            _buildLeaderboardTab(),
            _buildHistoryTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayTab(GameProvider game, AuthProvider auth) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildPlayerStatsCard(game, auth),
          const SizedBox(height: 20),
          _buildGameModeSelector(),
          const SizedBox(height: 20),
          if (!_isSearching) ...[
            _buildFindMatchButton(),
            const SizedBox(height: 20),
            _buildOnlinePlayersList(),
          ] else ...[
            _buildSearchingAnimation(),
          ],
          const SizedBox(height: 20),
          _buildTournamentCard(),
          const SizedBox(height: 20),
          _buildInviteFriendsCard(),
        ],
      ),
    );
  }

  Widget _buildPlayerStatsCard(GameProvider game, AuthProvider auth) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.neonOrange, AppColors.warningOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonOrange.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    auth.userName?[0].toUpperCase() ?? 'U',
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
                      auth.userName ?? 'Player',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Level ${game.currentLevel} • ${game.totalScore} pts',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
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
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events, size: 16, color: AppColors.gold),
                    const SizedBox(width: 4),
                    Text(
                      '${_getWinRate()}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.neonOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Wins', '${_getWins()}', Icons.emoji_events),
              _buildStatItem('Losses', '${_getLosses()}', Icons.sentiment_dissatisfied),
              _buildStatItem('Win Rate', '${_getWinRate()}%', Icons.trending_up),
              _buildStatItem('Rank', '#${_getRank()}', Icons.leaderboard),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.white),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
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

  Widget _buildGameModeSelector() {
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
              Icon(Icons.gamepad, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Game Mode',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildModeChip('1v1 Duel', '1v1', Icons.sports_mma),
              const SizedBox(width: 12),
              _buildModeChip('Tournament', 'tournament', Icons.emoji_events),
              const SizedBox(width: 12),
              _buildModeChip('Team Battle', 'team', Icons.group),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeChip(String label, String value, IconData icon) {
    final isSelected = _selectedGameMode == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedGameMode = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.neonOrange : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Icon(icon, size: 24, color: isSelected ? Colors.white : Colors.grey),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFindMatchButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _isSearching = true;
            _searchTimer = 0;
            _startSearchTimer();
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 24),
            SizedBox(width: 8),
            Text(
              'FIND MATCH',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _startSearchTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isSearching && mounted) {
        setState(() {
          _searchTimer++;
        });
        if (_searchTimer < 10) {
          _startSearchTimer();
        } else {
          _cancelSearch();
          _showMatchFound();
        }
      }
    });
  }

  void _cancelSearch() {
    setState(() {
      _isSearching = false;
      _searchTimer = 0;
    });
  }

  void _showMatchFound() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: const Text('Match Found!', style: TextStyle(color: AppColors.mintGreen)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.celebration, size: 60, color: AppColors.gold),
            const SizedBox(height: 10),
            const Text('Opponent: Emma Watson'),
            const Text('Level: 25 • Score: 9850'),
            const SizedBox(height: 10),
            const Text('Get ready for the battle!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _cancelSearch();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _cancelSearch();
              _startMatch();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonGreen,
            ),
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }

  void _startMatch() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: const Text('Match Starting!'),
        content: const MultiplayerGameScreen(),
        actions: [],
      ),
    );
  }

  Widget _buildSearchingAnimation() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
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
          const CircularProgressIndicator(
            color: AppColors.neonOrange,
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          Text(
            'Searching for opponent...',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_searchTimer}s elapsed',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(3, (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.neonOrange,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonOrange.withValues(alpha: 0.5),
                      blurRadius: 4,
                    ),
                  ],
                ),
              )),
            ],
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: _cancelSearch,
            child: const Text('Cancel Search'),
          ),
        ],
      ),
    );
  }

  Widget _buildOnlinePlayersList() {
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
              Icon(Icons.person, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Online Players',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 300,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _onlinePlayers.length,
              itemBuilder: (context, index) {
                final player = _onlinePlayers[index];
                return _buildPlayerTile(player);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerTile(Map<String, dynamic> player) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: player['status'] == 'online' 
            ? AppColors.mintGreen.withValues(alpha: 0.1)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: player['status'] == 'online' 
              ? AppColors.mintGreen.withValues(alpha: 0.3)
              : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.neonOrange, AppColors.warningOrange],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                player['avatar'],
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
                Text(
                  player['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Level ${player['level']} • ${player['country']}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: player['status'] == 'online' 
                  ? AppColors.mintGreen
                  : Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              player['status'] == 'online' ? 'Online' : 'Away',
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: player['status'] == 'online' ? () {} : null,
            icon: Icon(
              Icons.sports_esports,
              color: player['status'] == 'online' ? AppColors.neonOrange : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTournamentCard() {
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_events, color: AppColors.gold, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Weekly Tournament',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Compete for the champion title!',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Join', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildInviteFriendsCard() {
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.neonBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.people_alt, color: AppColors.neonBlue, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Invite Friends',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Play with friends and climb together!',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Invite', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: _multiplayerLeaderboard.length,
      itemBuilder: (context, index) {
        final player = _multiplayerLeaderboard[index];
        return _buildLeaderboardCard(player);
      },
    );
  }

  Widget _buildLeaderboardCard(Map<String, dynamic> player) {
    final isTop3 = player['rank'] <= 3;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isTop3
            ? LinearGradient(
                colors: [
                  player['rank'] == 1 ? AppColors.gold : 
                  player['rank'] == 2 ? AppColors.silver : 
                  AppColors.bronze,
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isTop3 ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isTop3
            ? null
            : Border.all(color: Colors.grey.shade200),
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
              color: isTop3 ? Colors.white.withValues(alpha: 0.2) : AppColors.neonOrange.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                player['rank'] == 1 ? '🥇' : (player['rank'] == 2 ? '🥈' : (player['rank'] == 3 ? '🥉' : '${player['rank']}')),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.neonOrange, AppColors.warningOrange],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                player['avatar'],
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
                Text(
                  player['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isTop3 && player['rank'] == 1 ? AppColors.gold : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${player['wins']}W - ${player['losses']}L • ${player['winRate']}% WR',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.neonOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${player['points']}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.neonOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: _matchHistory.length,
      itemBuilder: (context, index) {
        final match = _matchHistory[index];
        return _buildHistoryCard(match);
      },
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> match) {
    final isWin = match['result'] == 'win';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isWin ? AppColors.mintGreen.withValues(alpha: 0.3) : AppColors.errorRed.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isWin ? AppColors.mintGreen.withValues(alpha: 0.1) : AppColors.errorRed.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isWin ? Icons.emoji_events : Icons.sentiment_dissatisfied,
              color: isWin ? AppColors.mintGreen : AppColors.errorRed,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'vs ${match['opponent']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  match['date'],
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${match['score']} - ${match['opponentScore']}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isWin ? AppColors.mintGreen : AppColors.errorRed,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '+${match['xpGained']} XP',
                style: const TextStyle(fontSize: 11, color: AppColors.gold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _getWins() {
    return _matchHistory.where((m) => m['result'] == 'win').length;
  }

  int _getLosses() {
    return _matchHistory.where((m) => m['result'] == 'loss').length;
  }

  int _getWinRate() {
    final wins = _getWins();
    final total = wins + _getLosses();
    return total > 0 ? (wins / total * 100).round() : 0;
  }

  int _getRank() {
    return 42; // Sample rank
  }
}

class MultiplayerGameScreen extends StatefulWidget {
  const MultiplayerGameScreen({super.key});

  @override
  State<MultiplayerGameScreen> createState() => _MultiplayerGameScreenState();
}

class _MultiplayerGameScreenState extends State<MultiplayerGameScreen> {
  int _currentQuestion = 0;
  int _playerScore = 0;
  int _opponentScore = 0;
  int? _selectedAnswer;
  bool _showResult = false;
  bool _isGameOver = false;
  
  final List<Map<String, dynamic>> _questions = [
    {'text': 'What is 15 + 27?', 'options': ['42', '41', '43', '40'], 'answer': 0},
    {'text': 'What is the capital of France?', 'options': ['London', 'Berlin', 'Paris', 'Madrid'], 'answer': 2},
    {'text': 'What is H2O?', 'options': ['Salt', 'Water', 'Oxygen', 'Hydrogen'], 'answer': 1},
  ];

  @override
  Widget build(BuildContext context) {
    if (_isGameOver) {
      return _buildGameOverDialog();
    }
    
    final q = _questions[_currentQuestion];
    final options = q['options'] as List<String>;
    
    return Container(
      width: 350,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildScoreBoard(),
          const SizedBox(height: 20),
          _buildQuestionCard(q),
          const SizedBox(height: 20),
          ...List.generate(options.length, (index) {
            return _buildAnswerButton(options[index], index, q);
          }),
        ],
      ),
    );
  }

  Widget _buildScoreBoard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            const Text('You', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.neonGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$_playerScore',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const Text('VS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Column(
          children: [
            const Text('Opponent', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.neonOrange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$_opponentScore',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> q) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        q['text'],
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAnswerButton(String text, int index, Map<String, dynamic> q) {
    Color buttonColor = AppColors.neonBlue;
    if (_showResult) {
      if (index == q['answer']) {
        buttonColor = AppColors.mintGreen;
      } else if (_selectedAnswer == index) {
        buttonColor = AppColors.errorRed;
      }
    }
    
    return GestureDetector(
      onTap: _showResult ? null : () => _checkAnswer(index, q),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }

  void _checkAnswer(int index, Map<String, dynamic> q) {
    setState(() {
      _showResult = true;
      _selectedAnswer = index;
      
      if (index == q['answer']) {
        _playerScore += 100;
      } else {
        _opponentScore += 100;
      }
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      if (_currentQuestion + 1 >= _questions.length) {
        setState(() {
          _isGameOver = true;
        });
      } else {
        setState(() {
          _currentQuestion++;
          _showResult = false;
          _selectedAnswer = null;
        });
      }
    });
  }

  Widget _buildGameOverDialog() {
    final isWin = _playerScore > _opponentScore;
    
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      title: Text(
        isWin ? 'Victory!' : 'Defeat!',
        style: TextStyle(
          color: isWin ? AppColors.mintGreen : AppColors.errorRed,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isWin ? Icons.emoji_events : Icons.sentiment_dissatisfied,
            size: 60,
            color: isWin ? AppColors.gold : AppColors.errorRed,
          ),
          const SizedBox(height: 10),
          Text(
            'Final Score: $_playerScore - $_opponentScore',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            isWin ? 'You defeated your opponent!' : 'Better luck next time!',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}