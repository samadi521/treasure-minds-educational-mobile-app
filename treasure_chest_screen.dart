import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../../providers/auth_provider.dart';

class TreasureChestScreen extends StatefulWidget {
  const TreasureChestScreen({super.key});

  @override
  State<TreasureChestScreen> createState() => _TreasureChestScreenState();
}

class _TreasureChestScreenState extends State<TreasureChestScreen> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _chestController;
  late Animation<double> _chestAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<double> _fadeAnimation;
  
  bool _isOpening = false;
  bool _isOpened = false;
  int _selectedRewardIndex = -1;
  
  final List<TreasureReward> _rewards = [
    TreasureReward(
      id: 1,
      name: 'Golden Key',
      description: 'Unlock special levels',
      icon: Icons.key,
      color: AppColors.gold,
      value: '3 Keys',
      type: 'key',
      amount: 3,
    ),
    TreasureReward(
      id: 2,
      name: 'XP Boost',
      description: 'Double XP for next game',
      icon: Icons.bolt,
      color: AppColors.mathOrange,
      value: '2x XP',
      type: 'boost',
      amount: 2,
    ),
    TreasureReward(
      id: 3,
      name: 'Coin Stash',
      description: 'Add to your balance',
      icon: Icons.monetization_on,
      color: AppColors.gold,
      value: '500 Coins',
      type: 'coin',
      amount: 500,
    ),
    TreasureReward(
      id: 4,
      name: 'Rare Badge',
      description: 'Exclusive treasure badge',
      icon: Icons.emoji_events,
      color: AppColors.neonPurple,
      value: 'Treasure Hunter',
      type: 'badge',
      amount: 1,
    ),
    TreasureReward(
      id: 5,
      name: 'Power-Up',
      description: 'Skip one wrong answer',
      icon: Icons.flash_on,
      color: AppColors.neonGreen,
      value: '3 Power-Ups',
      type: 'powerup',
      amount: 3,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _chestController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _chestAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _chestController, curve: Curves.elasticOut),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(parent: _chestController, curve: Curves.easeInOut),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _chestController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _chestController.dispose();
    super.dispose();
  }

  void _openChest() {
    setState(() {
      _isOpening = true;
    });
    _chestController.forward();
    
    // Simulate chest opening delay
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _isOpened = true;
      });
      _confettiController.play();
    });
  }

  void _claimReward(TreasureReward reward, int index) {
    setState(() {
      _selectedRewardIndex = index;
    });
    
    // Show reward claimed dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Row(
          children: [
            Icon(reward.icon, color: reward.color),
            const SizedBox(width: 10),
            const Text('Reward Claimed!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: reward.color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(reward.icon, size: 45, color: reward.color),
            ),
            const SizedBox(height: 16),
            Text(
              reward.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You received ${reward.value}!',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              reward.description,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Treasure Chest'),
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
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildTreasureChest(),
                  const SizedBox(height: 30),
                  if (_isOpened) _buildRewardsGrid(),
                  if (_isOpened) const SizedBox(height: 20),
                  if (!_isOpened && !_isOpening)
                    _buildOpenButton(),
                  if (_isOpening && !_isOpened)
                    _buildOpeningAnimation(),
                  if (_isOpened)
                    _buildCollectAllButton(),
                  const SizedBox(height: 30),
                ],
              ),
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
                AppColors.mathOrange,
                AppColors.mintGreen,
                AppColors.neonPurple,
              ],
              numberOfParticles: 100,
              gravity: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreasureChest() {
    return AnimatedBuilder(
      animation: _chestController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _shakeAnimation.value * (_isOpening ? 0.2 : 0),
          child: Center(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B4513), Color(0xFF654321)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Chest body
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: 180,
                          height: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFF5D4037),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      // Chest lid
                      Positioned(
                        top: 0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          transform: Matrix4.identity()
                            ..rotateX(_isOpening ? -1.5 : 0),
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 180,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF8B4513), Color(0xFF6D4C41)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              border: Border.all(color: AppColors.gold, width: 2),
                            ),
                          ),
                        ),
                      ),
                      // Chest lock
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gold.withValues(alpha: 0.5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      // Glow effect when opened
                      if (_isOpened)
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gold.withValues(alpha: 0.8),
                                blurRadius: 50,
                                spreadRadius: 20,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (!_isOpened)
                  Text(
                    _isOpening ? 'Opening...' : 'Click to open the treasure chest!',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                if (_isOpened)
                  const Text(
                    '✨ Treasure Unlocked! ✨',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gold,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOpenButton() {
    return SizedBox(
      width: 200,
      height: 55,
      child: ElevatedButton(
        onPressed: _openChest,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          '🔓 OPEN CHEST',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildOpeningAnimation() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const CircularProgressIndicator(
          color: AppColors.gold,
        ),
        const SizedBox(height: 10),
        const Text(
          'Opening treasure chest...',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildRewardsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Your Reward',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.neonPurple,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select one item from the treasure chest',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemCount: _rewards.length,
          itemBuilder: (context, index) {
            final reward = _rewards[index];
            final isSelected = _selectedRewardIndex == index;
            
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              transform: Matrix4.identity()..scale(isSelected ? 1.05 : 1.0),
              child: GestureDetector(
                onTap: () => _claimReward(reward, index),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isSelected
                          ? [reward.color.withValues(alpha: 0.2), reward.color.withValues(alpha: 0.1)]
                          : [Colors.white, Colors.grey.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? reward.color : Colors.grey.shade200,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected ? reward.color.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: reward.color.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          reward.icon,
                          size: 35,
                          color: reward.color,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        reward.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? reward.color : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reward.value,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: reward.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reward.description,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (isSelected)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: reward.color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'SELECTED',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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
    );
  }

  Widget _buildCollectAllButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _selectedRewardIndex == -1 ? null : () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'COLLECT REWARD',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class TreasureReward {
  final int id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String value;
  final String type;
  final int amount;

  TreasureReward({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.value,
    required this.type,
    required this.amount,
  });
}