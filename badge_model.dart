import 'package:flutter/material.dart';
import 'package:treasure_minds/config/theme.dart';

class BadgeModel {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String category;
  final String rarity;
  final int requiredPoints;
  final int? requiredLevel;
  final int? requiredStreak;
  final String? requiredSubject;
  final int? requiredSubjectScore;
  final String? requiredAchievement;
  final int pointsReward;
  final String imageUrl;
  final DateTime? earnedAt;
  final bool isHidden;
  final bool isLimited;
  final DateTime? expiresAt;

  BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.category,
    required this.rarity,
    required this.requiredPoints,
    this.requiredLevel,
    this.requiredStreak,
    this.requiredSubject,
    this.requiredSubjectScore,
    this.requiredAchievement,
    this.pointsReward = 100,
    this.imageUrl = '',
    this.earnedAt,
    this.isHidden = false,
    this.isLimited = false,
    this.expiresAt,
  });

  // Create from JSON
  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      icon: _getIconData(json['icon'] as String? ?? 'emoji_events'),
      color: _getColor(json['color'] as String? ?? 'gold'),
      category: json['category'] as String? ?? 'Achievements',
      rarity: json['rarity'] as String? ?? 'Common',
      requiredPoints: json['requiredPoints'] as int? ?? 0,
      requiredLevel: json['requiredLevel'] as int?,
      requiredStreak: json['requiredStreak'] as int?,
      requiredSubject: json['requiredSubject'] as String?,
      requiredSubjectScore: json['requiredSubjectScore'] as int?,
      requiredAchievement: json['requiredAchievement'] as String?,
      pointsReward: json['pointsReward'] as int? ?? 100,
      imageUrl: json['imageUrl'] as String? ?? '',
      earnedAt: json['earnedAt'] != null 
          ? DateTime.parse(json['earnedAt'] as String)
          : null,
      isHidden: json['isHidden'] as bool? ?? false,
      isLimited: json['isLimited'] as bool? ?? false,
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': _getIconString(icon),
      'color': _getColorString(color),
      'category': category,
      'rarity': rarity,
      'requiredPoints': requiredPoints,
      'requiredLevel': requiredLevel,
      'requiredStreak': requiredStreak,
      'requiredSubject': requiredSubject,
      'requiredSubjectScore': requiredSubjectScore,
      'requiredAchievement': requiredAchievement,
      'pointsReward': pointsReward,
      'imageUrl': imageUrl,
      'earnedAt': earnedAt?.toIso8601String(),
      'isHidden': isHidden,
      'isLimited': isLimited,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  // Copy with modifications
  BadgeModel copyWith({
    String? id,
    String? name,
    String? description,
    IconData? icon,
    Color? color,
    String? category,
    String? rarity,
    int? requiredPoints,
    int? requiredLevel,
    int? requiredStreak,
    String? requiredSubject,
    int? requiredSubjectScore,
    String? requiredAchievement,
    int? pointsReward,
    String? imageUrl,
    DateTime? earnedAt,
    bool? isHidden,
    bool? isLimited,
    DateTime? expiresAt,
  }) {
    return BadgeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      category: category ?? this.category,
      rarity: rarity ?? this.rarity,
      requiredPoints: requiredPoints ?? this.requiredPoints,
      requiredLevel: requiredLevel ?? this.requiredLevel,
      requiredStreak: requiredStreak ?? this.requiredStreak,
      requiredSubject: requiredSubject ?? this.requiredSubject,
      requiredSubjectScore: requiredSubjectScore ?? this.requiredSubjectScore,
      requiredAchievement: requiredAchievement ?? this.requiredAchievement,
      pointsReward: pointsReward ?? this.pointsReward,
      imageUrl: imageUrl ?? this.imageUrl,
      earnedAt: earnedAt ?? this.earnedAt,
      isHidden: isHidden ?? this.isHidden,
      isLimited: isLimited ?? this.isLimited,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  // Computed properties
  bool get isEarned => earnedAt != null;
  
  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
  
  bool get isAvailable => !isHidden && (!isLimited || !isExpired);
  
  String get rarityLabel {
    switch (rarity.toLowerCase()) {
      case 'common': return 'Common';
      case 'rare': return 'Rare';
      case 'epic': return 'Epic';
      case 'legendary': return 'Legendary';
      default: return 'Common';
    }
  }
  
  Color get rarityColor {
    switch (rarity.toLowerCase()) {
      case 'common': return Colors.grey;
      case 'rare': return AppColors.neonBlue;
      case 'epic': return AppColors.neonPurple;
      case 'legendary': return AppColors.gold;
      default: return Colors.grey;
    }
  }
  
  String get categoryEmoji {
    switch (category.toLowerCase()) {
      case 'learning': return '📚';
      case 'subjects': return '📐';
      case 'streak': return '🔥';
      case 'speed': return '⚡';
      case 'special': return '✨';
      default: return '🏆';
    }
  }

  // Methods
  bool canEarn(int totalPoints, int level, int streak, Map<String, int> subjectScores) {
    if (isEarned) return false;
    if (requiredPoints > 0 && totalPoints < requiredPoints) return false;
    if (requiredLevel != null && level < requiredLevel!) return false;
    if (requiredStreak != null && streak < requiredStreak!) return false;
    if (requiredSubject != null && requiredSubjectScore != null) {
      if ((subjectScores[requiredSubject] ?? 0) < requiredSubjectScore!) return false;
    }
    return true;
  }
  
  BadgeModel earn() {
    return copyWith(earnedAt: DateTime.now());
  }
  
  String getRequirementText() {
    final requirements = <String>[];
    if (requiredPoints > 0) requirements.add('$requiredPoints points');
    if (requiredLevel != null) requirements.add('Level $requiredLevel');
    if (requiredStreak != null) requirements.add('$requiredStreak day streak');
    if (requiredSubject != null && requiredSubjectScore != null) {
      requirements.add('$requiredSubjectScore points in $requiredSubject');
    }
    if (requirements.isEmpty) return 'Complete special challenge';
    return requirements.join(' • ');
  }

  // Helper methods for icon/color conversion
  static IconData _getIconData(String iconString) {
    switch (iconString) {
      case 'emoji_events': return Icons.emoji_events;
      case 'star': return Icons.star;
      case 'calculate': return Icons.calculate;
      case 'menu_book': return Icons.menu_book;
      case 'science': return Icons.science;
      case 'local_fire_department': return Icons.local_fire_department;
      case 'key': return Icons.key;
      case 'map': return Icons.map;
      case 'diamond': return Icons.diamond;
      case 'timer': return Icons.timer;
      case 'psychology': return Icons.psychology;
      case 'auto_awesome': return Icons.auto_awesome;
      case 'workspace_premium': return Icons.workspace_premium;
      case 'bolt': return Icons.bolt;
      case 'favorite': return Icons.favorite;
      default: return Icons.emoji_events;
    }
  }

  static String _getIconString(IconData icon) {
    if (icon == Icons.emoji_events) return 'emoji_events';
    if (icon == Icons.star) return 'star';
    if (icon == Icons.calculate) return 'calculate';
    if (icon == Icons.menu_book) return 'menu_book';
    if (icon == Icons.science) return 'science';
    if (icon == Icons.local_fire_department) return 'local_fire_department';
    if (icon == Icons.key) return 'key';
    if (icon == Icons.map) return 'map';
    if (icon == Icons.diamond) return 'diamond';
    if (icon == Icons.timer) return 'timer';
    if (icon == Icons.psychology) return 'psychology';
    return 'emoji_events';
  }

  static Color _getColor(String colorString) {
    switch (colorString) {
      case 'gold': return AppColors.gold;
      case 'silver': return AppColors.silver;
      case 'bronze': return AppColors.bronze;
      case 'mathOrange': return AppColors.mathOrange;
      case 'englishGreen': return AppColors.englishGreen;
      case 'sciencePurple': return AppColors.sciencePurple;
      case 'neonBlue': return AppColors.neonBlue;
      case 'neonPurple': return AppColors.neonPurple;
      case 'mintGreen': return AppColors.mintGreen;
      case 'warningOrange': return AppColors.warningOrange;
      case 'errorRed': return AppColors.errorRed;
      default: return AppColors.gold;
    }
  }

  static String _getColorString(Color color) {
    if (color == AppColors.gold) return 'gold';
    if (color == AppColors.mathOrange) return 'mathOrange';
    if (color == AppColors.englishGreen) return 'englishGreen';
    if (color == AppColors.sciencePurple) return 'sciencePurple';
    return 'gold';
  }
}

