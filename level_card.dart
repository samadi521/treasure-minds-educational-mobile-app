import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/theme.dart';

class LevelCard extends StatelessWidget {
  final int level;
  final String title;
  final String description;
  final bool isUnlocked;
  final bool isCompleted;
  final bool isCurrent;
  final VoidCallback onTap;
  final int? xpReward;
  final int? keyReward;
  final String? estimatedTime;

  const LevelCard({
    super.key,
    required this.level,
    required this.title,
    required this.description,
    required this.isUnlocked,
    required this.isCompleted,
    required this.isCurrent,
    required this.onTap,
    this.xpReward,
    this.keyReward,
    this.estimatedTime,
  });

  @override
  Widget build(BuildContext context) {
    Color getLevelColor() {
      if (isCompleted) return AppColors.mintGreen;
      if (isCurrent) return AppColors.gold;
      if (isUnlocked) return AppColors.neonBlue;
      return Colors.grey;
    }

    final levelColor = getLevelColor();
    
    return GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()..scale(isCurrent ? 1.02 : 1.0),
        margin: const EdgeInsets.only(bottom: 16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                levelColor.withValues(alpha: 0.1),
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isCurrent ? levelColor : Colors.grey.shade200,
              width: isCurrent ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isCurrent ? levelColor.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Level number circle
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
                        border: isCurrent ? Border.all(color: Colors.white, width: 2) : null,
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(Icons.check, color: Colors.white, size: 30)
                            : Text(
                                level.toString(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Level info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isUnlocked ? Colors.black87 : Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (isCurrent)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: levelColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'CURRENT',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              if (isCompleted)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.mintGreen,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'COMPLETED',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 12,
                              color: isUnlocked ? Colors.grey.shade600 : Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // Rewards row
                          Wrap(
                            spacing: 12,
                            children: [
                              if (xpReward != null)
                                _buildRewardChip(Icons.star, '+$xpReward XP', AppColors.gold),
                              if (keyReward != null)
                                _buildRewardChip(Icons.key, '+$keyReward Key', AppColors.adventureTeal),
                              if (estimatedTime != null)
                                _buildRewardChip(Icons.timer, estimatedTime!, Colors.grey),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Action button
                    if (isUnlocked && !isCompleted)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: levelColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: levelColor.withValues(alpha: 0.3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 28,
                        ),
                      )
                    else if (isCompleted)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.mintGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.replay,
                          color: Colors.white,
                          size: 24,
                        ),
                      )
                    else if (!isUnlocked)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// Compact level card for grid views
class CompactLevelCard extends StatelessWidget {
  final int level;
  final bool isUnlocked;
  final bool isCompleted;
  final VoidCallback onTap;

  const CompactLevelCard({
    super.key,
    required this.level,
    required this.isUnlocked,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color getLevelColor() {
      if (isCompleted) return AppColors.mintGreen;
      if (isUnlocked) return AppColors.neonBlue;
      return Colors.grey;
    }

    final levelColor = getLevelColor();

    return GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isUnlocked
                ? [levelColor, levelColor.withValues(alpha: 0.7)]
                : [Colors.grey.shade400, Colors.grey.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: levelColor.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isCompleted)
                    const Icon(Icons.check_circle, color: Colors.white, size: 40)
                  else
                    Text(
                      level.toString(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    isCompleted ? 'Completed' : 'Level $level',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            if (!isUnlocked && !isCompleted)
              Positioned(
                top: 8,
                right: 8,
                child: const Icon(Icons.lock, size: 16, color: Colors.white70),
              ),
          ],
        ),
      ),
    );
  }
}

// Horizontal level card for level selection
class HorizontalLevelCard extends StatelessWidget {
  final int level;
  final String title;
  final bool isUnlocked;
  final bool isCompleted;
  final VoidCallback onTap;

  const HorizontalLevelCard({
    super.key,
    required this.level,
    required this.title,
    required this.isUnlocked,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color getLevelColor() {
      if (isCompleted) return AppColors.mintGreen;
      if (isUnlocked) return AppColors.neonBlue;
      return Colors.grey;
    }

    final levelColor = getLevelColor();

    return GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isUnlocked
                ? [levelColor, levelColor.withValues(alpha: 0.7)]
                : [Colors.grey.shade400, Colors.grey.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: levelColor.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isCompleted)
              const Icon(Icons.check_circle, color: Colors.white, size: 40)
            else
              Text(
                level.toString(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              isCompleted ? 'Completed' : 'Level $level',
              style: const TextStyle(fontSize: 10, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

// Level progress indicator
class LevelProgressIndicator extends StatelessWidget {
  final int currentLevel;
  final int totalLevels;
  final double progress;

  const LevelProgressIndicator({
    super.key,
    required this.currentLevel,
    required this.totalLevels,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Level $currentLevel',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.neonPurple,
              ),
            ),
            Text(
              'Level $totalLevels',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation(AppColors.gold),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

// Level unlock requirement card
class LevelUnlockRequirement extends StatelessWidget {
  final int requiredLevel;
  final int requiredKeys;
  final int currentLevel;
  final int currentKeys;

  const LevelUnlockRequirement({
    super.key,
    required this.requiredLevel,
    required this.requiredKeys,
    required this.currentLevel,
    required this.currentKeys,
  });

  @override
  Widget build(BuildContext context) {
    final levelMet = currentLevel >= requiredLevel;
    final keysMet = currentKeys >= requiredKeys;
    final isUnlocked = levelMet && keysMet;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isUnlocked ? AppColors.mintGreen : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Unlock Requirements',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          _buildRequirementRow(
            'Reach Level $requiredLevel',
            levelMet,
            Icons.arrow_upward,
          ),
          const SizedBox(height: 8),
          _buildRequirementRow(
            'Collect $requiredKeys Keys',
            keysMet,
            Icons.key,
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementRow(String text, bool isMet, IconData icon) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 18,
          color: isMet ? AppColors.mintGreen : Colors.grey,
        ),
        const SizedBox(width: 8),
        Icon(icon, size: 14, color: isMet ? AppColors.mintGreen : Colors.grey),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: isMet ? Colors.black87 : Colors.grey,
            decoration: isMet ? TextDecoration.lineThrough : null,
          ),
        ),
      ],
    );
  }
}