import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/game_provider.dart';
import '../../providers/avatar_provider.dart';
import '../../config/theme.dart';
import '../../widgets/game_card.dart';
import '../../widgets/daily_challenge_card.dart';
import '../../widgets/progress_card.dart';
import '../games/math_game_screen.dart';
import '../games/english_game_screen.dart';
import '../games/science_game_screen.dart';
import '../adventure/adventure_level_map.dart';
import '../profile/profile_screen.dart';
import '../leaderboard/leaderboard_screen.dart';
import '../progress/progress_screen.dart';
import '../rewards/badges_screen.dart';
import '../game_modes/game_mode_selection.dart';
import '../puzzle/puzzle_screen.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final game = Provider.of<GameProvider>(context);
    final avatar = Provider.of<AvatarProvider>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.rainbowGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _controller,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildHeader(context, auth, game, avatar),
                  const SizedBox(height: 20),
                  _buildStatsRow(game),
                  const SizedBox(height: 20),
                  DailyChallengeCard(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GameModeSelectionScreen()),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildGameSection(context),
                  const SizedBox(height: 20),
                  ProgressCard(
                    currentLevel: game.currentLevel,
                    collectedKeys: game.collectedKeys,
                    totalKeysNeeded: 5,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AdventureLevelMap()),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildRewardsSection(context),
                  const SizedBox(height: 20),
                  _buildBottomNav(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AuthProvider auth, GameProvider game, AvatarProvider avatar) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.gold, AppColors.warningOrange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(avatar.getAvatarIcon(), color: Colors.white, size: 30),
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.white, AppColors.gold],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  'Treasure Minds',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 8, color: Colors.black26, offset: Offset(1, 1))],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BadgesScreen())),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.gold, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        '${game.totalScore}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.neonPurple,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome Back,',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Text(
                        '${auth.userName}!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(blurRadius: 4, color: Colors.black26)],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.local_fire_department, color: AppColors.gold, size: 16),
                            const SizedBox(width: 5),
                            Text(
                              '${game.dailyStreak} Day Streak!',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const RadialGradient(
                      colors: [AppColors.gold, AppColors.warningOrange],
                      radius: 1.0,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'LVL',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                        Text(
                          '${game.currentLevel}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(GameProvider game) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildStatItem(Icons.key, '${game.collectedKeys}', 'Keys', AppColors.gold),
          _buildStatItem(Icons.emoji_events, '${game.completedLevels.length}/8', 'Levels', AppColors.mintGreen),
          _buildStatItem(Icons.star, '${game.totalScore}', 'Score', AppColors.brightPink),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameSection(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '🎮 Play & Learn 🎮',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black26)],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              GameCard(
                title: 'Math Adventure',
                emoji: '🧮',
                description: 'Solve fun math problems',
                color: AppColors.mathOrange,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MathGameScreen())),
              ),
              const SizedBox(width: 15),
              GameCard(
                title: 'English Quest',
                emoji: '📚',
                description: 'Build vocabulary',
                color: AppColors.englishGreen,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EnglishGameScreen())),
              ),
              const SizedBox(width: 15),
              GameCard(
                title: 'Science Lab',
                emoji: '🔬',
                description: 'Explore science',
                color: AppColors.sciencePurple,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScienceGameScreen())),
              ),
              const SizedBox(width: 15),
              GameCard(
                title: 'Puzzle Challenge',
                emoji: '🧩',
                description: 'Solve brain teasers',
                color: AppColors.puzzlePink,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PuzzleScreen())),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRewardsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BadgesScreen())),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.brightRed, AppColors.warningOrange, AppColors.gold],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '🎁 Rewards & Badges 🎁',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Check Your Achievements!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Collect all badges',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.card_giftcard, color: Colors.white, size: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem('Game Modes', Icons.gamepad, AppColors.neonPurple,
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GameModeSelectionScreen()))),
            _buildNavItem('Leaderboard', Icons.emoji_events, AppColors.gold,
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen()))),
            _buildNavItem('Progress', Icons.show_chart, AppColors.mintGreen,
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressScreen()))),
            _buildNavItem('Badges', Icons.card_giftcard, AppColors.brightRed,
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BadgesScreen()))),
            _buildNavItem('Profile', Icons.person, AppColors.bubblegumPink,
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()))),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}