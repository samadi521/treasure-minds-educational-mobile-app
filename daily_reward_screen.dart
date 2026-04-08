import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../../providers/auth_provider.dart';

class DailyRewardScreen extends StatefulWidget {
  const DailyRewardScreen({super.key});

  @override
  State<DailyRewardScreen> createState() => _DailyRewardScreenState();
}

class _DailyRewardScreenState extends State<DailyRewardScreen> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  int _currentStreak = 5;
  bool _canClaimToday = true;
  bool _isClaiming = false;
  int _selectedDay = -1;
  
  // Daily rewards data
  final List<DailyReward> _dailyRewards = [
    DailyReward(day: 1, reward: 50, type: 'coins', icon: Icons.monetization_on, color: AppColors.gold, claimed: true),
    DailyReward(day: 2, reward: 75, type: 'coins', icon: Icons.monetization_on, color: AppColors.gold, claimed: true),
    DailyReward(day: 3, reward: 100, type: 'coins', icon: Icons.monetization_on, color: AppColors.gold, claimed: true),
    DailyReward(day: 4, reward: 150, type: 'coins', icon: Icons.monetization_on, color: AppColors.gold, claimed: true),
    DailyReward(day: 5, reward: 200, type: 'coins', icon: Icons.monetization_on, color: AppColors.gold, claimed: true),
    DailyReward(day: 6, reward: 1, type: 'key', icon: Icons.key, color: AppColors.gold, claimed: false),
    DailyReward(day: 7, reward: 500, type: 'coins', icon: Icons.emoji_events, color: AppColors.gold, claimed: false),
    DailyReward(day: 8, reward: 2, type: 'powerup', icon: Icons.bolt, color: AppColors.neonBlue, claimed: false),
    DailyReward(day: 9, reward: 300, type: 'coins', icon: Icons.monetization_on, color: AppColors.gold, claimed: false),
    DailyReward(day: 10, reward: 5, type: 'gems', icon: Icons.diamond, color: AppColors.neonCyan, claimed: false),
    DailyReward(day: 11, reward: 400, type: 'coins', icon: Icons.monetization_on, color: AppColors.gold, claimed: false),
    DailyReward(day: 12, reward: 1, type: 'badge', icon: Icons.emoji_events, color: AppColors.gold, claimed: false),
    DailyReward(day: 13, reward: 500, type: 'coins', icon: Icons.monetization_on, color: AppColors.gold, claimed: false),
    DailyReward(day: 14, reward: 10, type: 'gems', icon: Icons.diamond, color: AppColors.neonCyan, claimed: false),
    DailyReward(day: 15, reward: 1000, type: 'coins', icon: Icons.card_giftcard, color: AppColors.gold, claimed: false),
  ];

  // Monthly bonus rewards
  final List<MonthlyBonus> _monthlyBonuses = [
    MonthlyBonus(day: 7, reward: 500, type: 'coins', icon: Icons.emoji_events, color: AppColors.gold),
    MonthlyBonus(day: 14, reward: 10, type: 'gems', icon: Icons.diamond, color: AppColors.neonCyan),
    MonthlyBonus(day: 21, reward: 1000, type: 'coins', icon: Icons.card_giftcard, color: AppColors.gold),
    MonthlyBonus(day: 28, reward: 2000, type: 'coins', icon: Icons.workspace_premium, color: AppColors.neonPurple),
    MonthlyBonus(day: 30, reward: 50, type: 'gems', icon: Icons.auto_awesome, color: AppColors.gold),
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Daily Rewards'),
        backgroundColor: AppColors.gold,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildStreakHeader(),
                const SizedBox(height: 20),
                _buildDailyRewardsGrid(),
                const SizedBox(height: 20),
                _buildMonthlyBonusSection(),
                const SizedBox(height: 20),
                _buildRewardTips(),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                AppColors.gold,
                AppColors.mintGreen,
                AppColors.neonBlue,
                AppColors.neonPurple,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gold, AppColors.warningOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Current Streak',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      '$_currentStreak days',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daily Login Bonus',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Claim your reward every day to increase your streak!',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                    ),
                  ],
                ),
              ),
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _canClaimToday ? _pulseAnimation.value : 1.0,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: _canClaimToday ? Colors.white : Colors.white.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: _canClaimToday
                            ? const Icon(Icons.card_giftcard, size: 35, color: AppColors.gold)
                            : const Icon(Icons.check_circle, size: 35, color: AppColors.mintGreen),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_canClaimToday)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isClaiming ? null : _claimTodayReward,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.gold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: _isClaiming
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.gold,
                        ),
                      )
                    : const Text(
                        'CLAIM TODAY\'S REWARD',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Reward Claimed for Today',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDailyRewardsGrid() {
    return Container(
      margin: const EdgeInsets.all(16),
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
              Icon(Icons.calendar_today, color: AppColors.neonBlue),
              SizedBox(width: 8),
              Text(
                'Daily Login Calendar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: _dailyRewards.length,
            itemBuilder: (context, index) {
              final reward = _dailyRewards[index];
              final isToday = index + 1 == _currentStreak + 1;
              final isLocked = index + 1 > _currentStreak + 1;
              
              return GestureDetector(
                onTap: () {
                  if (!isLocked && !reward.claimed) {
                    setState(() {
                      _selectedDay = index;
                    });
                    _showRewardPreview(reward);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  transform: Matrix4.identity()..scale(_selectedDay == index ? 1.05 : 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: reward.claimed
                          ? LinearGradient(
                              colors: [AppColors.mintGreen, AppColors.mintGreen.withValues(alpha: 0.7)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : (isToday && !isLocked)
                              ? LinearGradient(
                                  colors: [AppColors.gold, AppColors.warningOrange],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                      color: (!reward.claimed && !isToday) ? Colors.grey.shade100 : null,
                      borderRadius: BorderRadius.circular(15),
                      border: isToday && !reward.claimed
                          ? Border.all(color: AppColors.gold, width: 2)
                          : null,
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Day ${reward.day}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: reward.claimed || isToday ? Colors.white : Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Icon(
                                reward.icon,
                                size: 28,
                                color: reward.claimed || isToday ? Colors.white : Colors.grey,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '+${reward.reward}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: reward.claimed || isToday ? Colors.white : Colors.grey,
                                ),
                              ),
                              Text(
                                reward.type,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: reward.claimed || isToday ? Colors.white70 : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (reward.claimed)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 10,
                                color: AppColors.mintGreen,
                              ),
                            ),
                          ),
                        if (isLocked && !reward.claimed)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: const Icon(
                              Icons.lock,
                              size: 14,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyBonusSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.neonPurple.withValues(alpha: 0.1), AppColors.lavenderPurple.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neonPurple.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.stars, color: AppColors.neonPurple),
              SizedBox(width: 8),
              Text(
                'Monthly Bonus Milestones',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _monthlyBonuses.map((bonus) {
                final isReached = _currentStreak >= bonus.day;
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isReached ? bonus.color : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isReached ? Colors.transparent : Colors.grey.shade200,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        bonus.icon,
                        size: 30,
                        color: isReached ? Colors.white : bonus.color,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Day ${bonus.day}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isReached ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '+${bonus.reward}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isReached ? Colors.white : bonus.color,
                        ),
                      ),
                      Text(
                        bonus.type,
                        style: TextStyle(
                          fontSize: 10,
                          color: isReached ? Colors.white70 : Colors.grey,
                        ),
                      ),
                      if (isReached)
                        const Icon(Icons.check_circle, size: 16, color: Colors.white),
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

  Widget _buildRewardTips() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.1),
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
            child: const Icon(Icons.lightbulb, color: AppColors.gold, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '💡 Pro Tip',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.gold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Login every day to increase your streak and unlock bigger rewards! Day 30 gives a massive 50 Gems bonus!',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _claimTodayReward() async {
    setState(() {
      _isClaiming = true;
    });
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    final todayReward = _dailyRewards[_currentStreak];
    
    // Add reward to user (in real app, update backend)
    setState(() {
      todayReward.claimed = true;
      _currentStreak++;
      _canClaimToday = false;
      _isClaiming = false;
    });
    
    _confettiController.play();
    
    // Show reward dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Text('Reward Claimed! 🎉', style: TextStyle(color: AppColors.gold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: todayReward.color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(todayReward.icon, size: 45, color: todayReward.color),
            ),
            const SizedBox(height: 16),
            Text(
              '+${todayReward.reward} ${todayReward.type}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Day ${todayReward.day} Login Reward',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Streak: $_currentStreak days',
              style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showRewardPreview(DailyReward reward) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Day ${reward.day} Reward'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: reward.color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(reward.icon, size: 35, color: reward.color),
            ),
            const SizedBox(height: 12),
            Text(
              '+${reward.reward} ${reward.type}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              reward.claimed ? 'Already Claimed' : 'Available on Day ${reward.day}',
              style: TextStyle(
                color: reward.claimed ? AppColors.mintGreen : Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _selectedDay = -1;
              });
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class DailyReward {
  final int day;
  final int reward;
  final String type;
  final IconData icon;
  final Color color;
  bool claimed;

  DailyReward({
    required this.day,
    required this.reward,
    required this.type,
    required this.icon,
    required this.color,
    required this.claimed,
  });
}

class MonthlyBonus {
  final int day;
  final int reward;
  final String type;
  final IconData icon;
  final Color color;

  MonthlyBonus({
    required this.day,
    required this.reward,
    required this.type,
    required this.icon,
    required this.color,
  });
}