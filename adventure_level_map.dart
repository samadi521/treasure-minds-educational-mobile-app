import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../../providers/auth_provider.dart';
import '../games/math_game_screen.dart';
import '../games/english_game_screen.dart';
import '../games/science_game_screen.dart';

class AdventureLevelMap extends StatefulWidget {
  const AdventureLevelMap({super.key});

  @override
  State<AdventureLevelMap> createState() => _AdventureLevelMapState();
}

class _AdventureLevelMapState extends State<AdventureLevelMap> with SingleTickerProviderStateMixin {
  late GameProvider _gameProvider;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gameProvider = Provider.of<GameProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    final game = _gameProvider;
    final auth = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: FadeTransition(
        opacity: _controller,
        child: Column(
          children: [
            _buildHeader(context, game, auth),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 8,
                itemBuilder: (ctx, index) {
                  int level = index + 1;
                  bool isUnlocked = level <= game.currentLevel;
                  bool isCurrent = level == game.currentLevel;
                  bool hasKey = level <= game.collectedKeys;
                  bool isCompleted = game.completedLevels.contains(level);
                  
                  return _buildLevelCard(
                    context,
                    level: level,
                    isUnlocked: isUnlocked,
                    isCurrent: isCurrent,
                    hasKey: hasKey,
                    isCompleted: isCompleted,
                    onPlay: () => _playLevel(context, level),
                  );
                },
              ),
            ),
            _buildTreasureDoor(context, game),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, GameProvider game, AuthProvider auth) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.adventureTeal, AppColors.neonCyan],
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
                'Adventure Map',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.key, color: Colors.white, size: 18),
                    const SizedBox(width: 5),
                    Text(
                      '${game.collectedKeys} Keys',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.person, color: Colors.white70),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${auth.userName} • Level ${game.currentLevel}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Icon(Icons.emoji_events, color: AppColors.gold),
                const SizedBox(width: 5),
                Text(
                  '${game.totalScore}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard(
    BuildContext context, {
    required int level,
    required bool isUnlocked,
    required bool isCurrent,
    required bool hasKey,
    required bool isCompleted,
    required VoidCallback onPlay,
  }) {
    Color levelColor;
    if (isCompleted) {
      levelColor = AppColors.mintGreen;
    } else if (isCurrent) {
      levelColor = AppColors.gold;
    } else if (isUnlocked) {
      levelColor = AppColors.mathOrange;
    } else {
      levelColor = Colors.grey;
    }
    
    String subject;
    if (level % 3 == 1) {
      subject = 'Math';
    } else if (level % 3 == 2) {
      subject = 'English';
    } else {
      subject = 'Science';
    }
    
    IconData subjectIcon;
    Color subjectColor;
    switch (subject) {
      case 'Math':
        subjectIcon = Icons.calculate;
        subjectColor = AppColors.mathOrange;
        break;
      case 'English':
        subjectIcon = Icons.menu_book;
        subjectColor = AppColors.englishGreen;
        break;
      default:
        subjectIcon = Icons.science;
        subjectColor = AppColors.sciencePurple;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isCurrent ? Border.all(color: AppColors.gold, width: 2) : null,
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
          // Level Number Circle
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isUnlocked 
                  ? [levelColor, levelColor.withValues(alpha: 0.7)]
                  : [Colors.grey.shade400, Colors.grey.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: isCurrent ? Border.all(color: AppColors.warningOrange, width: 3) : null,
            ),
            child: Center(
              child: hasKey && isUnlocked && !isCompleted
                ? const Icon(Icons.key, color: Colors.white, size: 28)
                : isCompleted
                  ? const Icon(Icons.check_circle, color: Colors.white, size: 32)
                  : Text(
                      level.toString(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 15),
          
          // Level Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Level $level: ${_getLevelName(level)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isUnlocked ? Colors.black : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(subjectIcon, size: 14, color: subjectColor),
                    const SizedBox(width: 4),
                    Text(
                      subject,
                      style: TextStyle(
                        fontSize: 12,
                        color: subjectColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${level * 50} XP',
                      style: TextStyle(
                        fontSize: 12,
                        color: isUnlocked ? Colors.grey.shade600 : Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
                if (isCompleted)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.mintGreen.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'COMPLETED ✓',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mintGreen,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Play Button
          if (isUnlocked)
            ElevatedButton(
              onPressed: onPlay,
              style: ElevatedButton.styleFrom(
                backgroundColor: isCurrent ? AppColors.gold : AppColors.mintGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                isCompleted ? 'Replay' : (isCurrent ? 'Continue' : 'Play'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock, color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Widget _buildTreasureDoor(BuildContext context, GameProvider game) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B4513), Color(0xFF654321)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.gold, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.3),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.door_front_door, size: 50, color: AppColors.gold),
          const SizedBox(height: 10),
          const Text(
            'Treasure Door',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Need ${5 - game.collectedKeys} more keys to open',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: game.collectedKeys / 5,
              backgroundColor: Colors.brown.shade800,
              valueColor: const AlwaysStoppedAnimation(AppColors.gold),
              minHeight: 10,
            ),
          ),
          if (game.collectedKeys >= 5)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      title: const Text('🎉 Treasure Unlocked! 🎉'),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.card_giftcard, size: 60, color: AppColors.gold),
                          SizedBox(height: 10),
                          Text('You found the hidden treasure!'),
                          SizedBox(height: 5),
                          Text('+500 Bonus Points!', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                  _gameProvider.addScore(500, 'Adventure');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('OPEN TREASURE DOOR!'),
              ),
            ),
        ],
      ),
    );
  }

  String _getLevelName(int level) {
    switch (level) {
      case 1: return 'Forest Path';
      case 2: return 'River Crossing';
      case 3: return 'Mountain Trail';
      case 4: return 'Cave Exploration';
      case 5: return 'Desert Journey';
      case 6: return 'Volcano Pass';
      case 7: return 'Ice Kingdom';
      case 8: return 'Treasure Chamber';
      default: return 'Level $level';
    }
  }

  void _playLevel(BuildContext context, int level) {
    String subject;
    if (level % 3 == 1) {
      subject = 'Math';
    } else if (level % 3 == 2) {
      subject = 'English';
    } else {
      subject = 'Science';
    }
    
    Widget gameScreen;
    switch (subject) {
      case 'Math':
        gameScreen = MathGameScreen(level: level);
        break;
      case 'English':
        gameScreen = EnglishGameScreen(level: level);
        break;
      default:
        gameScreen = ScienceGameScreen(level: level);
    }
    
    Navigator.push(context, MaterialPageRoute(builder: (_) => gameScreen)).then((_) {
      setState(() {});
    });
  }
}