// Badge collection
class BadgeCollection {
  final List<BadgeModel> badges;
  final DateTime lastUpdated;

  BadgeCollection({
    required this.badges,
    required this.lastUpdated,
  });

  factory BadgeCollection.fromJson(Map<String, dynamic> json) {
    return BadgeCollection(
      badges: (json['badges'] as List?)
          ?.map((b) => BadgeModel.fromJson(b as Map<String, dynamic>))
          .toList() ?? [],
      lastUpdated: DateTime.parse(json['lastUpdated'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'badges': badges.map((b) => b.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  // Computed properties
  int get totalCount => badges.length;
  
  int get earnedCount => badges.where((b) => b.isEarned).length;
  
  int get lockedCount => totalCount - earnedCount;
  
  double get completionPercentage => totalCount > 0 ? (earnedCount / totalCount) * 100 : 0;
  
  int get totalPointsReward => badges.where((b) => b.isEarned).fold(0, (sum, b) => sum + b.pointsReward);
  
  List<BadgeModel> get earnedBadges => badges.where((b) => b.isEarned).toList();
  
  List<BadgeModel> get lockedBadges => badges.where((b) => !b.isEarned).toList();
  
  Map<String, List<BadgeModel>> get badgesByCategory {
    final map = <String, List<BadgeModel>>{};
    for (final badge in badges) {
      map.putIfAbsent(badge.category, () => []).add(badge);
    }
    return map;
  }
  
  Map<String, List<BadgeModel>> get badgesByRarity {
    final map = <String, List<BadgeModel>>{};
    for (final badge in badges) {
      map.putIfAbsent(badge.rarity, () => []).add(badge);
    }
    return map;
  }

  // Methods
  BadgeModel? getBadgeById(String id) {
    try {
      return badges.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }
  
  List<BadgeModel> getBadgesByCategory(String category) {
    return badges.where((b) => b.category == category).toList();
  }
  
  List<BadgeModel> getBadgesByRarity(String rarity) {
    return badges.where((b) => b.rarity == rarity).toList();
  }
  
  List<BadgeModel> getRecentlyEarned({int limit = 5}) {
    final earned = badges.where((b) => b.isEarned).toList();
    earned.sort((a, b) => b.earnedAt!.compareTo(a.earnedAt!));
    return earned.take(limit).toList();
  }
  
  List<BadgeModel> getNextEarnableBadges(int totalPoints, int level, int streak, Map<String, int> subjectScores) {
    return badges.where((b) => !b.isEarned && b.canEarn(totalPoints, level, streak, subjectScores)).toList();
  }
  
  BadgeCollection addBadge(BadgeModel badge) {
    final newBadges = List<BadgeModel>.from(badges)..add(badge);
    return BadgeCollection(
      badges: newBadges,
      lastUpdated: DateTime.now(),
    );
  }
  
  BadgeCollection updateBadge(BadgeModel updatedBadge) {
    final index = badges.indexWhere((b) => b.id == updatedBadge.id);
    if (index == -1) return this;
    
    final newBadges = List<BadgeModel>.from(badges);
    newBadges[index] = updatedBadge;
    
    return BadgeCollection(
      badges: newBadges,
      lastUpdated: DateTime.now(),
    );
  }
  
  BadgeCollection earnBadge(String id) {
    final badge = getBadgeById(id);
    if (badge == null || badge.isEarned) return this;
    
    return updateBadge(badge.earn());
  }
}

// Badge progress tracker
class BadgeProgress {
  final BadgeModel badge;
  final int currentProgress;
  final int requiredProgress;

  BadgeProgress({
    required this.badge,
    required this.currentProgress,
    required this.requiredProgress,
  });

  double get progressPercentage => currentProgress / requiredProgress;
  
  bool get isComplete => currentProgress >= requiredProgress;
  
  String get progressText => '$currentProgress / $requiredProgress';
  
  BadgeProgress updateProgress(int newProgress) {
    return BadgeProgress(
      badge: badge,
      currentProgress: newProgress.clamp(0, requiredProgress),
      requiredProgress: requiredProgress,
    );
  }
}

// Predefined badges
class PredefinedBadges {
  static final List<BadgeModel> all = [
    BadgeModel(
      id: 'first_victory',
      name: 'First Victory',
      description: 'Complete your first game',
      icon: Icons.emoji_events,
      color: AppColors.gold,
      category: 'Learning',
      rarity: 'Common',
      requiredPoints: 50,
      pointsReward: 50,
    ),
    BadgeModel(
      id: 'math_novice',
      name: 'Math Novice',
      description: 'Score 100 points in Math',
      icon: Icons.calculate,
      color: AppColors.mathOrange,
      category: 'Subjects',
      rarity: 'Common',
      requiredPoints: 100,
      requiredSubject: 'Math',
      requiredSubjectScore: 100,
      pointsReward: 50,
    ),
    BadgeModel(
      id: 'math_master',
      name: 'Math Master',
      description: 'Score 500 points in Math',
      icon: Icons.star,
      color: AppColors.mathOrange,
      category: 'Subjects',
      rarity: 'Rare',
      requiredPoints: 500,
      requiredSubject: 'Math',
      requiredSubjectScore: 500,
      pointsReward: 100,
    ),
    BadgeModel(
      id: 'math_genius',
      name: 'Math Genius',
      description: 'Score 1000 points in Math',
      icon: Icons.emoji_events,
      color: AppColors.mathOrange,
      category: 'Subjects',
      rarity: 'Epic',
      requiredPoints: 1000,
      requiredSubject: 'Math',
      requiredSubjectScore: 1000,
      pointsReward: 200,
    ),
    BadgeModel(
      id: 'english_novice',
      name: 'English Novice',
      description: 'Score 100 points in English',
      icon: Icons.menu_book,
      color: AppColors.englishGreen,
      category: 'Subjects',
      rarity: 'Common',
      requiredPoints: 100,
      requiredSubject: 'English',
      requiredSubjectScore: 100,
      pointsReward: 50,
    ),
    BadgeModel(
      id: 'english_master',
      name: 'English Master',
      description: 'Score 500 points in English',
      icon: Icons.star,
      color: AppColors.englishGreen,
      category: 'Subjects',
      rarity: 'Rare',
      requiredPoints: 500,
      requiredSubject: 'English',
      requiredSubjectScore: 500,
      pointsReward: 100,
    ),
    BadgeModel(
      id: 'english_genius',
      name: 'English Genius',
      description: 'Score 1000 points in English',
      icon: Icons.emoji_events,
      color: AppColors.englishGreen,
      category: 'Subjects',
      rarity: 'Epic',
      requiredPoints: 1000,
      requiredSubject: 'English',
      requiredSubjectScore: 1000,
      pointsReward: 200,
    ),
    BadgeModel(
      id: 'science_novice',
      name: 'Science Novice',
      description: 'Score 100 points in Science',
      icon: Icons.science,
      color: AppColors.sciencePurple,
      category: 'Subjects',
      rarity: 'Common',
      requiredPoints: 100,
      requiredSubject: 'Science',
      requiredSubjectScore: 100,
      pointsReward: 50,
    ),
    BadgeModel(
      id: 'science_master',
      name: 'Science Master',
      description: 'Score 500 points in Science',
      icon: Icons.star,
      color: AppColors.sciencePurple,
      category: 'Subjects',
      rarity: 'Rare',
      requiredPoints: 500,
      requiredSubject: 'Science',
      requiredSubjectScore: 500,
      pointsReward: 100,
    ),
    BadgeModel(
      id: 'science_genius',
      name: 'Science Genius',
      description: 'Score 1000 points in Science',
      icon: Icons.emoji_events,
      color: AppColors.sciencePurple,
      category: 'Subjects',
      rarity: 'Epic',
      requiredPoints: 1000,
      requiredSubject: 'Science',
      requiredSubjectScore: 1000,
      pointsReward: 200,
    ),
    BadgeModel(
      id: 'streak_7',
      name: 'Streak Master',
      description: 'Maintain a 7-day streak',
      icon: Icons.local_fire_department,
      color: AppColors.warningOrange,
      category: 'Streak',
      rarity: 'Rare',
      requiredPoints: 0,
      requiredStreak: 7,
      pointsReward: 150,
    ),
    BadgeModel(
      id: 'key_collector',
      name: 'Key Collector',
      description: 'Collect 5 keys',
      icon: Icons.key,
      color: AppColors.gold,
      category: 'Special',
      rarity: 'Rare',
      requiredPoints: 0,
      pointsReward: 100,
    ),
    BadgeModel(
      id: 'explorer',
      name: 'Explorer',
      description: 'Complete all levels',
      icon: Icons.map,
      color: AppColors.adventureTeal,
      category: 'Special',
      rarity: 'Epic',
      requiredPoints: 0,
      pointsReward: 500,
    ),
    BadgeModel(
      id: 'legendary',
      name: 'Legendary',
      description: 'Score 5000 points',
      icon: Icons.diamond,
      color: AppColors.gold,
      category: 'Achievements',
      rarity: 'Legendary',
      requiredPoints: 5000,
      pointsReward: 1000,
    ),
  ];
}